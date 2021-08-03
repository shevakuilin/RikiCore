////  Riki
//
//  RJSBridgePlugin.m
//
//  Copyright (c) 2021-Present Guanghe Xinzhi (Beijing) Technology Co., Ltd.
//
//  - https://github.com/guanghetv
//
//  The software is available under the Apache 2.0 license. See the LICENSE file
//  for more info.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Simon.Hu on 2021/3/17.
//  
//

#import "RJSBridgePlugin.h"

#import <WebKit/WebKit.h>
#import "RWebKitEvaluateJSUtil.h"
#import "RJSBridgeModel.h"
#import "RFuncPivot.h"
#import "RExecuteLog.h"
#import "RLog.h"
#import "RPass.h"

static NSString * const kRJSBridgePluginName = @"RKBridge";
static NSString * const kRJSBridgeDefaultMoudleName = @"RKDefault";

typedef void (^RJSBridgeCallBack)(NSDictionary *responseData);

@interface RJSBridgePlugin ()

@property (nonatomic, weak) RWebKitService *service;

// 消息发送队列
@property (nonatomic, strong) NSOperationQueue *dispatchQueue;
// 原生回调列表
@property (nonatomic, strong) NSMutableDictionary *callBackCache;

// 桥是否安装完毕
@property (nonatomic, assign) BOOL bridgeReadyComplete;
// 缓存 桥建立前的方法
@property (nonatomic, strong) NSMutableArray<RJSBridgeModel *> *callJSCache;

@property (nonatomic, assign) NSInteger uniqueId;

@end

@implementation RJSBridgePlugin

- (NSString *)pluginName {
    return kRJSBridgePluginName;
}

- (instancetype)initWithWebKitService:(RWebKitService *)service {
    if (self = [super init]) {
        _service = service;
        _dispatchQueue = [NSOperationQueue new];
        _bridgeReadyComplete = NO;
        _callJSCache = [NSMutableArray array];
        _uniqueId = 1;
        // 方法串行
        _dispatchQueue.maxConcurrentOperationCount = 1;
        _callBackCache = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)registerUserScriptWithWebView:(WKWebView *)webView {
    NSString *bridgeJSString = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"RKBridge" ofType:@"js"]
                                                               encoding:NSUTF8StringEncoding error:NULL];
    [RWebKitEvaluateJSUtil injectJavaScriptAtStart:bridgeJSString byWebView:webView];
}

// 监听处理 js 回调信息
- (void)handlerMessageFromJS:(WKScriptMessage *)message {
    if (![message.name isEqualToString:kRJSBridgePluginName]
        || ![message.body isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    // 接受 js 发送回来的消息
    RJSBridgeModel *model = [[RJSBridgeModel alloc] initWithDictionary:(NSDictionary *)message.body];
    __weak typeof(self) weakSelf = self;
    [self.dispatchQueue addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _callNativeFunction:model];
    }];
}

// 原生调用 js 方法
- (void)callModule:(NSString *)module eventName:(NSString *)eventName data:(id)data callBack:(void (^)(NSDictionary * _Nullable))callBack {
    
    RJSBridgeModel *model = [RJSBridgeModel new];
    model.moduleName = module ?: kRJSBridgeDefaultMoudleName;
    model.eventName = eventName;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    model.callId = [NSString stringWithFormat:@"rk_%@_%@_%ld_%.f", model.moduleName, model.eventName, ++self.uniqueId, time];
    
    NSString *moduleNameKey = [NSString stringWithFormat:@"%@_%@", module ?: kRJSBridgeDefaultMoudleName, eventName];
    if (callBack) {
        self.callBackCache[moduleNameKey] = [callBack copy];
    }
    
    RJSBridgeDataModel *dataModel = [RJSBridgeDataModel new];
    dataModel.data = data;
    model.messageData = dataModel;
    
    // 桥未建立时，将方法进行缓存
    if (!self.bridgeReadyComplete) {
        @synchronized (self) {
            [self.callJSCache addObject:model];
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.dispatchQueue addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _dispatchJSFunction:model];
    }];
    
}

#pragma mark - 私有方法
// js调用原生方法
- (void)_callNativeFunction:(RJSBridgeModel *)messageModel {
    
    // 处理桥完成事件
    if ([messageModel.moduleName isEqualToString:@"RKBridgeSetup"]
        && [messageModel.eventName isEqualToString:@"bridgeReady"]) {
        self.bridgeReadyComplete = YES;
        
        id completeData;
        if ([self.service.webViewDelegate respondsToSelector:@selector(bridgeReadyCompelte)]) {
            completeData = [self.service.webViewDelegate bridgeReadyCompelte];
        }
        
        RExecuteLog *log = [RLog executeLogWithCode:@(RCodeExecuteSuccess) content:nil];
        [self responseJSMethodResponseId:messageModel.callId.copy result:completeData ?: @"bridge setup complete" error:nil log:log];
        
        [self pushCallJSMethodFromCache];
        
        return;
    }
    
    if (messageModel.responseId.length > 0) {
        // native调用js后的回调 (暂时没有调用)
        NSString *callBackKey = [NSString stringWithFormat:@"%@_%@", messageModel.moduleName ?: kRJSBridgeDefaultMoudleName, messageModel.eventName];
        RJSBridgeCallBack callback = self.callBackCache[callBackKey];
        if (callback) {
            callback(messageModel.messageData.converToDictionary);
        }
        [self.callBackCache removeObjectForKey:callBackKey];
    }
    
    // 将本次通信的service转嫁到执行层
    [RPass passService:self.service];
    // 发送信息，动态解析
    __weak typeof(self) weakSelf = self;
    // 将js端的callId转化为responseId
    __block NSString *responseId = [messageModel.callId copy];
    //TODO: 开关
    if (0) {
        [RFuncPivot executeNativeMethodWithModel:messageModel
                                      completion:^(RExecuteLog *executeLog, id returnValue) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            RJSBridgeModel *model = [RJSBridgeModel new];
            model.responseId = responseId;
            
            RJSBridgeDataModel *dataModel = [RJSBridgeDataModel new];
            dataModel.code = executeLog.code.unsignedIntegerValue;
            dataModel.msg = executeLog.content;
            
            dataModel.data = returnValue;
            model.messageData = dataModel;
            
            [strongSelf _dispatchJSFunction:model];
        }];
    } else {
        
        NSOperationQueue *excuteQueue = [NSOperationQueue mainQueue];
        [excuteQueue addOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [RFuncPivot executeNativeMethodWithModel:[strongSelf getInvokeModel:messageModel]
                                             success:^(id result) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                RExecuteLog *log = [RLog executeLogWithCode:@(RCodeExecuteSuccess) content:nil];
                [strongSelf responseJSMethodResponseId:responseId result:result error:nil log:log];
            } failure:^(id error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSString *errorString = [error isKindOfClass:[NSString class]] ? error : nil;
                RExecuteLog *log = [RLog executeLogWithCode:@(RCodeLogicIncorrect) content:errorString];
                [strongSelf responseJSMethodResponseId:responseId result:nil error:error log:log];
            } completion:^(RExecuteLog *executeLog, id returnValue) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf responseJSMethodResponseId:responseId result:returnValue error:nil log:executeLog];
            }];
        }];
    }
    
}

- (void)pushCallJSMethodFromCache {
    [self.callJSCache enumerateObjectsUsingBlock:^(RJSBridgeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __weak typeof(self) weakSelf = self;
        [self.dispatchQueue addOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf _dispatchJSFunction:obj];
        }];
    }];
    
    [self.callJSCache removeAllObjects];
}

- (RJSBridgeModel *)getInvokeModel:(RJSBridgeModel *)originModel {
    RJSBridgeModel *invokeModel = [RJSBridgeModel new];
    invokeModel.callId = [originModel.callId copy];
    invokeModel.moduleName = originModel.moduleName;
    //TODO: 去掉该方法，添加iOSEventName方法，供H5使用 （过度方案）
    invokeModel.eventName = [NSString stringWithFormat:@"%@:success:failure:", originModel.eventName];
//    invokeModel.eventName = [originModel.eventName copy];
    invokeModel.responseId = [originModel.responseId copy];
    invokeModel.messageData = originModel.messageData;
    
    return invokeModel;
}

// 给 js 的回调
- (void)responseJSMethodResponseId:(NSString *)responseId result:(id)result error:(id)error log:(RExecuteLog *)log {
    RJSBridgeModel *model = [RJSBridgeModel new];
    model.responseId = responseId;
    
    RJSBridgeDataModel *dataModel = [RJSBridgeDataModel new];
    if (log.code.unsignedIntegerValue == RCodeExecuteSuccess && !error) {
        // 通信+业务成功
        dataModel.code = 200;
        dataModel.msg = @"success";
        dataModel.data = result;
    } else if (log.code.unsignedIntegerValue == RCodeLogicIncorrect && error) {
        // 业务层报错
        dataModel.code = RCodeLogicIncorrect;
        dataModel.msg = @"fail";
        dataModel.data = error;
    } else {
        // 通信层报错
        dataModel.code = log.code.unsignedIntegerValue;
        dataModel.msg = @"fail";
        dataModel.data = log.content;
    }
    
    model.messageData = dataModel;
    
    [self _dispatchJSFunction:model];
}

// 调用 js 方法
- (void)_dispatchJSFunction:(RJSBridgeModel *)messageModel {
    NSMutableDictionary *messageJson = [NSMutableDictionary dictionary];
    messageJson[@"callId"] = messageModel.callId;
    messageJson[@"responseId"] = messageModel.responseId;
    messageJson[@"moduleName"] = messageModel.moduleName;
    messageJson[@"eventName"] = messageModel.eventName;
    messageJson[@"messageData"] = messageModel.messageData.converToDictionary;
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:messageJson options:0 error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [RWebKitEvaluateJSUtil evaluateJsFunction:@"window.RKBridge.receiveMessageFromNative"
                               withJsonString:jsonString
                                    byWebView:self.service.webView
                            completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

@end

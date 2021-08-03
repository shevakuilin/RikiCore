//
//  Riki
//
//  RWebKitService.m
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

#import "RWebKitService.h"

#pragma mark - utils
#import "RPass.h"
#import <WebKit/WebKit.h>
#import "WKWebView+WebKitService.h"

#pragma mark - RWebKitMessageHandlerDelegate
// 转发 WKScriptMessageHandler，解决循环引用问题
@interface RWebKitMessageHandlerDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> handlerDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end

@implementation RWebKitMessageHandlerDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    if (self = [super init]) {
        _handlerDelegate = delegate;
    }
    
    return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    [self.handlerDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

#pragma mark - RWebKitService
@interface RWebKitService () <WKScriptMessageHandler>

@property (nonatomic, weak, readwrite) WKWebView *webView;

/// 插件实例缓存
@property (nonatomic, strong) NSMutableDictionary *pluginsMap;

@end

@implementation RWebKitService

#pragma mark - 生命周期
// 初始化service
+ (instancetype)serviceForWebView:(WKWebView *)webView {
    RWebKitService *service = [RWebKitService new];
    webView.rService = service;
    service.webView = webView;
    service.pluginsMap = [NSMutableDictionary dictionary];
    return service;
}

- (void)dealloc {
    // 移除所有的handler
    for (NSString *pluginKey in self.pluginsMap.allKeys) {
        id<RWebKitServiceProtocol> plugin = self.pluginsMap[pluginKey];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:plugin.pluginName];
    }
}

#pragma mark - 插件相关
- (void)registerWebPlugin:(id<RWebKitServiceProtocol>)plugin {
    self.pluginsMap[plugin.pluginName] = plugin;
}

- (void)registerWebPlugins:(NSArray<id<RWebKitServiceProtocol>> *)plugins {
    for (id<RWebKitServiceProtocol> plugin in plugins) {
        self.pluginsMap[plugin.pluginName] = plugin;
    }
}

#pragma mark - js 执行相关
- (void)callModule:(NSString *)module eventName:(NSString *)eventName data:(id)data callBack:(void (^)(NSDictionary * _Nullable responseData))callBack {
    // 向插件分发事件
    for (NSString *pluginKey in self.pluginsMap.allKeys) {
        id<RWebKitServiceProtocol> plugin = self.pluginsMap[pluginKey];
        if ([plugin respondsToSelector:@selector(callModule:eventName:data:callBack:)]) {
            [plugin callModule:module eventName:eventName data:data callBack:callBack];
        }
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler {
    // 向插件分发事件
    for (NSString *pluginKey in self.pluginsMap.allKeys) {
        id<RWebKitServiceProtocol> plugin = self.pluginsMap[pluginKey];
        if ([plugin respondsToSelector:@selector(evaluateJavaScript:completionHandler:)]) {
            [plugin evaluateJavaScript:javaScriptString completionHandler:completionHandler];
        }
    }
}

// 注册 js 消息句柄
- (void)addWebViewMessageHandlerWithConfiguration:(WKWebViewConfiguration *)configuration {
    RWebKitMessageHandlerDelegate *handler = [[RWebKitMessageHandlerDelegate alloc] initWithDelegate:self];
    
    for (NSString *pluginKey in self.pluginsMap.allKeys) {
        id<RWebKitServiceProtocol> plugin = self.pluginsMap[pluginKey];
        NSString *handlerName = @"";
        if ([plugin respondsToSelector:@selector(pluginName)]) {
            handlerName = plugin.pluginName;
        }
        
        if ([plugin respondsToSelector:@selector(registerUserScriptWithWebView:)]) {
            [plugin registerUserScriptWithWebView:self.webView];
        }
        
        [configuration.userContentController addScriptMessageHandler:handler name:handlerName];
    }
}

// 接受 handler 发送回来的数据
- (void)userContentController:(nonnull WKUserContentController *)userContentController
      didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    // 向插件分发事件
    for (NSString *pluginKey in self.pluginsMap.allKeys) {
        id<RWebKitServiceProtocol> plugin = self.pluginsMap[pluginKey];
        if ([plugin respondsToSelector:@selector(handlerMessageFromJS:)]) {
            [plugin handlerMessageFromJS:message];
        }
    }
}

#pragma mark - 标识符

- (NSString *)hashIdentifier {
    return [NSString stringWithFormat:@"%ld", (long)self.hash];
}

@end

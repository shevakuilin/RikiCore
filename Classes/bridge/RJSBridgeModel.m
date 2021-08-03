////  Riki
//
//  RJSBridgeModel.m
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

#import "RJSBridgeModel.h"

RJSMsgResultType const RJSMsgResultTypeSuccess = @"success";
RJSMsgResultType const RJSMsgResultTypeFail = @"fail";

#pragma mark - RJSBridgeDataModel
@implementation RJSBridgeDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _code = 0;
        _msg = RJSMsgResultTypeSuccess;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary * _Nullable)dataDic {
    if (self = [super init]) {
        if (![dataDic[@"code"] isKindOfClass:[NSNull class]]) {
            _code = [dataDic[@"code"] integerValue];
        }
        if (![dataDic[@"msg"] isKindOfClass:[NSNull class]]) {
            _msg = [dataDic[@"msg"] copy];
        }
        if (![dataDic[@"data"] isKindOfClass:[NSNull class]]) {
            _data = [dataDic[@"data"] copy];
        }
    }
    
    return self;
}

- (NSDictionary *)converToDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.code) {
        dic[@"code"] = @(self.code);
    }
    
    if (self.msg) {
        dic[@"msg"] = self.msg;
    }
    
    if (self.data) {
        dic[@"data"] = self.data;
    }
    
    return [dic copy];
}

@end

#pragma mark - RJSBridgeModel
@implementation RJSBridgeModel

- (instancetype)initWithDictionary:(NSDictionary *)message {
    if (self = [super init]) {
        if (![message[@"callId"] isKindOfClass:[NSNull class]]) {
            _callId = [message[@"callId"] copy];
        }
        if (![message[@"responseId"] isKindOfClass:[NSNull class]]) {
            _responseId = [message[@"responseId"] copy];
        }
        if (![message[@"moduleName"] isKindOfClass:[NSNull class]]) {
            _moduleName = [message[@"moduleName"] copy];
        }
        if (![message[@"eventName"] isKindOfClass:[NSNull class]]) {
            _eventName = [message[@"eventName"] copy];
        }
        if (![message[@"messageData"] isKindOfClass:[NSNull class]]) {
            _messageData = [[RJSBridgeDataModel alloc] initWithDictionary:message[@"messageData"]];
        }
    }
    
    return self;
}


@end

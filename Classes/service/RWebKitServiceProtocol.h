//
//  Riki
//
//  RWebKitServiceProtocol.h
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
    


#import <Foundation/Foundation.h>

@class WKWebView, RWebKitService, WKScriptMessage;

NS_ASSUME_NONNULL_BEGIN

/// Web 服务插件接口
@protocol RWebKitServiceProtocol <NSObject>

/// 插件初始化
/// @param service 注入的Web服务实例
- (instancetype)initWithWebKitService:(RWebKitService *)service;

/// 插件名称
- (NSString *)pluginName;

#pragma mark - 可选方法
@optional

/// 插件注册自定义的user script
- (void)registerUserScriptWithWebView:(WKWebView *)webView;

/// 根据 模块、方法、参数的形式向 js 发送消息
/// @param module 模块名
/// @param eventName 方法名
/// @param data 数据
/// @param callBack 回调
- (void)callModule:(NSString *)module eventName:(NSString *)eventName data:(id)data callBack:(void (^)(NSDictionary * _Nullable responseData))callBack;

/// 向 js 发送信息
/// @param javaScriptString js 串
/// @param completionHandler 完成回调
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(id _Nullable, NSError * _Nullable))completionHandler;

/// 处理 js 回调回来的消息
/// @param message 消息
- (void)handlerMessageFromJS:(WKScriptMessage *)message;

@end

NS_ASSUME_NONNULL_END

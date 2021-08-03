//
//  Riki
//
//  RWebKitService.h
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

#import "RWebKitServiceProtocol.h"
#import "RWebViewDelegate.h"
@class WKWebView, WKWebViewConfiguration;

NS_ASSUME_NONNULL_BEGIN

/// WebKit 核心服务
@interface RWebKitService : NSObject

/// 挂载的 webView
@property (nonatomic, weak, readonly) WKWebView *webView;

/// service 哈希标识符
@property (nonatomic, copy, readonly) NSString *hashIdentifier;

@property (nonatomic, weak) id<RWebViewDelegate> webViewDelegate;

/// 根据 WebView 创建服务
/// @param webView 目标webview
+ (instancetype)serviceForWebView:(WKWebView *)webView;

/// 注册 Web 服务相关的插件
- (void)registerWebPlugin:(id<RWebKitServiceProtocol>)plugin;

/// 批量注册 Web 插件
/// @param plugins 插件数组
- (void)registerWebPlugins:(NSArray<id<RWebKitServiceProtocol>> *)plugins;

#pragma mark - js 消息相关

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


/// 注册 js 消息句柄
- (void)addWebViewMessageHandlerWithConfiguration:(WKWebViewConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END

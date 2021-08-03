//
//  Riki
//
//  RWebKitEvaluateJSUtil.h
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

@class WKWebView;

NS_ASSUME_NONNULL_BEGIN

/// js 代码执行工具
@interface RWebKitEvaluateJSUtil : NSObject

/// 注入代码在document元素生成之后，其他资源加载之前
/// @param javaScriptString 需要注入的js代码
/// @param webView 目标 webview
+ (void)injectJavaScriptAtStart:(NSString *)javaScriptString byWebView:(WKWebView *)webView;

/// 注入代码在document加载完成，任意子资源加载完成之前
/// @param javaScriptString 需要注入的js代码
/// @param webView 目标 webview
+ (void)injectJavaScriptAtEnd:(NSString *)javaScriptString byWebView:(WKWebView *)webView;

/// 执行 js 片段
/// @param javaScriptString js 代码
/// @param webView 目标 webview
/// @param completionHandler 回调
+ (void)evaluateJavaScript:(NSString *)javaScriptString byWebView:(WKWebView *)webView completionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;

+ (void)evaluateJsFunction:(NSString *)function withJsonString:(NSString *)jsonString byWebView:(WKWebView *)webView completionHandler:(void (^)(_Nullable id result, NSError * _Nullable error))completionHandler;


/// base64 解密
/// @param base64String base64字符串
+ (id)decodingBase64String:(NSString *)base64String;

/// base64 加密
/// @param resString 需要加密的字符串
+ (NSString *)encodingBase64String:(NSString *)resString;

@end

NS_ASSUME_NONNULL_END

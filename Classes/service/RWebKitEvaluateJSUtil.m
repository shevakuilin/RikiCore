//
//  Riki
//
//  RWebKitEvaluateJSUtil.m
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

#import "RWebKitEvaluateJSUtil.h"

#import <WebKit/WebKit.h>

@implementation RWebKitEvaluateJSUtil

// 注入
+ (void)injectJavaScriptAtStart:(NSString *)javaScriptString byWebView:(WKWebView *)webView {
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:userScript];
}

+ (void)injectJavaScriptAtEnd:(NSString *)javaScriptString byWebView:(WKWebView *)webView {
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:userScript];
}

// 执行
+ (void)evaluateJavaScript:(NSString *)javaScriptString byWebView:(WKWebView *)webView completionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler {
    
    // 主线程调用 js
    if ([[NSThread currentThread] isMainThread]) {
        [webView evaluateJavaScript:javaScriptString
            completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (completionHandler) {
                completionHandler(result, error);
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (completionHandler) {
                    completionHandler(result, error);
                }
            }];
        });
    }
}

// 执行function("xxxx") 方法
+ (void)evaluateJsFunction:(NSString *)function withJsonString:(NSString *)jsonString byWebView:(WKWebView *)webView completionHandler:(void (^)(_Nullable id result, NSError * _Nullable error))completionHandler {
    
    NSString *msgJsonString = [self encodingBase64String:jsonString];
    NSString *jsString = [NSString stringWithFormat:@"%@('%@')", function, msgJsonString];
    [self evaluateJavaScript:jsString byWebView:webView completionHandler:completionHandler];
}

// 将base64字符串解码成字典或字符串
+ (id)decodingBase64String:(NSString *)base64String {
    if (base64String.length == 0) {
        return nil;
    }
    
    NSData *stringData = [[NSData alloc] initWithBase64EncodedString:base64String
                                                             options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSAssert(stringData.length > 0, @"base64解码错误");
    
    if (stringData.length > 0) {
        NSError *err;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:stringData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
        
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        NSString *stringObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (err
            && ![jsonObject isKindOfClass:[NSDictionary class]]
            && ![jsonObject isKindOfClass:[NSArray class]]) {
            
            //尝试转为String,看有没有值
            if (stringObject && stringObject.length > 0) {
                return stringObject;
            }
            
            
            NSAssert(!err && ([jsonObject isKindOfClass:[NSDictionary class]] || [jsonObject isKindOfClass:[NSArray class]]|| [jsonObject isKindOfClass:[NSString class]]), @"base64解码错误");
        }
        
        return jsonObject;
    }
    
    return nil;
}

// 将字符串加密为base64字符串
+ (NSString *)encodingBase64String:(NSString *)resString {
    
    if (resString.length == 0) {
        return nil;
    }
    
    NSString *base64String = [[resString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    return base64String;
}

@end

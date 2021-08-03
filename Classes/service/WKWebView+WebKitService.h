//  Riki
//
//  WKWebView+WebKitService.h
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
//  Created by Simon.Hu on 2021/3/18.
//  
//

#import <WebKit/WebKit.h>

@class RWebKitService;

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (WebKitService)

/// 持有的service
@property (nonatomic, weak) RWebKitService *rService;

@end

NS_ASSUME_NONNULL_END
//
//  Riki
//
//  RBaseModule.h
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
//  Created by ShevaKuilin on 2021/4/13.
//  
//
    
    

#import <Foundation/Foundation.h>

@class RWebKitService;

/** 函数执行结果成功回调
 *
 * @param result 函数成功回调的内容
 *
 */
typedef void (^SuccessBlock)(id result);

/** 函数执行结果失败回调
 *
 * @param error 函数失败回调的内容
 *
 */
typedef void (^FailureBlock)(id error);

@interface RBaseModule : NSObject

+ (RWebKitService *)getRService;

@end


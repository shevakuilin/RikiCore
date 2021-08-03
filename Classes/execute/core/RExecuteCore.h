//
//  Riki
//
//  RExecuteCore.h
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
//  Created by ShevaKuilin on 2021/3/12.
//  
//
    
    
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
@class RExecuteLog;

typedef void (^RCoreExecuteCompletion)(RExecuteLog *executeLog, id returnValue);

@interface RExecuteCore : NSObject

/** 执行 Objective-C 无返回值方法
 *
 * @param methodName    方法名
 * @param moduleName    模块名
 * @param arguments      参数值，不限制数量
 * @warning 注意 arguments 需要按照方法参数顺序传递，否则可能引发崩溃
 *
 */
+ (void)executeObjcVoidMethod:(NSString *)methodName moduleName:(NSString *)moduleName arguments:(NSArray<id> *)arguments completion:(RCoreExecuteCompletion)completion;

/** 执行 Objective-C 返回值方法
 *
 * @param methodName    方法名
 * @param moduleName    模块名
 * @param arguments      参数值，不限制数量
 * @warning 注意 arguments 需要按照方法参数顺序传递，否则可能引发崩溃
 *
 */
+ (void)executeObjcReturnValueMethod:(NSString *)methodName moduleName:(NSString *)moduleName arguments:(NSArray<id> *)arguments completion:(RCoreExecuteCompletion)completion;

/** 判断函数是否存在返回值类型
 *
 * @param methodName    方法名
 * @param moduleName    模块名
 * @return YES 存在返回值类型，NO 不存在返回值类型
 *
 */
+ (BOOL)funcExistReturnValueTypeWithMethodName:(NSString *)methodName moduleName:(NSString *)moduleName;

@end


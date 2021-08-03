//
//  Riki
//
//  RFuncPivot.h
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
    
    
#import <Foundation/Foundation.h>
@class RExecuteLog;

/** 函数执行完成回调
 *
 * @param executeLog 执行日志，包含状态码和日志信息等必要信息
 * @param returnValue 函数的方法返回值，方法不提供或无返回值为nil
 * @note RFuncExecuteCompletion的回调深度到函数执行为止，不会深入到函数本身的作用域
 *
 */
typedef void (^RFuncExecuteCompletion)(RExecuteLog *executeLog, id returnValue);

/** 函数执行结果成功回调
 *
 * @param result 函数成功回调的内容
 *
 */
typedef void (^RFuncSuccessBlock)(id result);

/** 函数执行结果失败回调
 *
 * @param error 函数失败回调的内容
 *
 */
typedef void (^RFuncFailureBlock)(id error);


@interface RFuncPivot : NSObject


/** 执行 Native 方法
 *
 * @param model 通信模型
 * @param completion 执行回调，包含执行日志 executeLog 和函数返回值 returnValue ，无返回值时 returnValue 为 nil
 * @note  Native 方法的参数固定为 responseData.data
 *
 */
+ (void)executeNativeMethodWithModel:(NSObject *)model completion:(RFuncExecuteCompletion)completion;

/** 执行 Native 方法，允许追加参数
 *
 * @param model 通信模型
 * @param appendArguments   追加参数，会按照数组顺序在已有参数列表的末尾依次加入
 * @param completion 执行回调，包含执行日志 executeLog 和函数返回值 returnValue ，无返回值时 returnValue 为 nil
 * @note  Native 方法的参数固定为 responseData.data
 *
 */
+ (void)executeNativeMethodWithModel:(NSObject *)model appendArguments:(NSArray *)appendArguments completion:(RFuncExecuteCompletion)completion;

/** 执行 Native 方法，提供成功结果回调
 *
 * @param model 通信模型
 * @param success 执行结果成功回调
 * @param completion 执行回调，包含执行日志 executeLog 和函数返回值 returnValue ，无返回值时 returnValue 为 nil
 * @note  Native 方法的参数固定为 responseData.data
 *
 */
+ (void)executeNativeMethodWithModel:(NSObject *)model success:(RFuncSuccessBlock)success completion:(RFuncExecuteCompletion)completion;

/** 执行 Native 方法， 提供成功 & 失败结果回调
 *
 * @param model 通信模型
 * @param success 执行结果成功回调
 * @param failure 执行结果失败回调
 * @param completion 执行回调，包含执行日志 executeLog 和函数返回值 returnValue ，无返回值时 returnValue 为 nil
 * @note  Native 方法的参数固定为 responseData.data
 *
 */
+ (void)executeNativeMethodWithModel:(NSObject *)model success:(RFuncSuccessBlock)success failure:(RFuncFailureBlock)failure completion:(RFuncExecuteCompletion)completion;

@end


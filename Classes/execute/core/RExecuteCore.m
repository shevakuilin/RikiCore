//
//  Riki
//
//  RExecuteCore.m
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
    

#import "RLog.h"
#import "RExecuteCore.h"
#import "RExecuteCore+Getter.h"
#import "RExecuteCore+Setter.h"
#import "RExecuteCore+Handle.h"

@implementation RExecuteCore

#pragma mark - Public

+ (void)executeObjcVoidMethod:(NSString *)methodName moduleName:(NSString *)moduleName arguments:(NSArray<id> *)arguments completion:(RCoreExecuteCompletion)completion {
    // - Note: 异常拦截
    if ([RExecuteCore interceptionMethod:methodName moduleName:moduleName arguments:arguments completion:completion]) {
        return;
    }
    if (arguments.count > 0) {
        Class class = NSClassFromString(moduleName);
        SEL sel = NSSelectorFromString(methodName);
        NSInvocation *inv = [RExecuteCore getInvocationWithClass:class sel:sel];
        for (int i = 0; i < arguments.count; i++) {
            id arg = arguments[i];
            // - Note: 设置NSInvocation参数
            [RExecuteCore setArgumenWithInvocation:inv index:i + 2 value:arg];
        }
        [inv invoke];
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeExecuteSuccess) content:@"Success!"] returnValue:nil];
    } else {
        // - Note: 无参数方法执行
        [RExecuteCore executeObjcVoidMethod:methodName moduleName:moduleName completion:completion];
    }
}

+ (void)executeObjcReturnValueMethod:(NSString *)methodName moduleName:(NSString *)moduleName arguments:(NSArray<id> *)arguments completion:(RCoreExecuteCompletion)completion {
    // - Note: 异常拦截
    if ([RExecuteCore interceptionMethod:methodName moduleName:moduleName arguments:arguments completion:completion]) {
        return;
    }
    if (arguments.count > 0) {
        Class class = NSClassFromString(moduleName);
        SEL sel = NSSelectorFromString(methodName);
        NSInvocation *inv = [RExecuteCore getInvocationWithClass:class sel:sel];
        for (int i = 0; i < arguments.count; i++) {
            id arg = arguments[i];
            [RExecuteCore setArgumenWithInvocation:inv index:i + 2 value:arg];
        }
        [inv invoke];
        // - Note: 获取返回值
        id returnValue = [RExecuteCore getReturnValueWithInvocation:inv];
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeExecuteSuccess) content:@"Success!"] returnValue:returnValue];
    } else {
        // - Note: 无参数方法执行
        [RExecuteCore executeObjcReturnValueMethod:methodName moduleName:moduleName completion:completion];
    }
}

+ (BOOL)funcExistReturnValueTypeWithMethodName:(NSString *)methodName moduleName:(NSString *)moduleName {
    Class class = NSClassFromString(moduleName);
    if (class) {
        SEL sel = NSSelectorFromString(methodName);
        NSInvocation *inv = [RExecuteCore getInvocationWithClass:class sel:sel];
        if (inv) {
            if (inv.methodSignature.methodReturnLength) {
                return true;
            }
        }
        return false;
    }
    return false;
}

#pragma mark - Private

+ (void)executeObjcVoidMethod:(NSString *)methodName moduleName:(NSString *)moduleName completion:(RCoreExecuteCompletion)completion {
    // - Note: 执行 Objective-C 无参数&无返回值方法
    Class class = NSClassFromString(moduleName);
    SEL sel = NSSelectorFromString(methodName);
    // - Note: 获取IMP指针
    IMP imp = [RExecuteCore getIMPWithClass:class sel:sel];
    ((void(*)(void))imp)();
    [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeExecuteSuccess) content:@"Success!"] returnValue:nil];
}

+ (void)executeObjcReturnValueMethod:(NSString *)methodName moduleName:(NSString *)moduleName completion:(RCoreExecuteCompletion)completion {
    // - Note: 执行 Objective-C 无参数&返回值方法
    Class class = NSClassFromString(moduleName);
    SEL sel = NSSelectorFromString(methodName);
    IMP imp = [RExecuteCore getIMPWithClass:class sel:sel];
    id returnValue = ((id(*)(id, SEL))imp)(self, sel);
    [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeExecuteSuccess) content:@"Success!"] returnValue:returnValue];
}

@end

//
//  Riki
//
//  RExecuteCore+Handle.m
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
//  Created by ShevaKuilin on 2021/3/15.
//  
//
    

#import "RLog.h"
#import "RExecuteCore+Handle.h"
#import "RExecuteCore+Getter.h"

@implementation RExecuteCore (Handle)

+ (BOOL)interceptionMethod:(NSString *)methodName moduleName:(NSString *)moduleName arguments:(NSArray<id> *)arguments completion:(RCoreExecuteCompletion)completion {
    // - Note: 异常拦截，存在异常true，不存在false
    Class class = NSClassFromString(moduleName);
    if (!class) {
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeIllegalParameter) content:@"Error: Invalid moduleName parameter!"] returnValue:nil];
        return true;
    }
    
    SEL sel = NSSelectorFromString(methodName);
    Method method = [RExecuteCore getMethodWithClass:class sel:sel];
    if (!method) {
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeIllegalParameter) content:@"Error: Invalid eventName parameter!" ]returnValue:nil];
        return true;
    }
    
    unsigned int count = method_getNumberOfArguments(method);
    // - Note: 参数数量与方法提供的入参数量必须相同
    if ((arguments.count + 2) != count) {
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeIncorrect) content:@"Error: Incorrect number of parameters!"] returnValue:nil];
        return true;
    }
    
    IMP imp = [RExecuteCore getIMPWithClass:class sel:sel];
    if (!imp) {
        [RExecuteCore completionHandle:completion log:[RLog executeLogWithCode:@(RCodeIllegalParameter) content:@"Error: Invalid moduleName or eventName parameter!"] returnValue:nil];
        return true;
    }
    
    return false;
}

+ (void)completionHandle:(RCoreExecuteCompletion)completion log:(RExecuteLog *)log returnValue:(id)returnValue {
    if (completion) {
        completion(log, returnValue);
    }
}

@end

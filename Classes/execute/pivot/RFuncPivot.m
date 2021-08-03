//
//  Riki
//
//  RFuncPivot.m
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
    
    
#import "Riki.h"
#import "RLog.h"
#import "RFuncPivot.h"
#import "RFuncRelay.h"
#import "RExecuteCore.h"
#import "NSObject+RBridgeProperty.h"

@implementation RFuncPivot

#pragma mark - Public

+ (void)executeNativeMethodWithModel:(NSObject *)model completion:(RFuncExecuteCompletion)completion {
    [RFuncPivot executeNativeMethodWithModel:model appendArguments:nil completion:completion];
}

+ (void)executeNativeMethodWithModel:(NSObject *)model appendArguments:(NSArray *)appendArguments completion:(RFuncExecuteCompletion)completion {
    if (!model) {
        if (completion) {
            completion([RLog executeLogWithCode:@(RCodeMissParameter) content:@"Error: Missing model parameter!"], nil);
        }
        return;
    }
    if (riki_stringIsEmpty(model.eventName) || riki_stringIsEmpty(model.moduleName)) {
        if (completion) {
            completion([RLog executeLogWithCode:@(RCodeMissParameter) content:@"Error: Missing eventName or moduleName parameter!"], nil);
        }
        return;
    }
    // - Note: 解析通信模型，返回函数真实参数顺序的参数列表
    NSArray<id> *arguments = [RFuncPivot argumentsHandleWithModel:model appendArguments:appendArguments];
    if (arguments) {
        // - Note: 判断函数是否需要返回值
        if ([RExecuteCore funcExistReturnValueTypeWithMethodName:model.eventName moduleName:model.moduleName]) {
            [RExecuteCore executeObjcReturnValueMethod:model.eventName moduleName:model.moduleName arguments:arguments completion:completion];
        } else {
            [RExecuteCore executeObjcVoidMethod:model.eventName moduleName:model.moduleName arguments:arguments completion:completion];
        }
    } else {
        // - Note: 非法参数
        if (completion) {
            completion([RLog executeLogWithCode:@(RCodeIllegalParameter) content:@"Error: Illegal parameter!"], nil);
        }
    }
}

+ (void)executeNativeMethodWithModel:(NSObject *)model success:(RFuncSuccessBlock)success completion:(RFuncExecuteCompletion)completion {
    [RFuncPivot executeNativeMethodWithModel:model success:success failure:nil completion:completion];
}

+ (void)executeNativeMethodWithModel:(NSObject *)model success:(RFuncSuccessBlock)success failure:(RFuncFailureBlock)failure completion:(RFuncExecuteCompletion)completion {
    typedef void (^SuccessBlock)(id result);
    SuccessBlock successBlock = ^(id result) {
        if (success) {
            success(result);
        }
    };
        
    typedef void (^FailureBlock)(id error);
    FailureBlock failureBlock = ^(id error) {
        if (failure) {
            failure(error);
        }
    };
    NSArray *appendArguments = failure ? @[[successBlock copy], [failureBlock copy]] : @[[successBlock copy]];
    [RFuncPivot executeNativeMethodWithModel:model appendArguments:appendArguments completion:completion];
}

#pragma mark - Private

+ (NSArray<id> *)argumentsHandleWithModel:(NSObject *)model appendArguments:(NSArray *)appendArguments {
    NSInteger appendArgCount = appendArguments.count;
    // - Note: 解析通信模型，返回函数真实参数顺序的参数列表
    NSArray<id> *arguments = [RFuncRelay getArgumentOrderedListFromModel:model appendArgCount:appendArgCount];
    // - Note: 判断是否需要追加参数
    if (appendArgCount > 0) {
        NSMutableArray<id> *tmp = [NSMutableArray arrayWithArray:arguments];
        [appendArguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [tmp addObject:obj];
            }
        }];
        arguments = [tmp copy];
    }
    
    return arguments;
}

@end

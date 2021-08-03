//
//  Riki
//
//  RFuncRelay.m
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
    

#import "RFuncRelay.h"
#import <objc/runtime.h>
#import "NSObject+RBridgeProperty.h"

@implementation RFuncRelay

#pragma mark - Public

+ (NSArray<id> *)getArgumentOrderedListFromModel:(NSObject *)model appendArgCount:(NSInteger)appendArgCount {
    if (model.messageData) {
        if (model.multipleParameters) {
            // - Note: 参数类型为键值对
            if ([RFuncRelay isKeyValuePair:model.messageData.data]) {
                NSDictionary *responseData = (NSDictionary *)model.messageData.data;
                // - Note: 有传入参数
                if (responseData.allValues.count > 0) {
                    // - Note: 返回排序后的参数列表
                    return [RFuncRelay getMethodArgumentListWithModel:model appendArgCount:appendArgCount];
                }
                // - Note: 无传入参数
                return @[];
                
            }
        }
        // - Note: 参数类型为单值
        return @[model.messageData.data];
    }
    
    return nil;
}

#pragma mark - Private

+ (BOOL)isKeyValuePair:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        return true;
    }
    return false;
}

+ (NSArray<id> *)getMethodArgumentListWithModel:(NSObject *)model appendArgCount:(NSInteger)appendArgCount {
    NSMutableOrderedSet *argumentList = [[NSMutableOrderedSet alloc] init];
    SEL sel = NSSelectorFromString(model.eventName);
    // - Note: 如果Sel有值，就说明这个methodName拼的是正确的，相当于校验了一步
    if (sel) {
        NSDictionary *responseData = (NSDictionary *)model.messageData.data;
        NSArray *responseDataKeys = responseData.allKeys;
        // - Note: 获取参数名列表
        NSArray *argKeys = [RFuncRelay filterWhitespaceCharactersWithArray:[model.eventName componentsSeparatedByString:@":"]];
        // - Note: 如果存在追加参数，为了通过校验，在校验参数数量时，会用函数真实参数，减去后来追加参数的数量，以此来达到校验平衡
        NSInteger argCount = appendArgCount > 0 ? argKeys.count - appendArgCount:argKeys.count;
        // - Note: 函数参数必须与传入参数数量一致
        if (argCount == responseDataKeys.count) {
            // - Note: 按照函数参数的实际顺序进行遍历
            [argKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
                [responseDataKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger j, BOOL * _Nonnull stop) {
                    NSString *key = responseDataKeys[j];
                    if (i == 0) {
                        // - Note: 由于 Objc 函数语法的特殊性，首位包含传入的参数名即可
                        // e.g. 函数名 setFirstObjc:secondObjc:，传入的参数名@"secondObjc", @"firstObjc"，只要首位包含firstObjc即可
                        
                        NSString *keyString = model.eventName;
                        NSArray *argArr = [model.eventName componentsSeparatedByString:@":"];
                        if (argArr.count > 0) {
                            keyString = argArr.firstObject;
                        }
                        
                        if ([[argKeys.firstObject lowercaseString] containsString:[keyString lowercaseString]]) {
                            // - Note: 将传入的参数值加入参数列表
                            [argumentList addObject:responseData[key]];
                        }
                    } else {
                        // - Note: 除首位外，其余位必须完全匹配
                        if ([[argKeys[i] lowercaseString] isEqualToString:[key lowercaseString]]) {
                            [argumentList addObject:responseData[key]];
                        }
                    }
                }];
            }];
            // - Note: 校验参数长度是否一致
            if (argCount != argumentList.array.count) {
                return nil;
            }
        } else {
            return nil;            
        }
    }
    
    return [argumentList array];
}

+ (NSArray<id> *)filterWhitespaceCharactersWithArray:(NSArray<id> *)array {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *string in array) {
        if (string.length > 0) {
            [tmp addObject:string];
        }
    }
    return [tmp copy];
}

@end

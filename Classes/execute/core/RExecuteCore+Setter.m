//
//  Riki
//
//  RExecuteCore+Setter.m
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
    

#import "RExecuteCore+Setter.h"

@implementation RExecuteCore (Setter)

+ (void)setArgumenWithInvocation:(NSInvocation *)inv index:(int)index value:(id)value {
    // - Note: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *)value;
        const char *objCType = [numberValue objCType];
        if (strcmp(objCType, "f") == 0) {
            float f = [numberValue floatValue];
            [inv setArgument:&(f) atIndex:index];
        } else if (strcmp(objCType, "d")  == 0) {
            double d = [numberValue doubleValue];
            [inv setArgument:&(d) atIndex:index];
        } else if (strcmp(objCType, "i")  == 0) {
            int i = [numberValue intValue];
            [inv setArgument:&(i) atIndex:index];
        } else if (strcmp(objCType, "q")  == 0) {
            long long q = [numberValue longLongValue];
            [inv setArgument:&(q) atIndex:index];
        } else if (strcmp(objCType, "l")  == 0) {
            long l = [numberValue longValue];
            [inv setArgument:&(l) atIndex:index];
        } else if (strcmp(objCType, "B") == 0) {
            BOOL b = [numberValue boolValue];
            [inv setArgument:&(b) atIndex:index];
        } else if (strcmp(objCType, "c") == 0) {
            // - Note: [NSStringFromClass([returnValue class]) isEqualToString:@"__NSCFBoolean"]
            // BOOL在实际中被typedef为signed char
            // NSCFBoolean则是NSNumber类簇中的一个私有的类，它是通往CFBooleanRef类型的桥梁，被用来给Core Foundation的属性列表和集合封装布尔数值
            char c = [numberValue charValue];
            [inv setArgument:&(c) atIndex:index];
        } else if (strcmp(objCType, "s") == 0) {
            short s = [numberValue shortValue];
            [inv setArgument:&(s) atIndex:index];
        } else if (strcmp(objCType, "C") == 0) {
            unsigned char C = [numberValue unsignedCharValue];
            [inv setArgument:&(C) atIndex:index];
        } else if (strcmp(objCType, "I") == 0) {
            unsigned int I;
            [inv setArgument:&(I) atIndex:index];
        } else if (strcmp(objCType, "S") == 0) {
            unsigned short S;
            [inv setArgument:&(S) atIndex:index];
        } else if (strcmp(objCType, "L") == 0) {
            unsigned long L;
            [inv setArgument:&(L) atIndex:index];
        } else if (strcmp(objCType, "Q") == 0) {
            unsigned long long Q;
            [inv setArgument:&(Q) atIndex:index];
        } else {
            [inv setArgument:&(value) atIndex:index];
        }
    } else {
        [inv setArgument:&(value) atIndex:index];
    }
}

@end

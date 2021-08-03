//
//  Riki
//
//  RExecuteCore+Getter.m
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
    

#import "RExecuteCore+Getter.h"

@implementation RExecuteCore (Getter)

+ (IMP)getIMPWithClass:(Class)class sel:(SEL)sel {
    // - Note: 获取IMP指针
    IMP imp = nil;
    if ([class instancesRespondToSelector:sel]) { // 实例方法
        imp = [class instanceMethodForSelector:sel];
    } else if ([class respondsToSelector:sel]) { // 类方法
        imp = [class methodForSelector:sel];
    }
    
    return imp;
}

+ (Method)getMethodWithClass:(Class)class sel:(SEL)sel {
    // - Note: 获取Method
    Method method = nil;
    if ([class instancesRespondToSelector:sel]) { // 实例方法
        method = class_getInstanceMethod(class, sel);
    } else if ([class respondsToSelector:sel]) { // 类方法
        method = class_getClassMethod(class, sel);
    }
    
    return method;
}

+ (NSInvocation *)getInvocationWithClass:(Class)class sel:(SEL)sel {
    // - Note: 获取NSInvocation实例对象
    if ([class instancesRespondToSelector:sel]) { // 实例方法
        // __autoreleasing 延缓释放
        __autoreleasing id instanceObjc = [class new];
        NSMethodSignature *signature = [instanceObjc methodSignatureForSelector:sel];
        if (signature) {
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
            [inv setSelector:sel];
            [inv setTarget:instanceObjc];
            
            return inv;
        }
    } else if ([class respondsToSelector:sel]) { // 类方法
        NSMethodSignature *signature = [class methodSignatureForSelector:sel];
        if (signature) {
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
            [inv setSelector:sel];
            [inv setTarget:class];
            
            return inv;
        }
    }
    
    return nil;
}

+ (id)getReturnValueWithInvocation:(NSInvocation *)inv {
    // - Note: 如果不是oc对象，将其包装成一个oc对象
    // - Note: 获取返回值
    id __autoreleasing returnValue;
    // - Note: 方法有返回值类型，才去获得返回值
    if (inv.methodSignature.methodReturnLength) {
        // - Note: 如果不是oc对象，将其包装成一个oc对象
        if (strcmp(inv.methodSignature.methodReturnType, "f") == 0) {
            float f;
            [inv getReturnValue:&f];
            returnValue = [NSNumber numberWithFloat:f];
        } else if (strcmp(inv.methodSignature.methodReturnType, "d")  == 0) {
            double d;
            [inv getReturnValue:&d];
            returnValue = [NSNumber numberWithDouble:d];
        } else if (strcmp(inv.methodSignature.methodReturnType, "i")  == 0) {
            int i;
            [inv getReturnValue:&i];
            returnValue = [NSNumber numberWithInt:i];
        } else if (strcmp(inv.methodSignature.methodReturnType, "q")  == 0) {
            long long q;
            [inv getReturnValue:&q];
            returnValue = [NSNumber numberWithLongLong:q];
        } else if (strcmp(inv.methodSignature.methodReturnType, "l")  == 0) {
            long l;
            [inv getReturnValue:&l];
            returnValue = [NSNumber numberWithLong:l];
        } else if (strcmp(inv.methodSignature.methodReturnType, "B") == 0) {
            // - Note: 对于BOOL类型的返回值，类型是明确的'B'，而不是NSNumber中的类簇__NSCFBoolean，'c'
            BOOL b;
            [inv getReturnValue:&b];
            returnValue = [NSNumber numberWithBool:b];
        } else if (strcmp(inv.methodSignature.methodReturnType, "c") == 0) {
            char c;
            [inv getReturnValue:&c];
            returnValue = [NSNumber numberWithChar:c];
        } else if (strcmp(inv.methodSignature.methodReturnType, "s") == 0) {
            short s;
            [inv getReturnValue:&s];
            returnValue = [NSNumber numberWithShort:s];
        } else if (strcmp(inv.methodSignature.methodReturnType, "C") == 0) {
            unsigned char C;
            [inv getReturnValue:&C];
            returnValue = [NSNumber numberWithUnsignedChar:C];
        } else if (strcmp(inv.methodSignature.methodReturnType, "I") == 0) {
            unsigned int I;
            [inv getReturnValue:&I];
            returnValue = [NSNumber numberWithUnsignedInt:I];
        } else if (strcmp(inv.methodSignature.methodReturnType, "S") == 0) {
            unsigned short S;
            [inv getReturnValue:&S];
            returnValue = [NSNumber numberWithUnsignedShort:S];
        } else if (strcmp(inv.methodSignature.methodReturnType, "L") == 0) {
            unsigned long L;
            [inv getReturnValue:&L];
            returnValue = [NSNumber numberWithUnsignedLong:L];
        } else if (strcmp(inv.methodSignature.methodReturnType, "Q") == 0) {
            unsigned long long Q;
            [inv getReturnValue:&Q];
            returnValue = [NSNumber numberWithUnsignedLongLong:Q];
        } else {
            [inv getReturnValue:&returnValue];
        }
    }
    
    return returnValue;
}

@end

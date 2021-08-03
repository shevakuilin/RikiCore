//
//  Riki
//
//  NSObject+RBridgeProperty.m
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
#import "NSObject+RBridgeProperty.h"

@implementation NSObject (RBridgeResponseData)

#pragma mark - Setter

- (void)setMsg:(NSString *)msg {
    objc_setAssociatedObject(self, @selector(msg), msg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setCode:(NSNumber *)code {
    objc_setAssociatedObject(self, @selector(code), code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setData:(id)data {
    objc_setAssociatedObject(self, @selector(data), data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (NSString *)msg {
    return objc_getAssociatedObject(self, @selector(msg));
}

- (NSNumber *)code {
    return objc_getAssociatedObject(self, @selector(code));
}

- (id)data {
    return objc_getAssociatedObject(self, @selector(data));
}

@end

@implementation NSObject (RBridgeProperty)

#pragma mark - Setter

- (void)setResponseId:(NSString *)responseId {
    objc_setAssociatedObject(self, @selector(responseId), responseId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setModuleName:(NSString *)moduleName {
    objc_setAssociatedObject(self, @selector(moduleName), moduleName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEventName:(NSString *)eventName {
    objc_setAssociatedObject(self, @selector(eventName), eventName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setMessageData:(NSObject *)messageData {
    objc_setAssociatedObject(self, @selector(messageData), messageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMultipleParameters:(BOOL)multipleParameters {
    objc_setAssociatedObject(self, @selector(multipleParameters), @(multipleParameters), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Getter

- (NSString *)responseId {
    return objc_getAssociatedObject(self, @selector(responseId));
}

- (NSString *)moduleName {
    return objc_getAssociatedObject(self, @selector(moduleName));
}

- (NSString *)eventName {
    return objc_getAssociatedObject(self, @selector(eventName));
}

- (NSObject *)messageData {
    return objc_getAssociatedObject(self, @selector(messageData));
}

- (BOOL)multipleParameters {
    return objc_getAssociatedObject(self, @selector(multipleParameters));
}

@end


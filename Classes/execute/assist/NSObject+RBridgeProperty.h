//
//  Riki
//
//  NSObject+RBridgeProperty.h
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

@interface NSObject (RBridgeResponseData)

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id data;

@end


@interface NSObject (RBridgeProperty)

@property (nonatomic, copy) NSString *responseId;
@property (nonatomic, copy) NSString *moduleName;   // 模块名
@property (nonatomic, copy) NSString *eventName;    // 方法名
@property (nonatomic, assign) BOOL multipleParameters; // 多参数类型，默认为false
@property (nonatomic, strong) NSObject *messageData;

@end

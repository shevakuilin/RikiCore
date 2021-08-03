////  Riki
//
//  RJSBridgeModel.h
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
//  Created by Simon.Hu on 2021/3/17.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *RJSMsgResultType NS_STRING_ENUM;
FOUNDATION_EXPORT RJSMsgResultType const RJSMsgResultTypeSuccess;
FOUNDATION_EXPORT RJSMsgResultType const RJSMsgResultTypeFail;

@interface RJSBridgeDataModel : NSObject

@property (nonatomic, assign) NSUInteger code;
@property (nonatomic, copy) RJSMsgResultType msg;
@property (nonatomic, copy) id data;

- (instancetype)initWithDictionary:(NSDictionary * _Nullable)dataDic;

- (NSDictionary *)converToDictionary;

@end

@interface RJSBridgeModel : NSObject

@property (nonatomic, copy) NSString *callId;
@property (nonatomic, copy) NSString *responseId;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, strong) RJSBridgeDataModel *messageData;

- (instancetype)initWithDictionary:(NSDictionary *)message;

@end

NS_ASSUME_NONNULL_END

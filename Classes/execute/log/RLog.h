//
//  Riki
//
//  RLog.h
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
//  Created by ShevaKuilin on 2021/3/22.
//  
//
    
    

#import <Foundation/Foundation.h>
@class RExecuteLog;

typedef NS_ENUM(NSInteger, RExecuteLogCode){
    /**
     * @abstract 执行成功
     */
    RCodeExecuteSuccess = 200,
    /**
     * @abstract 缺失关键参数，如缺少moduleName或eventName
     */
    RCodeMissParameter = 1001,
    /**
     * @abstract 非法关键参数
     */
    RCodeIllegalParameter = 1002,
    /**
     * @abstract 参数数量越界或不匹配
     */
    RCodeIncorrect = 1003,
    /**
     * @abstract 通信成功，但业务方报错
     */
    RCodeLogicIncorrect = 400,
};


@interface RLog : NSObject

+ (RExecuteLog *)executeLogWithCode:(NSNumber *)code content:(NSString *)content;

@end

//
//  Riki
//
//  RFuncRelay.h
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
    

#import <Foundation/Foundation.h>

@interface RFuncRelay : NSObject

/** 获取参数的顺序列表
 *
 * @param model 通信模型
 * @param appendArgCount 追加参数的数量
 * @return 参数的顺序列表
 * @note 解析通信模型中需要执行的 Native 函数的参数，并保留参数顺序。然后解析通信模型传入的参数，按顺序入位到之前解析的函数参数列表，最后返回一个函数真实参数执行顺序的参数列表
 */
+ (NSArray<id> *)getArgumentOrderedListFromModel:(NSObject *)model appendArgCount:(NSInteger)appendArgCount;

@end

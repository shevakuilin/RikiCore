//
//  Riki
//
//  RBaseModule.m
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
//  Created by ShevaKuilin on 2021/4/13.
//  
//
    
    

#import "RPass.h"
#import "RBaseModule.h"
#import "RServiceMap.h"
#import "RWebKitService.h"

@implementation RBaseModule

static NSString *_currentHash;

+ (void)load {
    [RPass receiveServiceWithTarget:self method:@selector(serviceAlready:)];
}

+ (void)serviceAlready:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if (dic) {
        RWebKitService *service = dic[kService];
        if (service) {
            _currentHash = service.hashIdentifier;
            // - Note: 以hash值为key，保存service
            [[RServiceMap share].services setValue:service forKey:service.hashIdentifier];
        }
    }
}

+ (RWebKitService *)getRService {    
    return [[RServiceMap share].services objectForKey:_currentHash];
}

@end

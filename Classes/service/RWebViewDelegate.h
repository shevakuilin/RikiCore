//
//  RWebViewDelegate.h
//  riki
//
//  Created by Simon.Hu on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// riki webview容器相关代理
@protocol RWebViewDelegate <NSObject>

@optional
/// 桥建立通知
- (id)bridgeReadyCompelte;

@end

NS_ASSUME_NONNULL_END

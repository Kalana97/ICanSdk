//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 16/4/2020
- File name:  NTESNotificationCenter.h
- Description: 云信音视频通知中心
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESNotificationCenter : NSObject
+ (instancetype)sharedCenter;
- (void)start;
- (void)presentCallViewController:(UIViewController *)viewController;
- (void)dismissCallViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END

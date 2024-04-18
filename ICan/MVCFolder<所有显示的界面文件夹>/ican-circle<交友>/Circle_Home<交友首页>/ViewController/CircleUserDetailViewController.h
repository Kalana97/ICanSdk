//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleUserDetailViewController.h
- Description:用户详情
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleUserDetailViewController : QDCommonViewController
@property(nonatomic, strong) CircleUserInfo *userInfo;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) void (^fllowBlock)(void);
@end

NS_ASSUME_NONNULL_END

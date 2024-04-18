//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/7/2021
- File name:  CircleMyImgViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleMyImgViewController : QDCommonViewController
@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
@property(nonatomic, copy) void (^editSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2020
- File name:  FriendDataSettingViewController.h
- Description:资料设置
- Function List:
*/
        

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface FriendDataSettingViewController : BaseViewController
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, strong) UserMessageInfo *messageInfo;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 31/10/2019
- File name:  EditGroupAnnounceViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditGroupAnnounceViewController : BaseViewController
@property(nonatomic, strong) GroupListInfo *groupDetailInfo;
@property (nonatomic,copy) void (^settingGroupAnnounceBlock)(NSString*announce);
@end

NS_ASSUME_NONNULL_END

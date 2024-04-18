//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/4/2020
- File name:  VersionAlertView.h
- Description:版本更新提示View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionAlertView : UIView


@property(nonatomic, strong) VersionsInfo *versionsInfo;
- (void)showVersionAlertView;
@end

NS_ASSUME_NONNULL_END

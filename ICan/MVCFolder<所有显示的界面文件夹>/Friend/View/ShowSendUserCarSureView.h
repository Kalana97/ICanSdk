//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/6/2021
- File name:  ShowSendUserCarSureView.h
- Description:发送名片的确认弹框
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UserMessageInfo;
@interface ShowSendUserCarSureView : UIView
@property(nonatomic, strong) UserMessageInfo *info;
@property(nonatomic, copy) void (^sureBlock)(void);
-(void)showView;
-(void)hiddenView;
@end

NS_ASSUME_NONNULL_END

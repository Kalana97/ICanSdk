//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/6/2020
- File name:  ChatViewReplyView.h
- Description:显示在聊天页面的View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewReplyView : UIView
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic,strong) UILabel *replyTitleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic,strong) UIView *leftBoderView;
@property(nonatomic, copy) void (^cancelBlock)(void);
@end

NS_ASSUME_NONNULL_END

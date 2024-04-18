//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/20
- ICan
- File name:  ChatViewNavBarView.h
- Description: 聊天界面的导航栏
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewNavBarView : UIView
@property(nonatomic, weak) IBOutlet DZIconImageView *iconImageView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *countLabel;
@property(nonatomic, weak) IBOutlet UIButton *moreButton;
@property(nonatomic, weak) IBOutlet UIButton *voiceButton;
@property(nonatomic, weak) IBOutlet UIButton *leftArrowButton;
@property(nonatomic, weak) IBOutlet UIButton *videoButton;
@property(nonatomic, weak) IBOutlet UILabel *statusLabel;
/** 多选的情况下 显示的取消的button */
@property(nonatomic, weak) IBOutlet UIButton *cancleButton;
/** 当前离线在线的状态对应的imageView */
@property(nonatomic, weak) IBOutlet UIImageView *statusImageView;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友 c2c
 */
@property(nonatomic, copy) NSString *authorityType;
@property(nonatomic, copy) NSString *userNavType;
@property(nonatomic, copy) void (^iconImageViewTapBlock)(void);
@property(nonatomic, copy) void (^chatViewNavBarViewButtonBlock)(NSInteger tag);

/// 根据获取的好友详情来改变UI
/// @param userMessageInfo 好友详情
/// @param authorityType 当前的类型
-(void)updateUIWith:(UserMessageInfo*)userMessageInfo authorityType:(NSString*)authorityType;

/// 多选的情况下点击了取消或者已经多选操作完成之后
/// @param authorityType authorityType description
-(void)updateUiAfterClickCancelButton:(NSString *)authorityType groupUserInfo:(GroupListInfo *)groupInfo;

/// 根据交友的信息 控制按钮能否点击
/// @param dislikeMeInfo dislikeMeInfo description
/// @param circleUserInfo circleUserInfo description
-(void)updateButtonStatusWith:(GetCircleDislikeMeInfo*)dislikeMeInfo circleUserInfo:(CircleUserInfo*)circleUserInfo;
-(void)updateButtonStatusWithC2CUserInfo:(C2CUserInfo*)c2cUserInfo;
/// 点击了聊天消息的多选按钮
-(void)updateUiAfterSelectMore;
-(void)updateUserOnline:(CheckUserOnlineInfo*)onlineInfo;
-(void)hideCallItems;
-(void)disableCallItems;
-(void)hideMoreItems;
-(void)showMoreItems;
-(void)updateUiWithGroupInfo:(GroupListInfo*)groupInfo;

@end


NS_ASSUME_NONNULL_END

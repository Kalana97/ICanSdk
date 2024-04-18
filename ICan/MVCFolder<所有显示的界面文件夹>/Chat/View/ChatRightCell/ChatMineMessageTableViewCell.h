//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/11/2021
- File name:  ChatTextTestTableViewCell.h
- Description:
- Function List:
*/
        

#import "QMUITableViewCell.h"
#import "FLAnimatedImageView.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "MenuItem.h"
#import "MessageMenuView.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatMineMessageTableViewCell = @"ChatMineMessageTableViewCell";

@protocol BaseMineMessageCelllDelegate <NSObject>
@optional
/** 点击了回复的文字按钮 */
-(void)clickReplyAction:(UITableViewCell*)cell;
/**
 点击了发送失败的button
 
 @param cell cell description
 */
- (void)didClickSendFailButtonWithCell:(UITableViewCell *)cell;
/**
 点击了某个cell
 
 @param cell cell description

 */
- (void)didSelectMessageWithCell:(UITableViewCell *)cell;


/// 长按cell出现转发等功能
/// @param selectType selectType description
/// @param cell cell description
- (void)didSelectItemArticleWithSelectType:(SelectMessageType)selectType cell:(UITableViewCell *)cell;
- (void)didSelectReactItemOfCell:(ReactItem *)reactItem cell:(UITableViewCell *)cell;

/// 多选的情况下点击
/// @param cell cell description
-(void)didMultipleSelectMessageWithCell:(UITableViewCell *)cell;

@end
@interface ChatMineMessageTableViewCell : QMUITableViewCell<MessageMenuViewDelegate>
@property(weak, nonatomic) IBOutlet FLAnimatedImageView *imageMessageView;
@property(nonatomic, strong) MessageMenuView *menuView;
@property(nonatomic,assign) BOOL isGroup;
/** 当前是否是多选状态 */
@property(nonatomic, assign) BOOL multipleSelection;
@property(nonatomic, copy)   NSString *searchText;
/** 是否应该高亮显示 */
@property(nonatomic, assign) BOOL shouldHightShow;
@property(nonatomic, weak)  id<BaseMineMessageCelllDelegate> baseMessageCellDelegate;

//这里使用weak 是因为导致了循环引用
@property(nonatomic, weak)    UIViewController *fileContainerView;
@property(nonatomic, assign) XMNVoiceMessageState voiceMessageState;
/** 上传图片的时候的model */
@property(nonatomic, strong)  ChatModel *chatModel;
/** 上传文件的时候的model */
@property(nonatomic, strong)  ChatModel *chatmodel;
@property(nonatomic, strong)  C2CUserInfo *c2cUserInfo;
- (void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime;

@end

NS_ASSUME_NONNULL_END

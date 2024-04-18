//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/11/2021
- File name:  ChatOtherMessageTableViewCell.h
- Description:
- Function List:
*/
        

#import "QMUITableViewCell.h"
@class ChatModel;
#import "MenuItem.h"
#import "MessageMenuView.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatOtherMessageTableViewCell = @"ChatOtherMessageTableViewCell";

@protocol OtherMessageCellDelegate <NSObject>
@optional
/** 点击了回复的文字按钮 */
-(void)clickReplyActionByCell:(UITableViewCell*)cell;
/**
 点击了某个cell
 
 @param cell cell description

 */
- (void)didSelectMessageWithCell:(UITableViewCell *)cell;

/**
 点击了头像
 
 @param cell cell description
 */
- (void)didSelectIconViewWithOtherCell:(UITableViewCell *)cell;

/**
 长按头像
 
 @param cell cell description
 */
- (void)longPressIconViewWithOtherCell:(UITableViewCell *)cell;


/// 长按cell出现转发等功能
/// @param selectType selectType description
/// @param cell cell description
- (void)didSelectItemArticleWithOtherSelectTypeWith:(SelectMessageType)selectType cell:(UITableViewCell *)cell;
- (void)didSelectReactItemOfCell:(ReactItem *)reactItem cell:(UITableViewCell *)cell;
-(void)didMultipleSelectMessageWithCell:(UITableViewCell*)cell;
@end
@interface ChatOtherMessageTableViewCell : QMUITableViewCell<MessageMenuViewDelegate>
@property(nonatomic, strong) MessageMenuView *menuView;
/** 当前是否是多选状态 */
@property(nonatomic, assign) BOOL multipleSelection;

@property(nonatomic, strong)  C2CUserInfo *c2cUserInfo;
@property(nonatomic, weak) id<OtherMessageCellDelegate> baseOtherMessageCellDelegate;
- (void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime;

@end

NS_ASSUME_NONNULL_END

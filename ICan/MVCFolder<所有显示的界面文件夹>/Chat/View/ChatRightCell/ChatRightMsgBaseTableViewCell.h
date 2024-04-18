//
//  ChatLeftMsgBaseTableViewCell.h
//  ICan
//
//  Created by dzl on 19/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "BaseCell.h"
#import "ChatModel.h"
#import "MessageMenuView.h"
#import "ReactItem.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightMsgBaseTableViewCell = @"ChatRightMsgBaseTableViewCell";
@protocol ChatRightMsgCellDelegate <NSObject>
@optional
/** 点击了回复的文字按钮 */
-(void)clickReplyActionByCell:(UITableViewCell*)cell;
/**
 点击了某个cell
 
 @param cell cell description

 */
- (void)didSelectMessageWithCell:(UITableViewCell *)cell;
/**
 点击了发送失败的button
 
 @param cell cell description
 */
- (void)didClickSendFailButtonWithCell:(UITableViewCell *)cell;



/// 长按cell出现转发等功能
/// @param selectType selectType description
/// @param cell cell description
- (void)didSelectItemArticleWithOtherSelectTypeWith:(SelectMessageType)selectType cell:(UITableViewCell *)cell;
- (void)didSelectReactItemOfCell:(ReactItem *)reactItem cell:(UITableViewCell *)cell;
-(void)didMultipleSelectMessageWithCell:(UITableViewCell*)cell;
@end
@interface ChatRightMsgBaseTableViewCell : BaseCell<MessageMenuViewDelegate>
@property(nonatomic,strong) UIView *bodyContentView;
@property(nonatomic,assign) BOOL isShowTime;
@property(nonatomic, strong) UIButton *multipleBtn;
///放置具体内容的垂直排布容器
@property(nonatomic,strong)  UIStackView *contentVerticalStackView;
@property(nonatomic,strong)  C2CUserInfo *c2cUserInfo;
@property(nonatomic,strong)  ChatModel *  currentChatModel;
@property(nonatomic,strong)  MessageMenuView *menuView;
/** 当前是否是多选状态 */
@property(nonatomic,assign)  BOOL multipleSelection;
@property(nonatomic,weak)    id<ChatRightMsgCellDelegate> msgDelegate;
@property(nonatomic, strong) UIView *convertRectView;
@property(nonatomic, strong) UIActivityIndicatorView *sendActivityView;
@property(nonatomic, strong) UIButton *failBtn;
@property(nonatomic, assign) BOOL isReplay;
@property(nonatomic, strong) NSString *replyText;
@property(nonatomic, strong) NSString *replierName;
- (void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime;
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes;
-(void)clickMessageMunuView:(MenuItem*)item;
-(void)clickMessageCell;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 29/10/2019
- File name:  ChatWithdrawTableViewCell.h
- Description: 撤回消息
 关于撤回消息的构想：
 前提：自己发送的消息且发送时间不超过180秒的消息都可以撤回
 过程：
 1：收到撤回的消息把消息type设置为Chat_withdraw:原消息类型
 2：如果是自己撤回的消息 并且是文本的话那么就可以小时为 你撤回了一条消息 重新编辑
 3：如果是别人撤回的消息 那么显示为xxx 撤回了一条消息 
- Function List:
*/
        

#import "BaseCell.h"
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kChatWithdrawTableViewCell = @"ChatWithdrawTableViewCell";
static CGFloat const kHeightChatWithdrawTableViewCell = 40;
@interface ChatWithdrawTableViewCell : UITableViewCell
@property(nonatomic, strong) ChatModel *chatModel;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END

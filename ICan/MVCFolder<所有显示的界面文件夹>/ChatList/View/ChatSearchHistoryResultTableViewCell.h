//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/1/2021
- File name:  ChatSearchHistoryResultTableViewCell.h
- Description:搜索聊天记录结果
- Function List:
*/
        

#import "BaseCell.h"

@class GroupMemberInfo;
@class GroupListInfo;
@class UserMessageInfo;
@class ChatListModel;
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kChatSearchHistoryResultTableViewCell = @"ChatSearchHistoryResultTableViewCell";
@interface ChatSearchHistoryResultTableViewCell : BaseCell
@property (nonatomic,strong) GroupListInfo * groupListInfo;
@property(nonatomic, strong) NSArray<GroupMemberInfo*> *groupMemberItems;
@property (nonatomic,strong) UserMessageInfo * userMessageInfo;
@property(nonatomic, strong) ChatListModel *chatListModel;
@property(nonatomic, strong) ChatModel *chatModel;
/**
 聊天记录数组
 */
@property(nonatomic, strong) NSArray<ChatModel*> *historyItems;
@property(nonatomic, copy) NSString *searchText;
@end

NS_ASSUME_NONNULL_END

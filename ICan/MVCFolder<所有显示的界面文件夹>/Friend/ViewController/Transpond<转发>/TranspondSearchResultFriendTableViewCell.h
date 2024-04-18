//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/10/2019
- File name:  TranspondSearchResultTableViewCell.h
- Description: 转发搜索结果是联系人
- Function List:
*/
        

#import "BaseCell.h"
@class ChatListModel;
NS_ASSUME_NONNULL_BEGIN
static NSString* const KTranspondSearchResultFriendTableViewCell = @"TranspondSearchResultFriendTableViewCell";
static CGFloat const kHeightTranspondSearchResultTableViewCell = 60;
@interface TranspondSearchResultFriendTableViewCell : BaseCell

@property (nonatomic,assign) BOOL isShowSelectButton;

@property(nonatomic, strong) ChatListModel *chatListModel;

@property(nonatomic, strong) UserMessageInfo *userMessageInfo;

@property (nonatomic,strong) GroupListInfo * groupListInfo;


@end

NS_ASSUME_NONNULL_END

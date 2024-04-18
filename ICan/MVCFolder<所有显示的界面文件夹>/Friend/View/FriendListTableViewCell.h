//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 14/10/2019
- File name:  FriendListTableViewCell.h
- Description: 好友列表
- Function List:
*/
        

#import "BaseCell.h"


NS_ASSUME_NONNULL_BEGIN
static NSString* const kFriendListTableViewCell = @"FriendListTableViewCell";
static CGFloat const kHeightFriendListTableViewCell = 55;
@interface FriendListTableViewCell : BaseCell

@property(nonatomic, strong) UserMessageInfo *userMessageInfo;
@property(nonatomic, assign) BOOL selectionBtnStatus;
@property (nonatomic,strong) GroupMemberInfo * groupMemberInfo;

@end

NS_ASSUME_NONNULL_END

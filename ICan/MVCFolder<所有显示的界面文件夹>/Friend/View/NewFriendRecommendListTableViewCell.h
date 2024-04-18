//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 13/4/2020
- File name:  NewFriendRecommendListTableViewCell.h
- Description: 新的好友 推荐的人
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kNewFriendRecommendListTableViewCell = @"NewFriendRecommendListTableViewCell";
static CGFloat const KHeightNewFriendRecommendListTableViewCell = 100;
@interface NewFriendRecommendListTableViewCell : BaseCell
@property (nonatomic,copy) void(^agreeSucessBlock)(void);
@property (nonatomic,copy) void(^refuseSucessBlock)(void);
 
@property(nonatomic, strong) UserRecommendListInfo *userRecommendListInfo;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 27/12/2019
- File name:  ShowHasReadTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"
#import "WCDBManager+UserMessageInfo.h"
NS_ASSUME_NONNULL_BEGIN
static NSString* const kShowHasReadTableViewCell = @"ShowHasReadTableViewCell";
static CGFloat const kHeightShowHasReadTableViewCell = 50;
@interface ShowHasReadTableViewCell : BaseCell
@property(nonatomic, assign) BOOL isGroup;
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, strong) NSDictionary *dict;
@property(nonatomic, strong) TimelineLoveInfo *userMessageInfo;
@end

NS_ASSUME_NONNULL_END

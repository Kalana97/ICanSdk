//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- File name:  FaseMessageTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kFaseMessageTableViewCell = @"FaseMessageTableViewCell";
@interface FaseMessageTableViewCell : BaseCell
@property(nonatomic, strong) QuickMessageInfo *msgInfo;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END

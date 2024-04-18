//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kSelect43PayWayCell = @"Select43PayWayCell";
@interface Select43PayWayCell : BaseCell
@property(nonatomic, strong) QuickPayInfo *info;
@property(nonatomic, copy) void (^selectBlock)(void);
@end

NS_ASSUME_NONNULL_END

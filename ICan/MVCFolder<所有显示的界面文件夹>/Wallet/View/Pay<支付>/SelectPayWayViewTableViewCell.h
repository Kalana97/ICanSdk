//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2021
- File name:  SelectPayWayViewTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kSelectPayWayViewTableViewCell = @"SelectPayWayViewTableViewCell";
@interface SelectPayWayViewTableViewCell : BaseCell
@property(nonatomic, strong) RechargeChannelInfo *channelInfo;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2021
- File name:  SelectPayWayView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectPayWayView : UIView
@property(nonatomic, copy) void (^closeBlock)(void);
@property(nonatomic, copy) void (^selectChannelInfoBlock)(RechargeChannelInfo*info);
@property(nonatomic, copy) void (^sureButtonBlock)(RechargeChannelInfo*info);
@property(nonatomic, strong) NSArray<RechargeChannelInfo*> *channelItems;
@end

NS_ASSUME_NONNULL_END

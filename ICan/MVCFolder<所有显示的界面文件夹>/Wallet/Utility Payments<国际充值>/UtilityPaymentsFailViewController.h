//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/4/2021
- File name:  UtilityPaymentsFailViewController.h
- Description:充值失败
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UtilityPaymentsFailViewController : BaseViewController
@property(nonatomic, strong) NSString *dialogPaymentAmount;
@property(nonatomic, strong)  RechargeChannelInfo *selectChannelInfo;
@end

NS_ASSUME_NONNULL_END

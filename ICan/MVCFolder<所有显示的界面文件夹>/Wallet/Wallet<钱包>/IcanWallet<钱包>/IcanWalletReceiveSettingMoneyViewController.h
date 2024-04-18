//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 17/1/2022
- File name:  IcanWalletReceiveSettingMoneyViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletReceiveSettingMoneyViewController : BaseViewController
@property(nonatomic, copy) void (^sureBlock)(CurrencyInfo*currencyInfo,NSString*money,NSString*remark);
@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@end

NS_ASSUME_NONNULL_END

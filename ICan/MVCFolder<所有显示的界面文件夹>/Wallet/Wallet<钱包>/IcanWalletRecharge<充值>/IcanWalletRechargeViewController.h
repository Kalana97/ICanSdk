//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletRechargeViewController.h
- Description:我行->ican钱包->钱包界面->充值
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletRechargeViewController : BaseViewController
@property(nonatomic, strong) CurrencyInfo *currencyInfo;
@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@end

NS_ASSUME_NONNULL_END

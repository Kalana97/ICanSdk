//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletWithdrawViewController.h
- Description: 我行->ican钱包->钱包界面->提现
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletWithdrawViewController : BaseViewController
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;
@property(nonatomic, strong) CurrencyInfo *currencyInfo;

@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@end

NS_ASSUME_NONNULL_END

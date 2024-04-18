//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletRechargeQrCodeViewController.h
- Description:我行->ican钱包->钱包界面->充值二维码界面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletRechargeQrCodeViewController : BaseViewController
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;
@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, strong) CurrencyInfo *currencyInfo;
@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletAddNewAddressViewController.h
- Description: 我行->ican钱包->钱包界面->提现->添加新地址
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletAddNewAddressViewController : BaseViewController
@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property(nonatomic, copy) void (^addSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END

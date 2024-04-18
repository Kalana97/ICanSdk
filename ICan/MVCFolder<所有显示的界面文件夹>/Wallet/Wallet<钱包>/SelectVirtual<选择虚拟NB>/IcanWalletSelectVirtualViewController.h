//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletSelectVirtualViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,IcanWalletSelectVirtualType){
    IcanWalletSelectVirtualTypeRecharge,
    IcanWalletSelectVirtualTypeWithdraw,
    IcanWalletSelectVirtualTypeAddNewAddress,
    IcanWalletSelectVirtualTypeSettingMoney,///设置收款金额
    IcanWalletSelectVirtualTypeAvailabalCurrency,
    IcanWalletSelectVirtualTypeAllCurrency,
};
@interface IcanWalletSelectVirtualViewController : QDCommonTableViewController
@property(nonatomic, assign) IcanWalletSelectVirtualType type;
@property(nonatomic, strong) NSArray<CurrencyInfo*> *fromOrToCurrencyList;
@property(nonatomic, copy) void (^selectBlock)(CurrencyInfo*info);
@end

NS_ASSUME_NONNULL_END

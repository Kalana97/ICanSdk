//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewHeadView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,WalletFunctionType){
    WalletFunctionTypeRecharge,
    WalletFunctionTypeWithdraw,
    WalletFunctionTypeTransfer,
    WalletFunctionTypeC2C,
    WalletFunctionTypePay,
    WalletFunctionTypeFast,
    WalletFunctionTypeCurrency,
    WalletFunctionTypeHistory,
};
@interface WalletViewHeadView : UITableViewHeaderFooterView
@property(nonatomic, copy) void (^functionBlock)(WalletFunctionType type);
@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property(nonatomic, strong) C2CBalanceListInfo *currencyBalanceListInfo;
@property(nonatomic, strong) NSArray<C2CBalanceListInfo*> *currencyBalanceListItems;


@end

NS_ASSUME_NONNULL_END

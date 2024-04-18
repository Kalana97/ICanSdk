//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kWalletViewTableViewCell = @"WalletViewTableViewCell";
@interface WalletViewTableViewCell : BaseCell
@property(nonatomic, strong) C2CBalanceListInfo *listInfo;
@property(nonatomic, strong) NSArray<CurrencyInfo*> *allSupportedCurrenciesItems;
@end

NS_ASSUME_NONNULL_END

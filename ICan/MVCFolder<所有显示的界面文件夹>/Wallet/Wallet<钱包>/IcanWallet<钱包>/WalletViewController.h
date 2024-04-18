//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 12/10/2019
- File name:  WalletViewController.h
- Description: C2C钱包
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletViewController : QDCommonTableViewController
@property(nonatomic, strong) NSArray<C2CBalanceListInfo*> *currencyBalanceListItems;
@end

NS_ASSUME_NONNULL_END

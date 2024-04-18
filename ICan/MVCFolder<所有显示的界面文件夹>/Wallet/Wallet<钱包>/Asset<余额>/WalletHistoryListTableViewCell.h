//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  BillListTableViewCell.h
- Description: 账单页面
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kWalletHistoryListTableViewCell = @"WalletHistoryListTableViewCell";

@interface WalletHistoryListTableViewCell : BaseCell
@property (nonatomic,strong) ExchangeOrderInfo  *orderInfo;
@property (nonatomic,strong)BillInfo *billInfo;

@end

NS_ASSUME_NONNULL_END

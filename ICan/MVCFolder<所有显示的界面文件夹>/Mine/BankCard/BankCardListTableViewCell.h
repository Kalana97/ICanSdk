//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  BankCardListTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kBankCardListTableViewCell = @"BankCardListTableViewCell";;
static CGFloat const kHeightBankCardListTableViewCell = 105;
@interface BankCardListTableViewCell : BaseCell
@property(nonatomic, strong) BindingBankCardListInfo *bindingBankCardListInfo;
@end

NS_ASSUME_NONNULL_END

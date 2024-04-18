//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectUserCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanTransferSelectUserCell = @"IcanTransferSelectBankUserCell";
@interface IcanTransferSelectBankUserCell : BaseCell
@property(nonatomic, strong) BindingBankCardListInfo *cardInfo;
@end

NS_ASSUME_NONNULL_END

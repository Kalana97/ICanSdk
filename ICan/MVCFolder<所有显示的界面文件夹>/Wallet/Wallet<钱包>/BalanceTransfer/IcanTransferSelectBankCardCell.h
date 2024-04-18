//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectBankCardCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanTransferSelectBankCardCell = @"IcanTransferSelectBankCardCell";
@interface IcanTransferSelectBankCardCell : BaseCell
@property(nonatomic, strong) CommonBankCardsInfo *cardInfo;
@end

NS_ASSUME_NONNULL_END

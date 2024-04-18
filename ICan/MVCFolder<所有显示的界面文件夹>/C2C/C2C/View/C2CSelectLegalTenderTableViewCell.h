//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CSelectLegalTenderTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CSelectLegalTenderTableViewCell = @"C2CSelectLegalTenderTableViewCell";
@interface C2CSelectLegalTenderTableViewCell : BaseCell

@property (nonatomic, strong) CurrencyInfo *currencyInfo;
@property (nonatomic, strong) C2CCollectCurrencyInfo *collectInfo;
@property(nonatomic, copy) void (^selectBlock)(BOOL select);
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 26/11/2021
- File name:  C2CAdverFilterCurrencyPopViewCurrencyCell.h
- Description:
- Function List:
*/
        

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CAdverFilterCurrencyPopViewCurrencyCell = @"C2CAdverFilterCurrencyPopViewCurrencyCell";
@interface C2CAdverFilterCurrencyPopViewCurrencyCell : QMUITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *allStateImgView;
@property (weak, nonatomic) IBOutlet UILabel *allStateLabel;

@property (nonatomic, strong) CurrencyInfo *currencyInfo;
@end

NS_ASSUME_NONNULL_END

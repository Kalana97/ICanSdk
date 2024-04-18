//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 26/11/2021
- File name:  C2CAdverFilterCurrencyPopViewCurrencyCell.m
- Description:
- Function List:
*/
        

#import "C2CAdverFilterCurrencyPopViewCurrencyCell.h"
@interface C2CAdverFilterCurrencyPopViewCurrencyCell()


@end

@implementation C2CAdverFilterCurrencyPopViewCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setCurrencyInfo:(CurrencyInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    self.allStateLabel.text = currencyInfo.code;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end

//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletSelectVirtualTableViewCell.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelectVirtualTableViewCell.h"
@interface IcanWalletSelectVirtualTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *currencyIcon;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end
@implementation IcanWalletSelectVirtualTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
}

-(void)setCurrencyInfo:(CurrencyInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    
    if ([self.fromToOtherCode  isEqual: @"from"]) {
        [self.currencyIcon setImageWithString:currencyInfo.icon placeholder:nil];
        self.codeLabel.text = currencyInfo.code;
        self.codeLabel2.text = currencyInfo.symbol;
        self.moneyLabel.text = currencyInfo.type;
    }else if ([self.fromToOtherCode  isEqual: @"to"]){
        [self.currencyIcon setImageWithString:currencyInfo.icon placeholder:nil];
        self.codeLabel.text = currencyInfo.code;
        self.codeLabel2.text = currencyInfo.symbol;
        self.moneyLabel.hidden = YES;
    }else{
        [self.currencyIcon setImageWithString:currencyInfo.icon placeholder:nil];
        self.codeLabel.text = currencyInfo.code;
        self.codeLabel2.text = currencyInfo.symbol;
        self.moneyLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end

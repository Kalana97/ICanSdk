//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CSelectLegalTenderTableViewCell.m
- Description:
- Function List:
*/
        

#import "C2CSelectLegalTenderTableViewCell.h"
@interface C2CSelectLegalTenderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *countryIconImgView;

@end
@implementation C2CSelectLegalTenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_c2c_collectlegal_nor") forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_c2c_collectlegal_sel") forState:UIControlStateSelected];

}
-(void)setCurrencyInfo:(CurrencyInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    self.symbolLabel.text = currencyInfo.symbol;
    self.codeLabel.text = currencyInfo.code;
    [self.countryIconImgView setImageWithString:currencyInfo.flag placeholder:nil];
    self.selectBtn.selected = [[C2CUserManager shared]getIsCollectCurrencyWithCode:currencyInfo.code];
}
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    !self.selectBlock?:self.selectBlock(self.selectBtn.selected);
}
-(void)setCollectInfo:(C2CCollectCurrencyInfo *)collectInfo{
    CurrencyInfo * info  = [[C2CUserManager shared]getCurrecyInfoWithCode:collectInfo.code];
    self.symbolLabel.text = info.symbol;
    self.codeLabel.text = info.code;
    self.selectBtn.selected = YES;
    [self.countryIconImgView setImageWithString:info.flag placeholder:nil];
}
@end

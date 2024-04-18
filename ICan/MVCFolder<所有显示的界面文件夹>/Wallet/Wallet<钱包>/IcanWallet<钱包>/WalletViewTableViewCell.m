
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewTableViewCell.m
- Description:
- Function List:
*/
        

#import "WalletViewTableViewCell.h"

@interface WalletViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabe;
@property (weak, nonatomic) IBOutlet UILabel *banlanceLab;
@property (weak, nonatomic) IBOutlet UILabel *freezeLab;
@property (weak, nonatomic) IBOutlet UILabel *freezeLabAmount;
@end

@implementation WalletViewTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.titleLabel.textColor = UIColorThemeMainTitleColor;
    self.desLabe.textColor = UIColorThemeMainSubTitleColor;
    self.banlanceLab.textColor = UIColorThemeMainTitleColor;
    [self.typeImgView layerWithCornerRadius:11 borderWidth:0 borderColor:nil];
}
#pragma mark - Setter
-(void)setListInfo:(C2CBalanceListInfo *)listInfo{
    _listInfo = listInfo;
    CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:listInfo.code];
    if (info) {
        if (BaseSettingManager.isChinaLanguages) {
            self.desLabe.text = info.nameCn;
        }else{
            self.desLabe.text = info.nameEn;
        }
        [self.typeImgView setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
    }else{
        self.desLabe.text = listInfo.code;
        self.typeImgView.image = UIImageMake(@"icon_c2c_currency_default");
    }
    self.banlanceLab.text = [listInfo.money calculateByNSRoundDownScale:8].currencyString;
    self.titleLabel.text = listInfo.code;
    self.freezeLab.text = [listInfo.frozenMoney calculateByNSRoundDownScale:8].currencyString;
//    self.freezeLabAmount.text = @"Freez";
    self.freezeLabAmount.text = [NSString stringWithFormat:@"%@", @"FreezAmount".icanlocalized];
}


@end

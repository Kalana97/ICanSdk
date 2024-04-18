//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 29/3/2022
- File name:  IcanThirdPayTableViewCell.m
- Description:
- Function List:
*/
        

#import "IcanThirdPayTableViewCell.h"
@interface IcanThirdPayTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *assetImgView;
@property (weak, nonatomic) IBOutlet UILabel *assetLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;


@end
@implementation IcanThirdPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    
}
-(void)setAssetInfo:(C2CBalanceListInfo *)assetInfo{
    _assetInfo = assetInfo;
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        if ([assetInfo.code isEqualToString:@"CNY"]) {
            self.assetLab.text = @"IcanBalance".icanlocalized;
            self.amountLab.text = [NSString stringWithFormat:@"￥ %@",assetInfo.money.currencyString];
            self.assetImgView.image = UIImageMake(@"wallet_payView_balance");
        }else{
            self.assetLab.text = assetInfo.code;
            CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:assetInfo.code];
            if (info) {
                self.amountLab.text = [NSString stringWithFormat:@"%@ %@",info.symbol,[assetInfo.money calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.amountLab.text = [NSString stringWithFormat:@"%@ %@",assetInfo.code,[assetInfo.money calculateByNSRoundDownScale:2].currencyString];
            }
            [self.assetImgView setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
        }
    }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        if ([assetInfo.code isEqualToString:@"CNT"]) {
            self.assetLab.text = @"IcanBalance".icanlocalized;
            self.amountLab.text = [NSString stringWithFormat:@"￥ %@",assetInfo.money.currencyString];
            self.assetImgView.image = UIImageMake(@"wallet_payView_balance");
        }else{
            self.assetLab.text = assetInfo.code;
            CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:assetInfo.code];
            if (info) {
                self.amountLab.text = [NSString stringWithFormat:@"%@ %@",info.symbol,[assetInfo.money calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.amountLab.text = [NSString stringWithFormat:@"%@ %@",assetInfo.code,[assetInfo.money calculateByNSRoundDownScale:2].currencyString];
            }
            [self.assetImgView setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
        }
    }
}
@end

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListTableViewCell.m
- Description:
- Function List:
*/
        

#import "ExchangeCurrencyListTableViewCell.h"

@interface ExchangeCurrencyListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *buyTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *saleTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *saleMonetLab;

@end

@implementation ExchangeCurrencyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    
}
-(void)setCurrencyInfo:(CurrencyExchangeInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    NSString*currencyName =BaseSettingManager.isChinaLanguages?currencyInfo.fromInfo.nameCn:currencyInfo.fromInfo.nameEn;
    NSString*targetCurrencyName = BaseSettingManager.isChinaLanguages?currencyInfo.toInfo.nameCn:currencyInfo.toInfo.nameEn;
    if (self.isExchangeList) {
        NSString * title = [NSString stringWithFormat:@"%@\n 兑%@",targetCurrencyName,currencyName];
        NSMutableAttributedString*titleAtt = [[NSMutableAttributedString alloc]initWithString:title];
        [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, title.length)];
        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, title.length)];
        [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColor252730Color range:NSMakeRange(0, targetCurrencyName.length)];
        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, targetCurrencyName.length)];
        self.titleLab.attributedText = titleAtt;
        
    }else{
        NSString * title = [NSString stringWithFormat:@"%@/%@>",targetCurrencyName,currencyName];
        NSMutableAttributedString*titleAtt = [[NSMutableAttributedString alloc]initWithString:title];
        [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, title.length)];
        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, title.length)];
        [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(0, targetCurrencyName.length)];
        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, targetCurrencyName.length)];
        self.titleLab.attributedText = titleAtt;
    }
    
    
    self.buyTitleLab.text = [NSString stringWithFormat:@"%@%@",@"Buy".icanlocalized,currencyInfo.toInfo.code];
    self.saleTitleLab.text = [NSString stringWithFormat:@"%@%@",@"Sell".icanlocalized,currencyInfo.fromInfo.code];
    if ([currencyInfo.toInfo.type isEqualToString:@"LegalTender"]) {
        self.buyMoneyLab.text = [NSString stringWithFormat:@"%@",[currencyInfo.buyPrice calculateWithRoundingMode:NSRoundPlain scale:2].currencyString];
        self.saleMonetLab.text = [NSString stringWithFormat:@"%@",[currencyInfo.sellPrice calculateWithRoundingMode:NSRoundPlain scale:2].currencyString];
    }else{
        self.buyMoneyLab.text = [NSString stringWithFormat:@"%@",[currencyInfo.buyPrice calculateWithRoundingMode:NSRoundPlain scale:8].currencyString];
        self.saleMonetLab.text = [NSString stringWithFormat:@"%@",[currencyInfo.sellPrice calculateWithRoundingMode:NSRoundPlain scale:8].currencyString];
    }
  
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

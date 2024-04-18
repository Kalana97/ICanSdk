//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListTableViewCell.m
- Description:
- Function List:
*/
        

#import "ExchangeCurrencyTableViewCell.h"

@interface ExchangeCurrencyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *buyTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLab;
//@property (weak, nonatomic) IBOutlet UILabel *saleTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *saleMonetLab;

@end

@implementation ExchangeCurrencyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    
}
-(void)setCurrencyInfo:(CurrencyExchangeInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    NSString*currencyName =BaseSettingManager.isChinaLanguages?currencyInfo.fromInfo.nameCn:currencyInfo.fromInfo.nameEn;
    NSString*targetCurrencyName = BaseSettingManager.isChinaLanguages?currencyInfo.toInfo.nameCn:currencyInfo.toInfo.nameEn;
    NSString * title = [NSString stringWithFormat:@"%@\n 兑 %@",targetCurrencyName,currencyName];
    NSMutableAttributedString*titleAtt = [[NSMutableAttributedString alloc]initWithString:title];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, title.length)];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, title.length)];
    [titleAtt addAttribute:NSForegroundColorAttributeName value:UIColor252730Color range:NSMakeRange(0, targetCurrencyName.length)];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, targetCurrencyName.length)];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 2;
    [titleAtt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    self.titleLab.attributedText = titleAtt;
    
    
//    self.buyTitleLab.text = [NSString stringWithFormat:@"%@%@",@"Buy".icanlocalized,currencyInfo.targetCurrency.code];
    self.buyMoneyLab.text = currencyInfo.sellPrice.stringValue.currencyString;
    
//    self.saleTitleLab.text = [NSString stringWithFormat:@"%@%@",@"Sell".icanlocalized,currencyInfo.currency.code];
    self.saleMonetLab.text = currencyInfo.buyPrice.stringValue.currencyString;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

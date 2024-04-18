//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListHead.m
- Description:
- Function List:
*/
        

#import "ExchangeCurrencyListHead.h"
@interface ExchangeCurrencyListHead()
@property (weak, nonatomic) IBOutlet UILabel *exchangeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;

@end
@implementation ExchangeCurrencyListHead
-(void)awakeFromNib{
    [super awakeFromNib];
    self.targetCurrencyLab.text = @"RMB";
    self.exchangeLab.text = @"Exchange".icanlocalized;
    NSString * string = [[NSString alloc]initWithFormat:@"%@/%@",@"Currency".icanlocalized,@"Code".icanlocalized];
    NSMutableAttributedString*att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(0, string.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    [att addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(@"Currency".icanlocalized.length, @"Code".icanlocalized.length+1)];
    self.titleLabe.attributedText = att;
}
- (IBAction)selectCurrencyAction {
    if (self.selectCurrencyBlock) {
        self.selectCurrencyBlock();
    }
}


@end

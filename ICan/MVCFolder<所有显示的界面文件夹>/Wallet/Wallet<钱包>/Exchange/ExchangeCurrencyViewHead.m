//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListHead.m
- Description:
- Function List:
*/
        

#import "ExchangeCurrencyViewHead.h"
#import "HJCActionSheet.h"
@interface ExchangeCurrencyViewHead()<HJCActionSheetDelegate,QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *exchangeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;

@property (weak, nonatomic) IBOutlet UILabel *listpriceLabel;

//我要买入
@property (weak, nonatomic) IBOutlet UIControl *buyCon;
@property (weak, nonatomic) IBOutlet UILabel *buyTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *buyCurrencyLab;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;



//我要卖出
@property (weak, nonatomic) IBOutlet UIControl *saleCon;
@property (weak, nonatomic) IBOutlet UILabel *saleTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *saleCurrencyLab;
@property (weak, nonatomic) IBOutlet UIImageView *saleDropDownImg;


//汇率提示label
@property (weak, nonatomic) IBOutlet UILabel *rateTipLabel;

//双箭头
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
//兑换
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

//我要卖出
@property (weak, nonatomic) IBOutlet UILabel *sellTitleLab;
//我要买入
@property (weak, nonatomic) IBOutlet UILabel *buyTitleLabel;

//需要兑换的货币 被兑换的货币
@property(nonatomic, strong) NSMutableArray<CurrencyInfo*> *fromCurrencyItems;
/** 目标货币的中文 */
@property(nonatomic, strong) NSArray *fromCurrencyCNItmes;
@property(nonatomic, strong) NSArray *fromCurrencyENItmes;
//兑换成的货币
@property(nonatomic, strong) NSMutableArray<CurrencyInfo*> *toCurrencyItems;
@property(nonatomic, strong) NSArray *toCurrencyCNItmes;
@property(nonatomic, strong) NSArray *toCurrencyENItmes;
@end
@implementation ExchangeCurrencyViewHead
-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.buyTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.saleTextField];
    [self.exchangeBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.exchangeBtn setTitle:@"Exchange".icanlocalized forState:UIControlStateNormal];
    NSString * string = [[NSString alloc]initWithFormat:@"%@/%@",@"Currency".icanlocalized,@"Code".icanlocalized];
    NSMutableAttributedString*att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(0, string.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    [att addAttribute:NSForegroundColorAttributeName value:UIColorMake(126, 183, 248) range:NSMakeRange(@"Currency".icanlocalized.length, @"Code".icanlocalized.length+1)];
    self.titleLabe.attributedText = att;
}
-(void)setCurrencyExchangeInfo:(CurrencyExchangeInfo *)currencyExchangeInfo{
    _currencyExchangeInfo = currencyExchangeInfo;
    //targetCurrencyCode
    //获取对应的持有货币
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"toCode == %@ ",self.currencyExchangeInfo.toCode];
    NSArray*resultItems= [self.currencyItems filteredArrayUsingPredicate:gpredicate];
    self.toCurrencyItems = [NSMutableArray array];
    for (CurrencyExchangeInfo*info in resultItems) {
        [self.toCurrencyItems addObject:info.toInfo];
    }
    
    //获取能被购买的虚拟货币
    self.fromCurrencyItems = [NSMutableArray array];
    for (CurrencyExchangeInfo*info in self.currencyItems) {
        [self.fromCurrencyItems addObject:info.fromInfo];
    }
    //获取需要被兑换的标题数组 区分中英文
    self.fromCurrencyCNItmes = [self.fromCurrencyItems valueForKeyPath:@"nameCn"];
    self.fromCurrencyENItmes = [self.fromCurrencyItems valueForKeyPath:@"nameEn"];
    //去重
    self.fromCurrencyCNItmes = [self.fromCurrencyCNItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
    self.fromCurrencyENItmes = [self.fromCurrencyENItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    self.toCurrencyCNItmes = [self.toCurrencyItems valueForKeyPath:@"nameCn"];
    self.toCurrencyENItmes = [self.toCurrencyItems valueForKeyPath:@"nameEn"];
    //去除重复数据
    self.toCurrencyENItmes = [self.toCurrencyENItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
    self.toCurrencyCNItmes = [self.toCurrencyCNItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
    [self setRateTipsLabel];
    
}
-(void)textDidChange:(NSNotification*)noti{
    QMUITextField *textField = noti.object;
    if (textField == self.buyTextField) {
        double money = self.buyTextField.text.doubleValue;
        self.saleTextField.text = [NSString stringWithFormat:@"%.2f",(1/self.currencyExchangeInfo.buyPrice.doubleValue)*money];
    }else{
        double money = self.saleTextField.text.doubleValue;
        self.buyTextField.text = [NSString stringWithFormat:@"%.6f",self.currencyExchangeInfo.buyPrice.doubleValue*money];
    }
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length >= 1) { // 删除数据, 都允许删除
        return YES;
    }
    if (![self checkDecimal:[textField.text stringByAppendingString:string]]){
        if (textField.text.length > 0 && [string isEqualToString:@"."] && ![textField.text containsString:@"."]) {
            return YES;
        }
        return NO;
    }
    return YES;
}
/**
 判断是否是两位小
 @param str 字符串
 @return yes/no
 */
- (BOOL)checkDecimal:(NSString *)str{
    NSString *regex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([pred evaluateWithObject: str]){
        return YES;
    }else{
        return NO;
    }
}
///检查切换按钮能否点击
-(void)checkChangeBtnEnd{
    
    NSPredicate * fromgpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ && toCode == %@",self.currencyExchangeInfo.fromCode,self.currencyExchangeInfo.toCode];
    NSArray*fromresultItems= [self.currencyItems filteredArrayUsingPredicate:fromgpredicate];
    
    NSPredicate * togpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ && toCode == %@",self.currencyExchangeInfo.toCode,self.currencyExchangeInfo.fromCode];
    NSArray*toresultItems= [self.currencyItems filteredArrayUsingPredicate:togpredicate];
    if (fromresultItems.count>0&&toresultItems.count>0) {
        self.changeBtn.enabled = YES;
    }else{
        self.changeBtn.enabled = NO;
    }
}
- (IBAction)buyAction {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    HJCActionSheet * sheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:@"Cancel".icanlocalized otherTitles:BaseSettingManager.isChinaLanguages?self.fromCurrencyCNItmes:self.fromCurrencyENItmes];
    sheet.tag = 0;
    [sheet show];
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0) {
        NSString *title;
        //当前选择的货币
        CurrencyInfo*info;
        if (BaseSettingManager.isChinaLanguages) {
            title = [self.fromCurrencyCNItmes objectAtIndex:buttonIndex-1];
            for (CurrencyInfo*cnInfo in self.fromCurrencyItems) {
                if ([cnInfo.nameCn isEqualToString:title]) {
                    info = cnInfo;
                    break;
                }
            }
        }else{
            title = [self.fromCurrencyENItmes objectAtIndex:buttonIndex-1];
            for (CurrencyInfo*cnInfo in self.fromCurrencyItems) {
                if ([cnInfo.nameEn isEqualToString:title]) {
                    info = cnInfo;
                    break;
                }
            }
        }
        
        //根据当前选择的货币查询所有符合的牌价 当前需要买入的货币
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"toCode == %@ ",info.code];
        NSArray*resultItems= [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        NSPredicate * nowpredicate = [NSPredicate predicateWithFormat:@"toCode == %@ && fromCode == %@",info.code,self.currencyExchangeInfo.fromCode];
        NSArray*nowresultItems= [self.currencyItems filteredArrayUsingPredicate:nowpredicate];
        if (nowresultItems.count>0) {
            self.currencyExchangeInfo = nowresultItems.firstObject;
        }else{
            self.currencyExchangeInfo = resultItems.firstObject;
        }
       
        //获取需要买入的货币 支持的货币数组
        self.toCurrencyItems = [NSMutableArray array];
        for (CurrencyExchangeInfo*info in resultItems) {
            [self.toCurrencyItems addObject:info.fromInfo];
        }
        self.toCurrencyCNItmes = [self.toCurrencyItems valueForKeyPath:@"nameCn"];
        self.toCurrencyENItmes = [self.toCurrencyItems valueForKeyPath:@"nameEn"];
        self.toCurrencyENItmes = [self.toCurrencyENItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
        self.toCurrencyCNItmes = [self.toCurrencyCNItmes valueForKeyPath:@"@distinctUnionOfObjects.self"];
        [self setRateTipsLabel];
        if (self.currencyCodeBlock) {
            self.currencyCodeBlock(self.currencyExchangeInfo);
        }
        
    }else if (actionSheet.tag == 1){
        NSString *title;
        //当前兑换成的货币
        CurrencyInfo*info;
        if (BaseSettingManager.isChinaLanguages) {
            title = [self.toCurrencyCNItmes objectAtIndex:buttonIndex-1];
            for (CurrencyInfo*cnInfo in self.toCurrencyItems) {
                if ([cnInfo.nameCn isEqualToString:title]) {
                    info = cnInfo;
                    break;
                }
            }
        }else{
            title = [self.toCurrencyENItmes objectAtIndex:buttonIndex-1];
            for (CurrencyInfo*cnInfo in self.toCurrencyItems) {
                if ([cnInfo.nameEn isEqualToString:title]) {
                    info = cnInfo;
                    break;
                }
            }
        }
        //
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"fromCode == %@ && toCode == %@",self.currencyExchangeInfo.fromCode,info.code];
        NSArray*resultItems= [self.currencyItems filteredArrayUsingPredicate:gpredicate];
        self.currencyExchangeInfo = resultItems.firstObject;
        [self setRateTipsLabel];
        if (self.currencyCodeBlock) {
            self.currencyCodeBlock(self.currencyExchangeInfo);
        }
       
    }
}
-(void)setRateTipsLabel{
    self.saleCurrencyLab.text =BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.fromInfo.nameCn: self.currencyExchangeInfo.fromInfo.nameEn;
    self.buyCurrencyLab.text =BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.toInfo.nameCn: self.currencyExchangeInfo.toInfo.nameEn;
    self.rateTipLabel.text = [NSString stringWithFormat:@"1 %@ = %@ %@",BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.toInfo.nameCn:self.currencyExchangeInfo.toInfo.nameEn,@(1.0/self.currencyExchangeInfo.buyPrice.doubleValue).stringValue.currencyString,BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.fromInfo.nameCn:self.currencyExchangeInfo.fromInfo.nameEn];
    //判断按钮是否可以点击
    [self checkChangeBtnEnd];
    //给一个默认值
    self.buyTextField.text = [NSString stringWithFormat:@"%@",self.currencyExchangeInfo.min];
    self.saleTextField.text = [NSString stringWithFormat:@"%.2f",(1/self.currencyExchangeInfo.buyPrice.doubleValue)*self.buyTextField.text.floatValue];
}
- (IBAction)saleAction {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    HJCActionSheet * sheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:@"Cancel".icanlocalized otherTitles:BaseSettingManager.isChinaLanguages?self.toCurrencyCNItmes:self.toCurrencyENItmes];
    sheet.tag = 1;
    [sheet show];
}
/** 两个切换 */
- (IBAction)changeBtnAction:(id)sender {
    //筛选条件 把 toCode 和 fromCode切换过来重新筛选
    NSPredicate * togpredicate = [NSPredicate predicateWithFormat:@"toCode == %@ && fromCode == %@",self.currencyExchangeInfo.fromCode,self.currencyExchangeInfo.toCode];
    NSArray*toresultItems= [self.currencyItems filteredArrayUsingPredicate:togpredicate];
    self.currencyExchangeInfo = toresultItems.firstObject;
    self.buyCurrencyLab.text =BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.fromInfo.nameCn: self.currencyExchangeInfo.fromInfo.nameEn;
    self.saleCurrencyLab.text =BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.toInfo.nameCn: self.currencyExchangeInfo.toInfo.nameEn;
    self.rateTipLabel.text = [NSString stringWithFormat:@"1 %@ = %@ %@",BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.fromInfo.nameCn:self.currencyExchangeInfo.fromInfo.nameEn,self.currencyExchangeInfo.buyPrice.stringValue.currencyString,BaseSettingManager.isChinaLanguages?self.currencyExchangeInfo.toInfo.nameCn:self.currencyExchangeInfo.toInfo.nameEn];
    self.buyTextField.text = @"";
    self.saleTextField.text = @"";
    if (self.currencyCodeBlock) {
        self.currencyCodeBlock(self.currencyExchangeInfo);
    }
}
/** 兑换 也就是购买 */
- (IBAction)exchangeBtnAction {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    !self.exchangeBlock?:self.exchangeBlock();
}
@end

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  BillListTableViewCell.m
- Description:
- Function List:
*/
        

#import "BillListTableViewCell.h"
#import "GetTime.h"
@interface BillListTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation BillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorThemeMainBgColor;

    self.moneyLabel.textColor=UIColorThemeMainColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    self.timeLabel.textColor=UIColorThemeMainSubTitleColor;
    self.balanceLabel.textColor=UIColorThemeMainSubTitleColor;
    [self.iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
}

-(void)setUpUI{
    [super setUpUI];
}

-(NSString *)getAmountConvert:(NSString *)amountValue{
    NSNumberFormatter *formatterConvert = [[NSNumberFormatter alloc] init];
    formatterConvert.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *convertedVal = [formatterConvert numberFromString:amountValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 20;
    NSString *result = [formatter stringFromNumber:convertedVal];
    return result;
}

-(void)setC2cFlowsInfo:(C2CFlowsInfo *)c2cFlowsInfo{
    _c2cFlowsInfo = c2cFlowsInfo;
    self.timeLabel.text=[GetTime convertDateWithString:c2cFlowsInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    if([c2cFlowsInfo.flowType isEqualToString:@"CurrencyExchange"]) {
        self.moneyLabel.textColor = UIColorMake(244, 81, 105);
        self.iconImageView.image = UIImageMake(@"billList_currency_ex");
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",[c2cFlowsInfo.amount calculateByNSRoundDownScaleSpecial:2].currencyString];
    }else{
        if (c2cFlowsInfo.amount.floatValue >0) {
            self.moneyLabel.textColor = UIColorThemeMainColor;
            if ([c2cFlowsInfo.currencyCode isEqualToString:@"USDT"]){
                self.moneyLabel.text = [NSString stringWithFormat:@"+%@",[c2cFlowsInfo.amount calculateByNSRoundDownScaleSpecial:8].currencyString];
            }else{
                NSString *amount = [c2cFlowsInfo.amount calculateByNSRoundDownScaleSpecial:8].currencyString;
                self.moneyLabel.text = [NSString stringWithFormat:@"+%@",amount];
            }
        }else{
            self.moneyLabel.textColor = UIColorMake(244, 81, 105);
            if ([c2cFlowsInfo.currencyCode isEqualToString:@"USDT"]){
                self.moneyLabel.text = [NSString stringWithFormat:@"%@",[c2cFlowsInfo.amount calculateByNSRoundDownScaleSpecial:8].currencyString];
            }else{
                NSString *amount = [c2cFlowsInfo.amount calculateByNSRoundDownScaleSpecial:8].currencyString;
                self.moneyLabel.text = amount;
            }
        }
        if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalWithdraw"]) {
            self.iconImageView.image = UIImageMake(@"billList_withdraw");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"QrcodePayFlow"]) {
            self.iconImageView.image = UIImageMake(@"billList_qr_pay");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"TransferRecord"]) {
            self.iconImageView.image = UIImageMake(@"billList_transfer");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"AdOrder"]) {
            self.iconImageView.image = UIImageMake(@"billList_c2c");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"FundsTransfer"]) {
            self.iconImageView.image = UIImageMake(@"billList_wallet");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExternalRecharge"]){
            self.iconImageView.image = UIImageMake(@"billList_block");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrder"]){
            self.iconImageView.image = UIImageMake(@"billList_third_party");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"OfflineRecharge"]){
            self.iconImageView.image = UIImageMake(@"billList_offline_recharge");
            
        }else if ([c2cFlowsInfo.flowType isEqualToString:@"ExtPaymentOrderRefund"]){
            self.iconImageView.image = UIImageMake(@"billList_extpaymntAward");
        }
    }
    
    self.balanceLabel.text = c2cFlowsInfo.currencyCode;
   
    self.nameLabel.text = c2cFlowsInfo.showTitle;
}

-(void)setBillInfo:(BillInfo *)billInfo{
    _billInfo = billInfo;
    NSString *amt = [self getFormatBillValue:billInfo.amount];
    if (billInfo.amount >0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@%@",[[UserInfoManager sharedManager] getSymbol:billInfo.unit],amt];
        self.moneyLabel.textColor=UIColorThemeMainColor;
    }else{
         self.moneyLabel.textColor=UIColorMake(244, 81, 105);
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%@",[[UserInfoManager sharedManager] getSymbol:billInfo.unit],amt];
    }
    self.nameLabel.text = billInfo.listTitle;
    [self.iconImageView setImage:UIImageMake(billInfo.imageStr)];
    if (billInfo.time) {
        self.timeLabel.text =  self.timeLabel.text=[GetTime convertDateWithString:billInfo.time dateFormmate:@"yyyy-MM-dd HH:mm:ss"];;
    }else{
        self.timeLabel.text = billInfo.createTime;
    }
    
    if (billInfo.balance) {
        NSString *balance = [self getFormatBillValue:self.billInfo.balance];
        self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",@"Balance".icanlocalized,balance];
    }else{
        self.balanceLabel.text = @"";
    }
}

-(NSString *)getFormatBillValue:(double)value{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setMinimumFractionDigits:2];
    NSNumber *number1 = [NSNumber numberWithDouble:value];
    NSString *formattedString1 = [numberFormatter stringFromNumber:number1];
    return formattedString1;
}

@end

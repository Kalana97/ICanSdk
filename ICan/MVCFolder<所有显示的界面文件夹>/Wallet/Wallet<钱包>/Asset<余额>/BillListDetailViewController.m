//  Transaction details页面
//  BillListDetailViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/17.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BillListDetailViewController.h"

@interface BillListDetailViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *centerBgView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;


@property (weak, nonatomic) IBOutlet UIView *lineView2;


@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkDetailLabel;

@property(nonatomic,weak)  IBOutlet  UILabel * priceLabel;
@property(nonatomic,weak)  IBOutlet  UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property(nonatomic,weak)  IBOutlet  UIImageView * iconImageView;
//支付类型

@property (weak, nonatomic) IBOutlet UIStackView *payTypeBgView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *payTypeLineView;
//实付金额
@property (weak, nonatomic) IBOutlet UIStackView *actualAmountBgView;
@property (weak, nonatomic) IBOutlet UILabel *actualAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualAmountDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *actualAmountLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLIneVeiw;

@end

@implementation BillListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorViewBgColor;
    self.orderLabel.text=@"Order Number".icanlocalized;
    self.orderLabel.textColor = UIColorThemeMainSubTitleColor;
    self.orderDetailLabel.textColor = UIColorThemeMainTitleColor;

    self.timeLabel.text=@"Trading Hours".icanlocalized;
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.timeDetailLabel.textColor = UIColorThemeMainTitleColor;

    self.typeLabel.text=@"TransactionType".icanlocalized;
    self.typeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.typeDetailLabel.textColor = UIColorThemeMainTitleColor;

    self.remarkLabel.text=@"Remark".icanlocalized;
    self.remarkLabel.textColor = UIColorThemeMainSubTitleColor;
    self.remarkDetailLabel.textColor = UIColorThemeMainTitleColor;

    self.payTypeLabel.text=@"BillListDetailViewController.payType".icanlocalized;
    self.payTypeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.payTypeDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    self.actualAmountLabel.text=@"BillListDetailViewController.actualAmountLabel".icanlocalized;
    self.actualAmountLabel.textColor = UIColorThemeMainSubTitleColor;
    self.actualAmountDetailLabel.textColor = UIColorThemeMainTitleColor;
    
    self.bottomLIneVeiw.backgroundColor = UIColorSeparatorColor;
    NSString *amt = [self getFormatBillValue:self.billInfo.amount];
    if (self.billInfo.payChannelType) {
        self.payTypeLineView.hidden=self.payTypeBgView.hidden=NO;
        self.payTypeDetailLabel.text=self.billInfo.payChannelTypeName;
    }else{
        self.payTypeLineView.hidden=self.payTypeBgView.hidden=YES;
    }
   
    if (self.billInfo.actualAmount == self.billInfo.amount&&[self.billInfo.actualUnit isEqualToString:self.billInfo.unit]) {
        self.actualAmountBgView.hidden=self.actualAmountLineView.hidden=YES;
    }else{
        if (self.billInfo.actualAmount >0) {
            if ([self.billInfo.actualUnit isEqualToString:@"LKR"]) {
                self.actualAmountDetailLabel.text = [NSString stringWithFormat:@"+Rs%.2f",self.billInfo.actualAmount];
            }else{
                self.actualAmountDetailLabel.text = [NSString stringWithFormat:@"+￥%f",self.billInfo.actualAmount];
            }
            
        }else{
            
            if ([self.billInfo.actualUnit isEqualToString:@"LKR"]) {
                self.actualAmountDetailLabel.text = [NSString stringWithFormat:@"Rs%.2f",[[NSString stringWithFormat:@"%.2f",self.billInfo.actualAmount] substringFromIndex:1].doubleValue];
            }else{
                self.actualAmountDetailLabel.text = [NSString stringWithFormat:@"￥%f",self.billInfo.actualAmount];
            }
        }
    }
    
    if (self.billInfo.amount>0) {
        if ([self.billInfo.unit isEqualToString:@"LKR"]) {
            self.priceLabel.text = [NSString stringWithFormat:@"+Rs%@",amt];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"+￥%@",amt ];
        }
        self.priceLabel.textColor=UIColorSystemGreen;
    }else{
        self.priceLabel.textColor=UIColorMake(244, 81, 105);
        if ([self.billInfo.unit isEqualToString:@"LKR"]) {
            self.priceLabel.text = [NSString stringWithFormat:@"Rs%@",amt];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",amt];
        }
    }
    [self.iconImageView setImage:UIImageMake(@"icon_c2c_confirm_green")];
    if (BaseSettingManager.isChinaLanguages) {
        self.titleLabel.text=self.billInfo.content;
    }else{
        self.titleLabel.text=self.billInfo.contentEn;
    }
    
    self.typeDetailLabel.text = self.billInfo.flowTypeTitle;
    self.orderDetailLabel.text = self.billInfo.flowCode;
    if (self.billInfo.time) {
        self.timeDetailLabel.text = [GetTime convertDateWithString:self.billInfo.time dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        self.timeDetailLabel.text = self.billInfo.createTime;
    }
    if (BaseSettingManager.isChinaLanguages) {
        self.remarkDetailLabel.text = self.billInfo.reason;
    }else{
        self.remarkDetailLabel.text = self.billInfo.reasonEn;
    }
    self.title = self.titleLabel.text;
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

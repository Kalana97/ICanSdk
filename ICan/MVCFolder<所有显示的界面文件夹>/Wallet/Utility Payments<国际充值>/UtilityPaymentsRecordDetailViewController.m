
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/6/2021
- File name:  UtilityPaymentsRecordDetailViewController.m
- Description:
- Function List:
*/
        

#import "UtilityPaymentsRecordDetailViewController.h"

@interface UtilityPaymentsRecordDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;


@property (weak, nonatomic) IBOutlet UILabel *orderNumberTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTypeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderMoneyTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
//充值状态 也就是交易状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIStackView *orderStatusBgView;
@property (weak, nonatomic) IBOutlet UIView *orderStatusLineView;



@property (weak, nonatomic) IBOutlet UILabel *orderPayStatusTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPayStatusLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


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

@property (weak, nonatomic) IBOutlet UILabel *accountNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *accountDetailLab;

@end

@implementation UtilityPaymentsRecordDetailViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    "UtilityPaymentsRecordDetailViewController.title"="Details";
    self.title=@"UtilityPaymentsRecordDetailViewController.title".icanlocalized;
//    "UtilityPaymentsRecordDetailViewController.orderNumberTipLabel"="交易单号";
//    "UtilityPaymentsRecordDetailViewController.orderTypeTipLabel"="交易类型";
//    "UtilityPaymentsRecordDetailViewController.orderMoneyTipLabel"="交易金额";
//    "UtilityPaymentsRecordDetailViewController.orderStatusTipLabel"="交易状态";
//    "UtilityPaymentsRecordDetailViewController.orderPayStatusTipLabel"="支付状态";
//    "UtilityPaymentsRecordDetailViewController.timeTipLabel"="交易时间";
//    "UtilityPaymentsRecordDetailViewController.remarkTipsLabel"="交易备注";
    self.orderNumberTipLabel.text=@"UtilityPaymentsRecordDetailViewController.orderNumberTipLabel".icanlocalized;
    self.orderTypeTipLabel.text=@"UtilityPaymentsRecordDetailViewController.orderTypeTipLabel".icanlocalized;
    self.orderMoneyTipLabel.text=@"UtilityPaymentsRecordDetailViewController.orderMoneyTipLabel".icanlocalized;
    self.orderStatusTipLabel.text=@"UtilityPaymentsRecordDetailViewController.orderStatusTipLabel".icanlocalized;
    self.orderPayStatusTipLabel.text=@"UtilityPaymentsRecordDetailViewController.orderPayStatusTipLabel".icanlocalized;
    self.timeTipLabel.text=@"UtilityPaymentsRecordDetailViewController.timeTipLabel".icanlocalized;
    self.remarkTipsLabel.text=@"UtilityPaymentsRecordDetailViewController.remarkTipsLabel".icanlocalized;
    self.payTypeLabel.text=@"BillListDetailViewController.payType".icanlocalized;
    self.actualAmountLabel.text=@"BillListDetailViewController.actualAmountLabel".icanlocalized;
    self.accountNumberLab.text = @"TransactionAccount".icanlocalized;
    [self.typeImgView layerWithCornerRadius:45 borderWidth:1 borderColor:UIColorMake(235, 234, 234)];
    [self.typeImgView setImageWithString:self.dialogOrderInfo.logo placeholder:nil];
    self.topLabel.text=self.dialogOrderInfo.dialogName;
    self.orderNumberLabel.text=self.dialogOrderInfo.orderId;
    if ([self.dialogOrderInfo.unit isEqualToString:@"LKR"]) {
        self.orderMoneyLabel.text=[NSString stringWithFormat:@"Rs%.2f",self.dialogOrderInfo.txAmount];;
    }else{
        self.orderMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",self.dialogOrderInfo.txAmount];;
    }
    if ([self.dialogOrderInfo.unit isEqualToString:self.dialogOrderInfo.actualUnit]&&self.dialogOrderInfo.txAmount==self.dialogOrderInfo.actualAmount) {
        self.actualAmountBgView.hidden=self.actualAmountLineView.hidden=YES;
    }else{
        if ([self.dialogOrderInfo.actualUnit isEqualToString:@"LKR"]) {
            self.actualAmountDetailLabel.text=[NSString stringWithFormat:@"Rs%.2f",self.dialogOrderInfo.actualAmount];;
        }else if([self.dialogOrderInfo.actualUnit isEqualToString:@"USDT"]){
            self.actualAmountDetailLabel.text = [NSString stringWithFormat:@"₮%.2f",self.dialogOrderInfo.actualAmount];;
        }else{
            self.actualAmountDetailLabel.text=[NSString stringWithFormat:@"￥%.2f",self.dialogOrderInfo.actualAmount];;
        }
    }
    self.orderTypeLabel.text=self.dialogOrderInfo.dialogName;;
//    "UtilityPaymentsRecordDetailViewController.topUping"="充值中";
    if ([self.dialogOrderInfo.payStatus isEqualToString:@"Paying"]) {
//        Paying,Success,Fail
        //支付状态
        self.orderPayStatusLabel.text=@"Paying".icanlocalized;
        //充值状态
        self.orderStatusLabel.text=@"UtilityPaymentsRecordDetailViewController.topUping".icanlocalized;
    }else  if ([self.dialogOrderInfo.payStatus isEqualToString:@"Success"]) {
        self.orderPayStatusLabel.text=@"payment successful".icanlocalized;
        if (self.dialogOrderInfo.rechargeStatus == nil || [self.dialogOrderInfo.rechargeStatus  isEqual: @""]){
            if (self.dialogOrderInfo.status) {
                if (self.dialogOrderInfo.status.intValue == 5 || self.dialogOrderInfo.status.intValue == 42 || (self.dialogOrderInfo.status.intValue >= 95 && self.dialogOrderInfo.status.intValue <= 100)) {
                    self.orderStatusLabel.text=@"Top-upSuccess".icanlocalized;
                }else{
                    self.orderStatusLabel.text=[NSString stringWithFormat:@"%@-%d",@"Top-upFailure".icanlocalized,self.dialogOrderInfo.status.intValue];
                }
            }else{
                
                self.orderStatusBgView.hidden = self.orderStatusLineView.hidden = YES;
            }
        }else{
            if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"SUCCESS"]){
                self.orderStatusLabel.text = @"Top-upSuccess".icanlocalized;
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"FAILED"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"Top-upFailure".icanlocalized];
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"PENDING"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"C2COrderPending".icanlocalized];
            }
        }
    }else if ([self.dialogOrderInfo.payStatus isEqualToString:@"Fail"]) {
        self.orderPayStatusLabel.text=@"CircleUserDetailViewController.payFailTip".icanlocalized;
        if (self.dialogOrderInfo.rechargeStatus == nil || [self.dialogOrderInfo.rechargeStatus  isEqual: @""]){
            if (self.dialogOrderInfo.status) {
                if (self.dialogOrderInfo.status.intValue == 5 || self.dialogOrderInfo.status.intValue == 42 || (self.dialogOrderInfo.status.intValue >= 95 && self.dialogOrderInfo.status.intValue <= 100)) {
                    self.orderStatusLabel.text=@"Top-upSuccess".icanlocalized;
                }else{
                    self.orderStatusLabel.text=[NSString stringWithFormat:@"%@-%d",@"Top-upFailure".icanlocalized,self.dialogOrderInfo.status.intValue];
                }
            }else{
                self.orderStatusBgView.hidden = self.orderStatusLineView.hidden = YES;
            }
        }else{
            if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"SUCCESS"]){
                self.orderStatusLabel.text = @"Top-upSuccess".icanlocalized;
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"FAILED"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"Top-upFailure".icanlocalized];
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"PENDING"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"C2COrderPending".icanlocalized];
            }
        }
    }else if ([self.dialogOrderInfo.payStatus isEqualToString:@"Refund"]){
        self.orderPayStatusLabel.text=@"Refund".icanlocalized;
        if (self.dialogOrderInfo.rechargeStatus == nil || [self.dialogOrderInfo.rechargeStatus  isEqual: @""]){
            if (self.dialogOrderInfo.status) {
                if (self.dialogOrderInfo.status.intValue == 5 || self.dialogOrderInfo.status.intValue == 42 || (self.dialogOrderInfo.status.intValue >= 95 && self.dialogOrderInfo.status.intValue <= 100)) {
                    self.orderStatusLabel.text=@"Top-upSuccess".icanlocalized;
                }else{
                    self.orderStatusLabel.text=[NSString stringWithFormat:@"%@-%d",@"Top-upFailure".icanlocalized,self.dialogOrderInfo.status.intValue];
                }
            }else{
                self.orderStatusBgView.hidden = self.orderStatusLineView.hidden = YES;
            }
        }else{
            if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"SUCCESS"]){
                self.orderStatusLabel.text = @"Top-upSuccess".icanlocalized;
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"FAILED"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"Top-upFailure".icanlocalized];
            }else if ([self.dialogOrderInfo.rechargeStatus isEqualToString:@"PENDING"]){
                self.orderStatusLabel.text = [NSString stringWithFormat:@"%@",@"C2COrderPending".icanlocalized];
            }
        }
    }
    self.timeLabel.text=[GetTime convertDateWithString:self.dialogOrderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.remarkLabel.text=self.dialogOrderInfo.txReference;
    if (self.dialogOrderInfo.payChannelType) {
        self.payTypeLineView.hidden=self.payTypeBgView.hidden=NO;
        self.payTypeDetailLabel.text=self.dialogOrderInfo.payChannelType;
    }else{
        self.payTypeLineView.hidden=self.payTypeBgView.hidden=YES;
    }
    self.accountDetailLab.text = self.dialogOrderInfo.accountNumber;
}
#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking

@end

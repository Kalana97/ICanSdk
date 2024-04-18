//
//  ICanWalletWithdrawStatusViewController.m
//  ICan
//
//  Created by dzl on 14/6/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ICanWalletWithdrawStatusViewController.h"
#import "UIViewController+Extension.h"
@interface ICanWalletWithdrawStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab1;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab2;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab3;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab4;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab5;
@property (weak, nonatomic) IBOutlet UILabel *TransferLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLabTop;
@property (weak, nonatomic) IBOutlet UILabel *amountDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *netLab;
@property (weak, nonatomic) IBOutlet UILabel *netDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *feeDetailLab;
@end

@implementation ICanWalletWithdrawStatusViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanWalletWithdrawViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    "TheWithdrawalApplicationHasBeenSubmitted"="提现申请已提交";
//    "TheWithdrawalApplicationHasBeenSubmittedSuccessfully"="提现申请已提交成功";
//    "SystemProcessing"="系统处理中";
//    "WithdrawalIsExpectedToArriveWithin30Minutes"="提现预计在30分钟内到达";
//    "WithdrawalCompleted"="提现完成";
    
    self.tipsLab.text = @"TheWithdrawalApplicationHasBeenSubmitted".icanlocalized;
    self.tipsLab1.text = @"TheWithdrawalApplicationHasBeenSubmittedSuccessfully".icanlocalized;
    self.tipsLab2.text = [GetTime convertDateWithString:[GetTime getCurrentTimestamp] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.tipsLab3.text = @"SystemProcessing".icanlocalized;
    self.tipsLab4.text = @"WithdrawalIsExpectedToArriveWithin30Minutes".icanlocalized;
    self.tipsLab5.text = @"WithdrawalCompleted".icanlocalized;
    
    self.amountLab.text = @"C2CWithdrawAmount".icanlocalized;
    self.netLab.text = @"C2CWithdrawNetwork".icanlocalized;
    self.addressLab.text = @"WithdrawalAddress".icanlocalized;
    self.feeLab.text = @"C2CWithdrawNetworkFee".icanlocalized;
    self.amountLabTop.textColor = [UIColor colorWithRed:(251/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    self.amountLabTop.text = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%@ %@",self.request.amount.stringValue,self.request.currencyCode]];
    
    [self.amountDetailLab setFont:[UIFont boldSystemFontOfSize:15]];
    self.amountDetailLab.text = [NSString stringWithFormat:@"%@ %@",self.request.amount.stringValue,self.request.currencyCode];
    
    self.netDetailLab.text = self.request.channelCode;
    self.TransferLabel.text = [NSString stringWithFormat:@"%@ %@", @"Withdraw".icanlocalized, self.request.channelCode];
    
    self.addressDetailLab.text = self.request.walletAddress;
    self.feeDetailLab.text = [NSString stringWithFormat:@"%@ %@",[self.mainNetworkInfo.withdrawHandlingFeeMoney calculateByRoundingScale:8].currencyString,self.request.currencyCode];
    
}



@end

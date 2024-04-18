//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 21/2/2022
- File name:  IcanTransferScheduleViewController.m
- Description:
- Function List:
*/
        

#import "IcanTransferScheduleViewController.h"
#import "UIViewController+Extension.h"
@interface IcanTransferScheduleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sendTransferLab;
@property (weak, nonatomic) IBOutlet UILabel *handleLab;
@property (weak, nonatomic) IBOutlet UILabel *successLab;

@property (weak, nonatomic) IBOutlet UILabel *transferAmountLab;


@property (weak, nonatomic) IBOutlet UILabel *transferAccountLab;

@property (weak, nonatomic) IBOutlet UILabel *handleFeeLab;



@end

@implementation IcanTransferScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Transferresult".icanlocalized;
    self.amountLab.text= self.amount;
    self.accountLab.text = self.account;
    self.feeLab.text = self.fee;
    self.sendTransferLab.text = @"Sendtransferapplication".icanlocalized;
    self.successLab.text = @"Accountsuccessfullyreceived".icanlocalized;
    self.transferAmountLab.text = @"Accounttoaccount".icanlocalized;
    self.handleLab.text = @"Processing".icanlocalized;
    self.transferAmountLab.text = @"TransferAmount".icanlocalized;
    self.handleFeeLab.text = @"HandlingFee".icanlocalized;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanTransferBankViewController",@"IcanTransferAlipayViewController",@"IcanSureTransferViewController"]];
}


@end

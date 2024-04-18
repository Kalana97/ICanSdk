//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferBankViewController.m
- Description:
- Function List:
*/
        

#import "IcanSureTransferViewController.h"
#import "IcanSureTransferViewController.h"
#import "PayManager.h"
#import "UIViewController+Extension.h"
#import "IcanTransferScheduleViewController.h"
@interface IcanSureTransferViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *handfeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *remarkTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic, strong) UserBalanceInfo *banlanceInfo;
@property(nonatomic, strong) PayManager *payManager;

@end

@implementation IcanSureTransferViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanTransferBankViewController",@"IcanTransferAlipayViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Confirmtransferinformation".icanlocalized;
    if ([_bank isEqualToString:@"Alipay"]) {
        self.bankIconImgView.image = UIImageMake(@"icon_transfer_Alipay");
        self.bankCardLab.text = [NSString stringWithFormat:@"%@(%@)",@"mine.listView.cell.alipay".icanlocalized,self.account];
    }else if ([_bank isEqualToString:@"Bank"]) {
        [self.bankIconImgView setImageWithString:self.logo placeholder:@"icon_transfer_bank"];
        self.bankCardLab.text = [NSString stringWithFormat:@"%@(%@)",self.bankName,self.account.encryptBankCardNum];
    }else if ([_bank isEqualToString:@"Huione"]) {
        [self.bankIconImgView setImageWithString:self.logo placeholder:@"icon_transfer_huione"];
        self.bankCardLab.text = [NSString stringWithFormat:@"%@(%@)",self.bankName,self.account.encryptBankCardNum];
    }else if ([_bank isEqualToString:@"ABA"]) {
        [self.bankIconImgView setImageWithString:self.logo placeholder:@"icon_transfer_aba"];
        self.bankCardLab.text = [NSString stringWithFormat:@"%@(%@)",self.bankName,self.account.encryptBankCardNum];
    }
    self.nameLab.text =self.username;
    self.amountLab.text = [NSString stringWithFormat:@"￥%.2f",self.amount.floatValue];
    @weakify(self);
    self.payManager = [[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        @strongify(self);
        self.banlanceInfo = balance;
        
    }];
    self.remarkLabel.text = @"Remark".icanlocalized;
    self.remarkTextField.placeholder = @"Optional".icanlocalized;
    self.handfeeLabel.text = self.availableBalance;
    self.tipsLabel.text = @"Themoneywillbetransferred".icanlocalized;
    [self.sureBtn setTitle:@"Confirmtransfer".icanlocalized forState:UIControlStateNormal];

}
- (IBAction)sureAction {
    if (self.bindingId) {
        [self.payManager showWithdrawWithAmount:self.amount successBlock:^(NSString * _Nonnull password) {
            [self fetchWithdrawsRequest:password];
        }];
    }else{
        BindingAccountRequestV2 *request = [BindingAccountRequestV2 request];
        if ([_bank isEqualToString:@"Alipay"]) {
            request.bankType = @(1);
        }else if ([_bank isEqualToString:@"Bank"]) {
            request.bankType = @(2);
        }else if ([_bank isEqualToString:@"Huione"]) {
            request.bankType = @(3);
        }else if ([_bank isEqualToString:@"ABA"]) {
            request.bankType = @(4);
        }
        request.account = self.account;
        request.bankTypeId = self.bankTypeId;
        request.username = self.username;
        request.parameters = [request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BindingBackInfo class] contentClass:[BindingBackInfo class] success:^(BindingBackInfo *response) {
            self.bindingId = response.bindId;
            [self.payManager showWithdrawWithAmount:self.amount successBlock:^(NSString * _Nonnull password) {
                [self fetchWithdrawsRequest:password];
            }];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }
}

- (void)fetchWithdrawsRequest:(NSString*)password {
    WithdrawsRequest *request = [WithdrawsRequest request];
    if ([_bank isEqualToString:@"Alipay"]) {
        request.type = @(1);
    }else if ([_bank isEqualToString:@"Bank"]) {
        request.type = @(2);
    }else if ([_bank isEqualToString:@"Huione"]) {
        request.type = @(3);
    }else if ([_bank isEqualToString:@"ABA"]) {
        request.type = @(4);
    }
    request.bindId = @(self.bindingId.integerValue);
    request.amount = [NSDecimalNumber decimalNumberWithString:self.amount];
    request.password = password;
    if (self.remarkTextField.text.length > 0) {
        request.remark = self.remarkTextField.text;
    }
    request.parameters = [request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        BOOL statusValue = jsonDictionary[@"isHeldByOrganization"];
        if(statusValue){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            IcanTransferScheduleViewController *vc = [[IcanTransferScheduleViewController alloc]init];
            vc.amount = [NSString stringWithFormat:@"￥%.2f",self.amount.floatValue];
            if ([self.bank isEqualToString:@"Alipay"]) {
                vc.account = [NSString stringWithFormat:@"%@(%@)",@"mine.listView.cell.alipay".icanlocalized,self.account];
            }else{
                vc.account = [NSString stringWithFormat:@"%@(%@)",self.bankName,self.account.encryptBankCardNum];
            }
            vc.fee = [NSString stringWithFormat:@"%.@%%",[[self.banlanceInfo.withdrawRate decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:self.amount]]calculateByNSRoundDownScale:2].currencyString];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self sureAction];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self sureAction];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
}
@end

//
//  WithdrawViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/8.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "WithdrawViewController.h"
#import "AlipayListViewController.h"
#import "BankCardListViewController.h"
#import "WithdrawRecordListViewController.h"
#import "PayManager.h"

@interface WithdrawViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *withdrawBankcardLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawApliyLab;

@property(nonatomic, weak) IBOutlet UIView *bgView;
//到账方
@property(nonatomic, weak) IBOutlet UILabel *withdrawTipsLabel;
//到账账号
@property(nonatomic, weak) IBOutlet UILabel *withdrawAccoutLabel;


@property(nonatomic, weak) IBOutlet QMUITextField *textField;


@property(nonatomic, weak) IBOutlet UILabel *banlanceLabel;
/** 全部提现 */
@property(nonatomic, weak) IBOutlet UIButton *allButton;
/** 提示label 预计两小时到账 */
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
/** 确认提现 */
@property(nonatomic, weak) IBOutlet UIButton *sureButton;

//提现到银行卡下面的那条蓝色线
@property(nonatomic,weak) IBOutlet UIView * bottomBlueLineBankView;
//提现到支付宝下面的那条蓝色线
@property(nonatomic,weak) IBOutlet UIView * bottomBlueLineAliPayView;

@property(nonatomic, strong) NSArray<BindingBankCardListInfo*> *bindingBankListItems;
@property(nonatomic, strong) NSArray<BindingAliPayListInfo*> *alipayInfoItems;
@property(nonatomic, assign) BOOL isAlipay;
@property(nonatomic, strong) BindingAliPayListInfo *selectAliPayListInfo;
@property(nonatomic, strong) BindingBankCardListInfo *selectBankCardListInfo;

@property(nonatomic, strong) UserBalanceInfo *banlanceInfo;
@property(nonatomic, strong) PayManager *payManager;


@end

@implementation WithdrawViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Withdraw", 提现);
    self.view.backgroundColor = UIColorBg243Color;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:NSLocalizedString(@"WithdrawalRecord", 提现记录) target:self action:@selector(rightButtonAction)];
    
    self.withdrawBankcardLabel.text = NSLocalizedString(@"Withdrawal to bank card",提现到银行卡);
    self.withdrawApliyLab.text = NSLocalizedString(@"Cash to Alipay",提现到支付宝);
    [self.sureButton setTitle:NSLocalizedString(@"Confirm withdraw",确认提现) forState:UIControlStateNormal];
    [self.allButton setTitle:NSLocalizedString(@"WithdrawalAll",全部提现) forState:UIControlStateNormal];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.tipsLabel.text = @"transfer within two hours".icanlocalized;
    [self.bgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    
    [self fetchBankCardsListRequest];
    [self fetchBindingAlipayRequest];
    @weakify(self);
    self.payManager = [[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        @strongify(self);
        self.banlanceInfo = balance;
        self.banlanceLabel.text = [NSString stringWithFormat:@"%@ %.2f",NSLocalizedString(@"AvailableBalance",可用余额),self.banlanceInfo.balance.doubleValue];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(BOOL)preferredNavigationBarHidden{
    return NO;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (IBAction)withdrawToBankcardAction {
    self.isAlipay = NO;
    self.bottomBlueLineBankView.hidden = NO;
    self.withdrawBankcardLabel.textColor = UIColorThemeMainTitleColor;
    self.bottomBlueLineAliPayView.hidden = YES;
    self.withdrawApliyLab.textColor = UIColor153Color;
    if (self.selectBankCardListInfo) {
        self.withdrawAccoutLabel.text=[NSString stringWithFormat:@"%@(%@)",self.selectBankCardListInfo.bankName,self.selectBankCardListInfo.cardNo];
    }else{
        self.withdrawAccoutLabel.text=@"";
   }
   
    
}
- (IBAction)withdrawToApliyAction {
    self.isAlipay = YES;
    if (self.selectAliPayListInfo) {
        self. withdrawAccoutLabel.text = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"mine.listView.cell.alipay", 支付宝),self.selectAliPayListInfo.account];
    }else{
        self.withdrawAccoutLabel.text = @"";
   }
    self.bottomBlueLineBankView.hidden = YES;
    self.withdrawBankcardLabel.textColor = UIColor153Color;
    self.bottomBlueLineAliPayView.hidden = NO;
    self.withdrawApliyLab.textColor = UIColorThemeMainTitleColor;
}
- (IBAction)allButtonAction {
    self.textField.text = [NSString stringWithFormat:@"%.2f",self.banlanceInfo.balance.doubleValue];
}
- (IBAction)sureBtnAction {
    NSDecimalNumber * inputNumber = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    if ([inputNumber compare:self.banlanceInfo.balance] == NSOrderedDescending) {
        [QMUITipsTool showErrorWihtMessage:@"Insufficient Balance".icanlocalized inView:self.view];
        return ;
    }else if ([self.textField.text doubleValue]<=0.00){
        return;
    }
    NSString*bindId;
    if (self.isAlipay) {
        bindId =self.selectAliPayListInfo.bindId;
    }else{
        bindId =self.selectBankCardListInfo.bindId;
    }
    if ([bindId intValue]==0) {
        [QMUITipsTool showErrorWihtMessage:@"Select withdrawal account".icanlocalized inView:self.view];
        return;
    }
    
    [self.payManager showPayViewWithAmount:self.textField.text typeTitleStr:@"Withdraw".icanlocalized SurePaymentViewType:SurePaymentView_Withdraw successBlock:^(NSString * _Nonnull password) {
         [self fetchWithdrawsRequest:password];
    }];
}
-(void)setSelectBankCardListInfo:(BindingBankCardListInfo *)selectBankCardListInfo{
    _selectBankCardListInfo=selectBankCardListInfo;
    if (selectBankCardListInfo) {
        if (!self.isAlipay) {
            self.withdrawAccoutLabel.text=[NSString stringWithFormat:@"%@(%@)",selectBankCardListInfo.bankName,selectBankCardListInfo.cardNo];
        }else{
            self.withdrawAccoutLabel.text=@"";
       }
    }
}
-(void)setSelectAliPayListInfo:(BindingAliPayListInfo *)selectAliPayListInfo{
    _selectAliPayListInfo=selectAliPayListInfo;
    if (selectAliPayListInfo) {
        if (self.isAlipay) {
            self.withdrawAccoutLabel.text=[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"mine.listView.cell.alipay", 支付宝),selectAliPayListInfo.account];
        }else{
            self.withdrawAccoutLabel.text=@"";
       }
         
    }
    
}
//选择账号
- (IBAction)selectAccountAction {
    
    if (self.isAlipay) {
        AlipayListViewController*vc=[AlipayListViewController new];
        @weakify(self);
        vc.isFromWithdraw=YES;
        vc.selectAlipyBlock = ^(BindingAliPayListInfo * _Nonnull info) {
            @strongify(self);
            self.selectAliPayListInfo=info;
        };
        [[AppDelegate shared]pushViewController:vc animated:YES];
    }else{
        BankCardListViewController*vc=[BankCardListViewController new];
        vc.isFromWithdraw=YES;
        @weakify(self);
        vc.selectBankcardBlock = ^(BindingBankCardListInfo * _Nonnull info) {
            @strongify(self);
            self.selectBankCardListInfo=info;
        };
        [[AppDelegate shared]pushViewController:vc animated:YES];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length >= 1) { // 删除数据, 都允许删除
        return YES;
    }
    NSString * toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [NSString checkTwoDecimalPlaces:toString];

}

-(void)rightButtonAction{
    [self.navigationController pushViewController:[WithdrawRecordListViewController new] animated:YES];
}

-(void)fetchWithdrawsRequest:(NSString*)password{
    WithdrawsRequest * request = [WithdrawsRequest request];
    if (self.isAlipay) {
        request.type=@(1);
        request.bindId =@(self.selectAliPayListInfo.bindId.integerValue);
    }else{
        request.type=@(0);
        request.bindId = @(self.selectBankCardListInfo.bindId.integerValue);
    }
    NSDecimalNumberHandler *handler =[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode: NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self.textField.text];
    NSDecimalNumber*number=[number1 decimalNumberByRoundingAccordingToBehavior:handler];
    request.amount= [NSString stringWithFormat:@"%.2f",number.doubleValue];
    request.password =password;
    request.parameters = [request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSNumber *statusValue = jsonDictionary[@"isHeldByOrganization"];
        bool intValue = [statusValue integerValue];
        if(intValue){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
        }else{
            [QMUITipsTool showSuccessWithMessage:@"The withdrawal application has been submitted".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                !self.successBlock?:self.successBlock();
            });
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self sureBtnAction];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self sureBtnAction];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
    
}

-(void)fetchBankCardsListRequest{
    BindingBankCardListRequest*request=[BindingBankCardListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingBankCardListInfo class] success:^(NSArray* response) {
        self.bindingBankListItems =response;
        self.selectBankCardListInfo=response.firstObject;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)fetchBindingAlipayRequest{
    BindingAliPayListRequest*request=[BindingAliPayListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingAliPayListInfo class] success:^(NSArray* response) {
        self.alipayInfoItems=response;
        self.selectAliPayListInfo=response.firstObject;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}



@end

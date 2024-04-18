//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/12/2019
 - File name:  PayManager.m
 - Description:
 - Function List:
 */


#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "RechargeViewController.h"
#import "EmailBindingViewController.h"
@interface PayManager()
@property (nonatomic,copy)    NSString * typeTitleStr;
@property (nonatomic,copy)    NSDecimalNumber * amount;
@property (nonatomic, strong) NSArray *rechargeChannelItems;
@property (nonatomic, strong) NSArray<C2CBalanceListInfo*> *currencyBalanceItems;
@property (nonatomic,copy)    void (^successBlcok)(NSString*password);
@property (nonatomic, strong) UserBalanceInfo *userBalanceInfo;
@property (nonatomic, assign) SurePaymentViewType surePaymentViewType;
@end
@implementation PayManager
-(instancetype)initWithShowViewController:(UIViewController *)showViewController fetchBalanceSuccessBlock:(void (^)(UserBalanceInfo*balance))successBlock{
    if (self=[super init]) {
        self.showViewController=showViewController;
        [self fetchUserBalanceRequest:successBlock];
    }
    return self;
}
-(instancetype)initWithExhangeViewCurrencyShowViewController:(UIViewController *)showViewController successBlock:(void (^)(NSArray*balance))successBlock{
    if (self=[super init]) {
        self.showViewController=showViewController;
        [self getCurrencyRequestSuccessBlock:successBlock];
    }
    return self;
}
+(instancetype)sharedManager{
    static PayManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PayManager alloc]init];
    });
    return manager;
}
/** 获取资产列表 */
-(void)getCurrencyRequestSuccessBlock:(void (^)(NSArray*balance))successBlock{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        self.currencyBalanceItems = response;
        C2CUserManager.shared.c2cBalanceListItems = response;
        if (successBlock) {
            successBlock(response);
        }
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        
    }];
    
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

-(void)showWalletTransfer:(NSString*)balance amount:(NSString*)amount isCalled:(BOOL)isCalled successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].tradePswdSet) {
            self.surePaymentView.typeStr = @"C2CTransfer".icanlocalized;
            self.surePaymentView.surePaymentViewType = SurePaymentView_Normal;
            if(isCalled == YES){
                NSString *amountVal =[self getAmountConvert:amount];
                self.surePaymentView.moneyLabel.text = [NSString stringWithFormat:@"₮%@",amountVal];
                NSString *balanceString = [self getAmountConvert:balance];
                self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@"₮%@",balanceString];;
                self.surePaymentView.payWayIconImageView.image = UIImageMake(@"icon_usdt");
            }else{
                self.surePaymentView.moneyLabel.text = [NSString stringWithFormat:@"￥%@",amount];
                self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@" ￥%@",balance];;
            }
            [self.surePaymentView showSurePaymentView];
            @weakify(self);
            self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                !successBlock?:successBlock(password);
                
            };
            self.surePaymentView.cancleButtonBlock = ^{
                @strongify(self);
                !self.cancelBlock?:self.cancelBlock();
                [self.surePaymentView hiddenSurePaymentView];
            };
            
            
        }else{
            [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                if (index==0) {
                    if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                        EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                        if (self.showViewController) {
                            [self.showViewController.navigationController pushViewController:vc animated:YES];
                        }else{
                            [[AppDelegate shared]pushViewController:vc animated:YES];
                        }
                    }else{
                        SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                        if (self.showViewController) {
                            [self.showViewController.navigationController pushViewController:vc animated:YES];
                        }else{
                            [[AppDelegate shared]pushViewController:vc animated:YES];
                        }
                    }

                }
            }];
            
        }
    }else{
        [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
    }
}
///实际需要支付的对应货币的金额

-(void)showC2CPrepareOrderWithCurrencyInfo:(CurrencyInfo*)currencyInfo c2cBalanceListInfo:(C2CBalanceListInfo*)c2cBalanceListInfo actualPay:(NSDecimalNumber*)actualPay  successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.typeStr = @"Thirdpartypayment".icanlocalized;
                self.surePaymentView.surePaymentViewType = SurePaymentView_Normal;
                //IcanChat
                if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                    if ([c2cBalanceListInfo.code isEqualToString:@"CNY"]) {
                        self.surePaymentView.moneyLabel.text= [NSString stringWithFormat:@"￥ %@",[actualPay calculateByRoundingScale:2].currencyString];
                        self.surePaymentView.payWayIconImageView.image = UIImageMake(@"wallet_payView_balance");
                        self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@"%@(￥%@)",@"IcanBalance".icanlocalized,[c2cBalanceListInfo.money calculateByRoundingScale:8].currencyString];
                    }else{
                        self.surePaymentView.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",currencyInfo.symbol?:currencyInfo.code,[actualPay calculateByRoundingScale:8].currencyString];
                        self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@"%@ %@",currencyInfo.symbol?:currencyInfo.code,[c2cBalanceListInfo.money calculateByRoundingScale:8].currencyString];
                    }
                }
                //IcanMeta
                if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                    if ([c2cBalanceListInfo.code isEqualToString:@"CNT"]) {
                        self.surePaymentView.moneyLabel.text = [NSString stringWithFormat:@"￥ %@",[actualPay calculateByRoundingScale:2].currencyString];
                        self.surePaymentView.payWayIconImageView.image = UIImageMake(@"wallet_payView_balance");
                        self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@"%@(￥%@)",@"IcanBalance".icanlocalized,[c2cBalanceListInfo.money calculateByRoundingScale:8].currencyString];
                    }else{
                        self.surePaymentView.moneyLabel.text= [NSString stringWithFormat:@"%@ %@",currencyInfo.symbol?:currencyInfo.code,[actualPay calculateByRoundingScale:8].currencyString];
                        self.surePaymentView.payWayLabel.text = [NSString stringWithFormat:@"%@ %@",currencyInfo.symbol?:currencyInfo.code,[c2cBalanceListInfo.money calculateByRoundingScale:8].currencyString];
                    }
                }
                
                [self.surePaymentView showSurePaymentView];
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    if ([c2cBalanceListInfo.money compare:actualPay]==NSOrderedAscending) {
                        [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:nil];
                    }else{
                        !successBlock?:successBlock(password);
                    }
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
                
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}
-(void)showC2CInputPasswordWith:(NSString*)amount  typeStr:(NSString*)typeStr currencyInfo:(CurrencyInfo*)currencyInfo  successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.typeStr = typeStr;
                self.surePaymentView.surePaymentViewType = SurePaymentView_Normal;
                self.surePaymentView.moneyLabel.text= [NSString stringWithFormat:@"%@ %@",currencyInfo.symbol?:currencyInfo.code,[[NSDecimalNumber decimalNumberWithString:amount]calculateByRoundingScale:8].currencyString];
                [self.surePaymentView.payWayIconImageView setImageWithString:currencyInfo.icon placeholder:@"icon_c2c_currency_default"];
                ///当前的余额
                C2CBalanceListInfo *currentInfo;
                for (C2CBalanceListInfo*info in C2CUserManager.shared.c2cBalanceListItems) {
                    if ([info.code isEqualToString:currencyInfo.code]) {
                        currentInfo = info;
                        if (currencyInfo.symbol) {
                            self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(%@%@)",info.code,currencyInfo.symbol,[info.money calculateByRoundingScale:8].currencyString];
                        }else{
                            self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(%@)",info.code,[info.money calculateByRoundingScale:8].currencyString];
                        }
                        
                        break;
                    }
                }
                if (!currentInfo) {
                    self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(%@)",currencyInfo.code,@"0.00"];
                }
                [self.surePaymentView showSurePaymentView];
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    if(currentInfo != nil){
                        if ([currentInfo.money compare:[NSDecimalNumber decimalNumberWithString:amount]] == NSOrderedAscending) {
                            [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:nil];
                        }else{
                            !successBlock?:successBlock(password);
                        }
                    }else{
                        [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:nil];
                    }
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
                
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}
-(void)showExhangeViewCurrencyExchangeInfo:(CurrencyExchangeInfo*)exchangeInfo amount:(NSDecimalNumber*)amount successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.typeStr = @"Exchange".icanlocalized;
                self.surePaymentView.surePaymentViewType = SurePaymentView_Normal;
                self.surePaymentView.moneyLabel.text= [NSString stringWithFormat:@"%@ %@",exchangeInfo.fromInfo.symbol,amount];
                C2CBalanceListInfo *currentInfo;
                for (C2CBalanceListInfo*info in self.currencyBalanceItems) {
                    CurrencyInfo*currencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:info.code];
                    if ([info.code isEqualToString:exchangeInfo.fromInfo.code]) {
                        currentInfo = info;
                        self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(%@%@)",info.code,currencyInfo.symbol,info.money.stringValue.currencyString];
                        break;
                    }
                }
                if (!currentInfo) {
                    self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(%@%@)",exchangeInfo.fromCode,exchangeInfo.fromInfo.symbol,@"0.00"];
                }
                [self.surePaymentView showSurePaymentView];
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    !successBlock?:successBlock(password);
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
                
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

-(void)showWithdrawWithAmount:(NSString*)amount successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    self.amount = [NSDecimalNumber decimalNumberWithString:amount];
    self.successBlcok =successBlock;
    self.surePaymentViewType=SurePaymentView_Withdraw;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.titleLabel.text = @"EnterPaymentPassword".icanlocalized;
                self.surePaymentView.typeStr = @"Transfer".icanlocalized;
                self.surePaymentView.surePaymentViewType=self.surePaymentViewType;
                //手续费
                NSDecimalNumber *serviceCharge = [self.userBalanceInfo.withdrawRate decimalNumberByMultiplyingBy:self.amount];
                ///最小手续费
                NSDecimalNumber * minServiceCharge = [NSDecimalNumber decimalNumberWithString:@"0.10"];
                if ([serviceCharge compare:minServiceCharge] == NSOrderedAscending) {
                    serviceCharge = minServiceCharge;
                }
                
                self.surePaymentView.amount = self.amount.stringValue;
                self.surePaymentView.handfeeLabel.text=[NSString stringWithFormat:@"￥%.2f",serviceCharge.doubleValue];
                self.surePaymentView.withdrawRateLabel.text=[NSString stringWithFormat:@"%.2f%%",[self.userBalanceInfo.withdrawRate doubleValue]*100];
                [self.surePaymentView showSurePaymentView];
                
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    @strongify(self);
                    !self.successBlcok?:self.successBlcok(password);
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

-(void)showPayViewWithAmount:(NSString*)amount  typeTitleStr:(NSString*)typeTitleStr SurePaymentViewType:(SurePaymentViewType)surePaymentViewType successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    self.typeTitleStr=typeTitleStr;
    self.amount = [NSDecimalNumber decimalNumberWithString:amount];
    self.successBlcok =successBlock;
    self.surePaymentViewType=surePaymentViewType;
    [self showWithdrawPayView];
    
}
/// 显示密码输入框
/// @param amount 价格
/// @param typeTitleStr 支付的类型
/// @param successBlock 密码回调
-(void)payShowPayViewWithAmount:(NSString*)amount showViewController:(UIViewController *)showViewController typeTitleStr:(NSString*)typeTitleStr SurePaymentViewType:(SurePaymentViewType)surePaymentViewType successBlock:(void (^)(NSString*password))successBlock cancelBlock:(void (^)(void))cancelBlock{
    self.surePaymentView=nil;
    self.typeTitleStr=typeTitleStr;
    self.amount = [NSDecimalNumber decimalNumberWithString:amount];
    self.successBlcok =successBlock;
    self.cancelBlock=cancelBlock;
    self.surePaymentViewType=surePaymentViewType;
    UserBalanceRequest*request=[UserBalanceRequest request];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.showViewController.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [QMUITips hideAllTips];
        self.userBalanceInfo=response;
        [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
        [self showWithdrawPayView];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
    
}
-(void)fetchUserBalanceRequest:(void (^)(UserBalanceInfo*balance))successBlock{
    if ([UserInfoManager sharedManager].loginStatus) {
        UserBalanceRequest*request=[UserBalanceRequest request];
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.showViewController.view isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
            [QMUITips hideAllTips];
            self.userBalanceInfo=response;
            [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
            successBlock(response);
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
    
}

/// 显示提现
-(void)showWithdrawPayView{
    self.surePaymentView=nil;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.typeStr=self.typeTitleStr;
                self.surePaymentView.surePaymentViewType=self.surePaymentViewType;
                if (self.surePaymentViewType==SurePaymentView_Withdraw) {
                    //手续费
                    NSDecimalNumber *serviceCharge = [self.userBalanceInfo.withdrawRate decimalNumberByMultiplyingBy:self.amount];
                    NSDecimalNumber * minServiceCharge = [NSDecimalNumber decimalNumberWithString:@"0.10"];
                    NSDecimalNumber * showNumber = self.amount;
                    if ([serviceCharge compare:minServiceCharge] == NSOrderedAscending) {
                        serviceCharge = minServiceCharge;
                    }
                    if ([[self.amount decimalNumberByAdding:serviceCharge]compare:self.userBalanceInfo.balance]==NSOrderedAscending) {
                        showNumber = [self.amount decimalNumberBySubtracting:serviceCharge];
                    }
                    
                    self.surePaymentView.amount = showNumber.stringValue;
                    self.surePaymentView.handfeeLabel.text=[NSString stringWithFormat:@"￥%.2f",serviceCharge.doubleValue];
                    self.surePaymentView.withdrawRateLabel.text=[NSString stringWithFormat:@"%.2f%%",[self.userBalanceInfo.withdrawRate doubleValue]*100];
                    [self.surePaymentView showSurePaymentView];
                }else{
                    if (self.surePaymentViewType==SurePaymentView_UtilityPay) {
                        self.surePaymentView.moneyLabel.text=[NSString stringWithFormat:@"￥ %.2f",self.amount.doubleValue];
                    }else{
                        self.surePaymentView.amount=[NSString stringWithFormat:@"%.2f",self.amount.doubleValue];
                    }
                    self.surePaymentView.payWayLabel.text=[NSString stringWithFormat:@"%@(￥%.2f)",@"Balance".icanlocalized, self.userBalanceInfo.balance.doubleValue];
                    [self.surePaymentView showSurePaymentView];
                }
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    @strongify(self);
                    !self.successBlcok?:self.successBlcok(password);
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
                
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

-(void)showC2CConfirmReceiptMoney:(NSString*)quantity SuccessBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView=nil;
    self.successBlcok =successBlock;
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.titleLabel.text = @"EnterPaymentPassword".icanlocalized;
                self.surePaymentView.moneyLabel.text = quantity;
                self.surePaymentView.surePaymentViewType = SurePaymentView_c2cConfirmReceiptMoney;
                self.surePaymentView.typeStr = @"ConfirmOrder".icanlocalized;
                [self.surePaymentView showSurePaymentView];
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    @strongify(self);
                    !self.successBlcok?:self.successBlcok(password);
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
                
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

-(SurePaymentView *)surePaymentView{
    if (!_surePaymentView) {
        _surePaymentView=[[NSBundle mainBundle]loadNibNamed:@"SurePaymentView" owner:self options:nil].firstObject;
        _surePaymentView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _surePaymentView;
}

-(void)checkPaymentPassword:(NSString*)amount successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView = nil;
    self.successBlcok = successBlock;
    
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.titleLabel.text = @"EnterPaymentPassword".icanlocalized;
                self.surePaymentView.typeLabel.hidden = YES;
                self.surePaymentView.handfeeLabel.hidden = YES;
                self.surePaymentView.withdrawRateLabel.hidden = YES;
                self.surePaymentView.moneyLabel.hidden = YES;
                self.surePaymentView.balanceBgView.hidden = YES;
                
                [self.surePaymentView showSurePaymentView];
                
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    @strongify(self);
                    !self.successBlcok?:self.successBlcok(password);
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

-(void)checkPaymentPasswordWithOther:(NSString*)title needSub:(NSString*)needSub successBlock:(void (^)(NSString*password))successBlock{
    self.surePaymentView = nil;
    self.successBlcok = successBlock;
    
    if ([UserInfoManager sharedManager].loginStatus) {
        if ([UserInfoManager sharedManager].openPay) {
            if ([UserInfoManager sharedManager].tradePswdSet) {
                self.surePaymentView.titleLabel.text = title;
                self.surePaymentView.typeLabel.text = needSub;
                self.surePaymentView.typeLabel.hidden = NO;
                self.surePaymentView.handfeeLabel.hidden = YES;
                self.surePaymentView.withdrawRateLabel.hidden = YES;
                self.surePaymentView.moneyLabel.hidden = YES;
                self.surePaymentView.balanceBgView.hidden = YES;
                
                [self.surePaymentView showSurePaymentView];
                
                @weakify(self);
                self.surePaymentView.payViewPasswordBlock = ^(NSString * _Nonnull password) {
                    @strongify(self);
                    !self.successBlcok?:self.successBlcok(password);
                    
                };
                self.surePaymentView.cancleButtonBlock = ^{
                    @strongify(self);
                    !self.cancelBlock?:self.cancelBlock();
                    [self.surePaymentView hiddenSurePaymentView];
                };
                
            }else{
                [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
                    if (index==0) {
                        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            if (self.showViewController) {
                                [self.showViewController.navigationController pushViewController:vc animated:YES];
                            }else{
                                [[AppDelegate shared]pushViewController:vc animated:YES];
                            }
                        }
                    }
                }];
            }
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Payment function is temporarily disabled", 支付功能暂时未开通) inView:nil];
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}
@end

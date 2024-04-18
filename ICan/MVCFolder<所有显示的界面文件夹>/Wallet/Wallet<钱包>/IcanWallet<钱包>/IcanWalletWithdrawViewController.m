//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 12/1/2022
 - File name:  IcanWalletWithdrawViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletWithdrawViewController.h"
#import "DZUITextField.h"
#import "IcanWalletSelectAddressView.h"
#import "IcanWalletSelecMainNetworkView.h"
#import "SelectNetworkTypeSecond.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "QRCodeController.h"
#import "IcanWalletAddNewAddressViewController.h"
#import "UIViewController+Extension.h"
#import "PayManager.h"
#import "DecimalKeyboard.h"
#import "ICanWalletWithdrawStatusViewController.h"
@interface IcanWalletWithdrawViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *bgStackView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *addressLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *addressTextField;

@property(nonatomic, weak) IBOutlet UILabel *networkLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *networkTextField;
@property (weak, nonatomic) IBOutlet UIControl *mainNetworkBgCon;

@property(nonatomic, weak) IBOutlet UILabel *withdrawLabel;
@property(nonatomic, weak) IBOutlet DZUITextField *withdrawTextField;
@property(nonatomic, weak) IBOutlet UILabel *withdrawCodeLabel;

@property(nonatomic, weak) IBOutlet UIButton *allBtn;
@property(nonatomic, weak) IBOutlet UILabel *canUseBalanceLabel;

@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsDetailLabel;

///到账数量
@property(nonatomic, weak) IBOutlet UILabel *toAmountTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *toAmountLabel;
@property(nonatomic, weak) IBOutlet UILabel *toAmountCodeLabel;
///手续费
@property(nonatomic, weak) IBOutlet UILabel *handlingFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property(nonatomic, weak) IBOutlet UIButton *withdrawBtn;
@property(nonatomic, strong) IcanWalletSelectAddressView *addressView;
@property(nonatomic, strong) SelectNetworkTypeSecond *mainNetworkView;

@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, strong) C2CBalanceListInfo *currenteBalanceInfo;
@property(nonatomic, copy) NSString *code;
@end

@implementation IcanWalletWithdrawViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanWalletSelectVirtualViewController"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressLabel.text = @"C2CWithdrawAddress".icanlocalized;
    self.addressTextField.placeholder = @"C2CWithdrawPass".icanlocalized;
    self.networkLabel.text = @"C2CWithdrawNetwork".icanlocalized;
    self.networkTextField.placeholder = @"MainNetworkViewTitle".icanlocalized;
    self.withdrawLabel.text = @"C2CWithdrawAmount".icanlocalized;
    self.withdrawTextField.placeholder = @"PleaseEnterAmount".icanlocalized;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.withdrawTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.withdrawTextField.inputView = decimalKeyboard;
    [self.allBtn setTitle:@"C2CWithdrawALl".icanlocalized forState:UIControlStateNormal];
    self.tipsLabel.text = @"C2CWithdrawHint".icanlocalized;
    self.tipsDetailLabel.text = [NSString stringWithFormat:@"%@\n%@",@"C2CWithdrawHint1".icanlocalized,@"C2CWithdrawHint2".icanlocalized];
    self.toAmountTitleLabel.text = @"C2CWithdrawAmounttoAccount".icanlocalized;
    [self.withdrawBtn setTitle:@"Withdraw".icanlocalized forState:UIControlStateNormal];
    if (self.balanceInfo) {
        self.currencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:self.balanceInfo.code];
        if (!self.currencyInfo) {
            self.currencyInfo = [[CurrencyInfo alloc]init];
            self.currencyInfo.code = self.balanceInfo.code;
        }
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",@"Withdraw".icanlocalized,self.currencyInfo.code];
    
    ///当前的虚拟资产
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"code == %@",self.currencyInfo.code];
    NSArray *array = [C2CUserManager.shared.c2cBalanceListItems filteredArrayUsingPredicate:gpredicate];
    self.currenteBalanceInfo = array.firstObject;
    if (self.currenteBalanceInfo) {
        self.canUseBalanceLabel.text = [NSString stringWithFormat:@"%@:%@%@",@"AvailableBalance".icanlocalized,[self.currenteBalanceInfo.money calculateByNSRoundDownScale:8].currencyString,self.currencyInfo.code];
    }else{
        self.canUseBalanceLabel.text = [NSString stringWithFormat:@"%@:0.00%@",@"AvailableBalance".icanlocalized,self.currencyInfo.code];
    }
    self.handlingFeeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"C2CWithdrawNetworkFee".icanlocalized,@"0.00",self.currencyInfo.code];
    self.toAmountCodeLabel.text = self.currencyInfo.code;
    self.toAmountLabel.text = @"0.00";
    self.withdrawCodeLabel.text = self.currencyInfo.code;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.withdrawTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled.text.length>0) {
            NSDecimalNumber * withdrawMoneyDecima = [NSDecimalNumber decimalNumberWithString:textFiled.text];
            if (self.mainNetworkInfo) {
                self.toAmountLabel.text = [[withdrawMoneyDecima decimalNumberBySubtracting:self.mainNetworkInfo.withdrawHandlingFeeMoney] calculateByNSRoundDownScale:8].currencyString;
            }else{
                self.toAmountLabel.text = [withdrawMoneyDecima  calculateByNSRoundDownScale:8].currencyString;
            }
            
        }else{
            self.toAmountLabel.text = @"0.00";
        }
        
    }];
    [self getMainNetworkViewRequest];
    [self getAllAddressRequest];
    ///为了防止c2c用户信息没有获取成功
    [C2CUserManager.shared getC2CCurrentUser:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(IBAction)qrCodeAction{
    QRCodeController *friendsVC = [[QRCodeController alloc]init];
    friendsVC.fromICanWallet = YES;
    friendsVC.scanResultBlock = ^(NSString *result, BOOL isSucceed) {
        
        self.addressTextField.text = result;
    };
    [self.navigationController pushViewController:friendsVC animated:YES];
}

- (IBAction)dropDownNetworks:(id)sender {
    [self.view endEditing:YES];
    [self.mainNetworkView showView];
}

-(IBAction)selectAddressAction{
    [self.view endEditing:YES];
    [self.addressView showView];
}
-(IBAction)selectMainNetworkAction{
    [self.view endEditing:YES];
    [self.mainNetworkView showView];
}
-(IBAction)allBtnAction{
    [self setShowUI:self.currenteBalanceInfo.money];
}
-(void)setShowUI:(NSDecimalNumber*)withdrawMoney{
    if (withdrawMoney.floatValue>0) {
        if (self.mainNetworkInfo) {
            self.toAmountLabel.text = [[withdrawMoney decimalNumberBySubtracting:self.mainNetworkInfo.withdrawHandlingFeeMoney] calculateByNSRoundDownScale:8].currencyString;
        }else{
            self.toAmountLabel.text = [withdrawMoney calculateByNSRoundDownScale:8].currencyString;
        }
        
        self.withdrawTextField.text = [withdrawMoney calculateByNSRoundDownScale:8].currencyString;
    }else{
        self.withdrawTextField.text = @"0.00";
        self.toAmountLabel.text = @"0.00";
    }
}

- (IBAction)editingDidBeginWithdrawTextField:(id)sender {
    if([self.withdrawTextField.text  isEqual: @"0.00"]) {
        self.withdrawTextField.text = @"";
    }
}


-(IBAction)withdrawAction{
    ///如果存在地址并且已经选择了主网
    if (self.mainNetworkInfo&&self.addressTextField.text.length>0) {
        ///判断地址的长度
        if (self.mainNetworkInfo.walletAddressLength!=0) {
            if (self.addressTextField.text.length!=self.mainNetworkInfo.walletAddressLength) {
                [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@ %@ %ld",self.mainNetworkInfo.channelName,@"lengthof".icanlocalized,self.mainNetworkInfo.walletAddressLength] inView:self.view];
                return;
            }
        }
        if (self.mainNetworkInfo.walletAddressBegin) {
            ///判断地址是否以什么开头
            if (![self.addressTextField.text hasPrefix:self.mainNetworkInfo.walletAddressBegin]) {
                [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@ %@%@",self.mainNetworkInfo.channelName,self.mainNetworkInfo.walletAddressBegin,@"Beginning".icanlocalized] inView:self.view];
                return;
            }
        }
        ///不能提现到自己的地址
        for (ExternalWalletsInfo*walletInfo in C2CUserManager.shared.userInfo.externalWallets) {
            if ([walletInfo.walletAddress isEqualToString:self.addressTextField.text]) {
                [QMUITipsTool showErrorWihtMessage:@"CannotPromptThisAccount".icanlocalized inView:self.view];
                return;
            }
        }
    }else{
        //        "PleaseEnterTheWithdrawalAddress"="请输入提现地址";
        //        "PleaseSelecATransferNetwork"="请选择转账网络";
        if (self.addressTextField.text.length<=0) {
            [QMUITipsTool showOnlyTextWithMessage:@"PleaseEnterTheWithdrawalAddress".icanlocalized inView:self.view];
            return;
        }
        if (!self.mainNetworkInfo) {
            [QMUITipsTool showOnlyTextWithMessage:@"PleaseSelecATransferNetwork".icanlocalized inView:self.view];
            return;
        }
    }
    
    NSString * money   = self.withdrawTextField.text;
    ///当前的提现金额
    NSDecimalNumber *withdrawMoneyDecima = [NSDecimalNumber decimalNumberWithString:money];
    NSDecimalNumber * withdrawMax = self.mainNetworkInfo.withdrawMax;
    NSDecimalNumber * withdrawMin = self.mainNetworkInfo.withdrawMin;
    NSDecimalNumber * withdrawHandlingFeeMoney = self.mainNetworkInfo.withdrawHandlingFeeMoney;
    if (self.currenteBalanceInfo&&self.currenteBalanceInfo.money.floatValue>0) {
        ///提现金额需要大于手续费
        if ([withdrawMoneyDecima compare:withdrawHandlingFeeMoney]==NSOrderedDescending) {
            if ([withdrawMoneyDecima compare:withdrawMax]==NSOrderedAscending&&[withdrawMoneyDecima compare:withdrawMin]==NSOrderedDescending) {
                if ([withdrawMoneyDecima compare:self.currenteBalanceInfo.money]==NSOrderedDescending) {
                    [QMUITipsTool showOnlyTextWithMessage:@"NotEnoughBalance".icanlocalized inView:self.view];
                }else{
                    if (money.length>0) {
                        self.toAmountLabel.text = [[withdrawMoneyDecima decimalNumberBySubtracting:withdrawHandlingFeeMoney] calculateByNSRoundDownScale:8].currencyString;
                    }else{
                        self.toAmountLabel.text = @"0.00";
                    }
                }
            }else{
                ///提现金额在什么之间
                if (BaseSettingManager.isChinaLanguages) {
                    [QMUITipsTool showOnlyTextWithMessage:[NSString stringWithFormat:@"提现金额需要在%@-%@范围内",[withdrawMin calculateByNSRoundDownScale:8].currencyString,[withdrawMax calculateByNSRoundDownScale:8].currencyString] inView:self.view];
                }else{
                    [QMUITipsTool showOnlyTextWithMessage:[NSString stringWithFormat:@"Withdrawal amount must be within the range of %@-%@",[withdrawMin calculateByNSRoundDownScale:8].currencyString,[withdrawMax calculateByNSRoundDownScale:8].currencyString] inView:self.view];
                    
                }
                
            }
        }else{
            ///提现金额需要大于手续费
            [QMUITipsTool showOnlyTextWithMessage:@"TheWithdrawalAmount".icanlocalized inView:self.view];
        }
        
    }else{
        return;
    }
    [[PayManager sharedManager]showC2CInputPasswordWith:self.withdrawTextField.text typeStr:@"Withdraw".icanlocalized currencyInfo:self.currencyInfo successBlock:^(NSString * _Nonnull password) {
        IcanWalletWithdrawRequest * request = [IcanWalletWithdrawRequest request];
        request.amount = [NSDecimalNumber decimalNumberWithString:self.withdrawTextField.text];
        request.channelCode = self.mainNetworkInfo.channelCode;
        request.currencyCode = self.currencyInfo.code;
        request.walletAddress = self.addressTextField.text;
        request.payPassword = password;
        request.parameters = [request mj_JSONObject];
        [QMUITipsTool showLoadingWihtMessage:@"Withdrawal".icanlocalized inView:nil isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
            NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSNumber *statusValue = jsonDictionary[@"status"];
            NSInteger intValue = [statusValue integerValue];
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            if(intValue == 3 || intValue == 2){
                [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Successful withdrawal".icanlocalized inView:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:KC2CBalanceChangeNotification object:nil];
                ICanWalletWithdrawStatusViewController * vc = [ICanWalletWithdrawStatusViewController new];
                vc.request = request;
                vc.mainNetworkInfo = self.mainNetworkInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            if ([info.code isEqual:@"pay.password.error"]) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self withdrawAction];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self withdrawAction];
                } else {
                    [UserInfoManager sharedManager].attemptCount = nil;
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }
            } else {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }
        }];
    }];
    
}
-(IcanWalletSelectAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelectAddressView" owner:self options:nil].firstObject;
        _addressView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        @weakify(self);
        _addressView.selectBlock = ^(ICanWalletAddressInfo * _Nonnull info) {
            @strongify(self);
            
            self.addressTextField.text = info.address;
            for (ICanWalletMainNetworkInfo*mainInfo in self.mainNetworkItems) {
                if ([mainInfo.channelCode isEqualToString:info.channelCode]) {
                    self.mainNetworkInfo = mainInfo;
                    self.networkTextField.text = self.mainNetworkInfo.channelName;
                    self.handlingFeeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"C2CWithdrawNetworkFee".icanlocalized,[mainInfo.withdrawHandlingFeeMoney calculateByRoundingScale:8].currencyString,self.currencyInfo.code];
                    [self setShowUI:[NSDecimalNumber decimalNumberWithString:self.withdrawTextField.text]];
                    break;
                }
            }
        };
        _addressView.addAddressBlock = ^{
            @strongify(self);
            IcanWalletAddNewAddressViewController * vc = [[IcanWalletAddNewAddressViewController alloc]init];
            vc.selectCurrencyInfo = self.currencyInfo;
            vc.mainNetworkItems = self.mainNetworkItems;
            vc.addSuccessBlock = ^{
                [self getAllAddressRequest];
            };
            [[AppDelegate shared]pushViewController:vc animated:YES];
        };
    }
    return _addressView;
}
-(SelectNetworkTypeSecond *)mainNetworkView{
    if (!_mainNetworkView) {
        _mainNetworkView = [[NSBundle mainBundle]loadNibNamed:@"SelectNetworkTypeSecond" owner:self options:nil].firstObject;
        _mainNetworkView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _mainNetworkView.selectBlock = ^(ICanWalletMainNetworkInfo * _Nonnull info) {
            @strongify(self);
            self.mainNetworkInfo = info;
            self.networkTextField.text = info.channelName;
            self.handlingFeeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"C2CWithdrawNetworkFee".icanlocalized,[info.withdrawHandlingFeeMoney calculateByRoundingScale:8].currencyString,self.currencyInfo.code];
            [self setShowUI:[NSDecimalNumber decimalNumberWithString:self.withdrawTextField.text]];
        };
        
    }
    return _mainNetworkView;
}

-(void)getMainNetworkViewRequest{
    GetC2CMainNetworkByCurrencyRequest*request = [GetC2CMainNetworkByCurrencyRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/channel/byCurrency/%@",self.currencyInfo.code];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ICanWalletMainNetworkInfo class] success:^(NSArray* response) {
        self.mainNetworkItems = response;
        self.mainNetworkView.mainNetworkItems = response;
        
        self.mainNetworkInfo = self.mainNetworkItems.firstObject;
        self.networkTextField.text = self.mainNetworkItems.firstObject.channelName;
        self.handlingFeeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"C2CWithdrawNetworkFee".icanlocalized,[self.mainNetworkItems.firstObject.withdrawHandlingFeeMoney calculateByRoundingScale:8].currencyString,self.currencyInfo.code];
        [self setShowUI:[NSDecimalNumber decimalNumberWithString:self.withdrawTextField.text]];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getAllAddressRequest{
    GetAllIcanWalletAddressRequest * request = [GetAllIcanWalletAddressRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ICanWalletAddressInfo class] success:^(NSArray*  response) {
        ///当前的虚拟资产
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"currencyCode == %@",self.currencyInfo.code];
        NSArray *array = [response filteredArrayUsingPredicate:gpredicate];
        self.addressView.addressItems = array;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end

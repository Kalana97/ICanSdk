//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/12/2021
- File name:  C2CTransferViewController.m
- Description:
- Function List:
*/
        

#import "C2CTransferViewController.h"
#import "DZUITextField.h"
#import "PayManager.h"
#import "DecimalKeyboard.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Foundation/Foundation.h>

@interface C2CTransferViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *fromTipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAccountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *toTipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAccountLabel;

@property (weak, nonatomic) IBOutlet DZUITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *allBtn;
///可用资产
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLbl2;

@property (weak, nonatomic) IBOutlet UILabel *currencyLbl1;
@property (nonatomic, strong) UserBalanceInfo *userBalanceInfo;
@property (nonatomic, strong) C2CBalanceListInfo *cnyBanlanceInfo;

@end

@implementation C2CTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C2CTransfer".icanlocalized;
    [self fetchUserBalance];
    [self getCurrencyRequest];
    if (self.isCapitalToWallet) {
        self.fromTipsImageView.image = UIImageMake(@"icon_c2c_transsfer_asset");
        self.fromAccountLabel.text = @"FundAccount".icanlocalized;
        self.toTipsImageView.image = UIImageMake(@"icon_c2c_transfer_wallet");
        self.toAccountLabel.text = @"SpotAccount".icanlocalized;
        
    }else{
        self.toTipsImageView.image = UIImageMake(@"icon_c2c_transsfer_asset");
        self.toAccountLabel.text = @"FundAccount".icanlocalized;
        self.fromTipsImageView.image = UIImageMake(@"icon_c2c_transfer_wallet");
        self.fromAccountLabel.text = @"SpotAccount".icanlocalized;
        
    }
    [self.sureBtn setTitle:@"Confirmtransfer".icanlocalized forState:UIControlStateNormal];
    self.sureBtn.enabled = NO;
    RAC(self.sureBtn,enabled)=[RACSignal combineLatest:@[
        self.amountTextField.rac_textSignal]reduce:^(NSString*other) {
        if (self.isCapitalToWallet) {
            double inputNumber = [self.amountTextField.text doubleValue];
            return @(self.userBalanceInfo.balance.doubleValue >= inputNumber && self.amountTextField.text.doubleValue>0);
        }
        return @((self.cnyBanlanceInfo.money.doubleValue >= self.amountTextField.text.doubleValue) && self.amountTextField.text.doubleValue>0);
        
    }];
    [RACObserve(self, self.sureBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureBtn.backgroundColor = UIColorMakeHEXCOLOR(0X256AD2);
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = UICOLOR_RGB_Alpha(0X1D81F5, 0.5);
        }
    }];
    self.fromLabel.text = @"From".icanlocalized;
    self.toLabel.text = @"To".icanlocalized;
    self.allBtn.text = @"C2CtransferAll".icanlocalized;
    self.amountTextField.placeholder = @"Aminimumof0.01".icanlocalized;
    self.amountTitleLab.text = @"C2COptionalSaleViewControllerCountTitleLabel".icanlocalized;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.currencyLbl1.text = @"CNY";
        self.currencyLbl1.text = @"CNY";
    }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.currencyLbl1.text = @"CNT";
        self.currencyLbl1.text = @"CNT";
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (IBAction)sureAction {
    WalletTransferRequest * request = [WalletTransferRequest request];
    NSString * money = self.amountTextField.text;
    NSString * balance ;
    if (self.isCapitalToWallet) {
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            request.code = @"CNY";
         }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            request.code = @"CNT";
        }
        NSString *stringValue = [self.userBalanceInfo.balance stringValue];
        balance = [NSString stringWithFormat:@"%@",stringValue];
        request.money = [NSDecimalNumber decimalNumberWithString:money];
        request.toC2C = YES;
    }else{
        NSString *stringValue = [self.cnyBanlanceInfo.money stringValue];
        balance = [NSString stringWithFormat:@"%@",stringValue];
        request.money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",money]];
        request.toC2C = NO;
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            request.code = @"CNY";
         }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            request.code = @"CNT";
        }
    }
    [[[PayManager alloc]init]showWalletTransfer:balance amount:money isCalled:NO successBlock:^(NSString * _Nonnull password) {
        request.payPassword = password;
        request.parameters = [request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:KC2CBalanceChangeNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
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
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }
            } else {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }
        }];
    }];
    
}

- (IBAction)allAction {
    if (self.isCapitalToWallet) {
        NSString *stringValue = [self getStringBalance:self.userBalanceInfo.balance];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            NSString *stringValue = [self.userBalanceInfo.balance stringValue];
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
        }
        self.amountTextField.text = [NSString stringWithFormat:@"%@",stringValue];
        if(![stringValue isEqualToString:@"0.00"]) {
            self.sureBtn.enabled = YES;
        }else {
            self.sureBtn.enabled = NO;
        }
    }else {
        NSString *stringValue = [self getStringBalance:self.cnyBanlanceInfo.money];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
        }
        self.amountTextField.text = [NSString stringWithFormat:@"%@",stringValue];
        if(![stringValue isEqualToString:@"0.00"]) {
            self.sureBtn.enabled = YES;
        }else {
            self.sureBtn.enabled = NO;
        }
    }
}

- (NSString*)getStringBalance:(NSDecimalNumber*)number {
    NSString *stringValue = @"0.00";
    NSDecimal decimalNumber = [number decimalValue];
    NSDecimal zero = [[NSDecimalNumber zero] decimalValue];
    NSComparisonResult result = NSDecimalCompare(&decimalNumber, &zero);
    if(result == NSOrderedDescending) {
        stringValue = [number stringValue];
    }
    return stringValue;
}

- (IBAction)changeAction {
    self.isCapitalToWallet =! self.isCapitalToWallet;
    if (self.isCapitalToWallet) {
        NSString *stringValue = [self getStringBalance:self.userBalanceInfo.balance];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
        }
        self.fromTipsImageView.image = UIImageMake(@"icon_c2c_transsfer_asset");
        self.fromAccountLabel.text = @"FundAccount".icanlocalized;
        self.toTipsImageView.image = UIImageMake(@"icon_c2c_transfer_wallet");
        self.toAccountLabel.text = @"SpotAccount".icanlocalized;
    }else{
        NSString *stringValue = [self getStringBalance:self.cnyBanlanceInfo.money];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
        }
        self.toTipsImageView.image = UIImageMake(@"icon_c2c_transsfer_asset");
        self.toAccountLabel.text = @"FundAccount".icanlocalized;
        self.fromTipsImageView.image = UIImageMake(@"icon_c2c_transfer_wallet");
        self.fromAccountLabel.text = @"SpotAccount".icanlocalized;
    }
}

// Get user balance
- (void)fetchUserBalance {
    UserBalanceRequest *request = [UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [UserInfoManager sharedManager].isEmailBinded=response.isEmailBound;
        [UserInfoManager sharedManager].mustBindEmailPayPswd=response.mustBindEmailPayPswd;
        [UserInfoManager sharedManager].tradePswdSet = response.tradePswdSet;
        self.userBalanceInfo = response;
        if (self.isCapitalToWallet) {
            NSString *stringValue = [self getStringBalance:self.userBalanceInfo.balance];
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
             }
            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

// Get asset list
- (void)getCurrencyRequest {
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        __block NSPredicate *gpredicate;
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
             gpredicate = [NSPredicate predicateWithFormat:@"code == %@",@"CNY"];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            gpredicate = [NSPredicate predicateWithFormat:@"code == %@",@"CNT"];
        }
        NSArray *array = [response filteredArrayUsingPredicate:gpredicate];
        self.cnyBanlanceInfo = array.firstObject;
        self.cnyBanlanceInfo.money = [self.cnyBanlanceInfo.money calculateByNSRoundDownScale:8];
        if (!self.isCapitalToWallet) {
            NSString *stringValue = [self getStringBalance:self.cnyBanlanceInfo.money];
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNY",@"AvailableBalance".icanlocalized,stringValue];
             }
            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                self.capitalLabel.text = [NSString stringWithFormat:@"%@￥%@ CNT",@"AvailableBalance".icanlocalized,stringValue];
            }
        }
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        NSLog(@"error");
    }];
}
@end

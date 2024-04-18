//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletTransferInputMoneyViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletTransferInputMoneyViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "DZUITextField.h"
#import "IcanWalletTransferSureUserMessagePopView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "PayManager.h"
#import "DecimalKeyboard.h"
#import "UIViewController+Extension.h"
#import "IcanWalletTransferSuccessViewController.h"
@interface IcanWalletTransferInputMoneyViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak) IBOutlet UILabel *toUserLabel;
@property(nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property(nonatomic, weak) IBOutlet UIImageView *currencyImgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet DZUITextField *amountTextField;
@property (weak, nonatomic) IBOutlet QMUITextView *remarkTextView;
@property(nonatomic, weak) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *realNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addRemarkLbl;
@property (weak, nonatomic) IBOutlet UILabel *transferAmtLbl;
@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property(nonatomic, strong) IcanWalletTransferSureUserMessagePopView *sureUserMessagePopView;
@property(nonatomic, strong) NSString *code;
@end

@implementation IcanWalletTransferInputMoneyViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.amountTextField.floatLenth = 8;
    [self removeVcWithArray:@[@"IcanWalletTransferInputUserTableViewController"]];
}
-(void)setBalanceLabelText{
    ///当前的余额
    C2CBalanceListInfo*currentBalanceInfo;
    for (C2CBalanceListInfo*info in C2CUserManager.shared.c2cBalanceListItems) {
        if ([info.code isEqualToString:self.selectCurrencyInfo.code]) {
            currentBalanceInfo = info;
            self.balanceInfo = currentBalanceInfo;
            break;
        }
    }
    if (!currentBalanceInfo) {
        self.balanceInfo = [[C2CBalanceListInfo alloc]init];
        self.balanceInfo.money = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
    if([self.balanceInfo.code  isEqual: @"USDT"]){
        NSString *amtvalue = [self.balanceInfo.money stringValue];
        self.balanceLab.text = [NSString stringWithFormat:@"%@：%@",@"AvailableBalance".icanlocalized,[self getAmountConvert:amtvalue]];
    }else{
        self.balanceLab.text = [NSString stringWithFormat:@"%@：%@",@"AvailableBalance".icanlocalized,[self.balanceInfo.money calculateByNSRoundDownScale:8].currencyString];
    }
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

-(void)getUserInfoRequestByAccuracyRequest{
    GetUserInfoRequestByAccuracyRequest *request = [GetUserInfoRequestByAccuracyRequest request];
    request.numberId = self.numberId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        if (response) {
            NSString *firstName = response.firstName;
            if(firstName != nil && ![firstName  isEqual: @""]){
                for (int i = firstName.length / 2; i < firstName.length ; i++) {
                    if (![[firstName substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                        NSRange range = NSMakeRange(i, 1);
                        firstName = [firstName stringByReplacingCharactersInRange:range withString:@"*"];
                    }
                }
                self.nicknameLabel.text = [NSString stringWithFormat:@"%@",response.nickname];
                self.realNameLbl.text = [NSString stringWithFormat:@"(%@)",firstName];
                [self.avatarImg setDZIconImageViewWithUrl:response.headImgUrl gender:response.gender];
            }else{
                self.nicknameLabel.text = [NSString stringWithFormat:@"%@",response.nickname];
                [self.avatarImg setDZIconImageViewWithUrl:response.headImgUrl gender:response.gender];
                self.realNameLbl.hidden = YES;
            }
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"userdoesnotexist".icanlocalized inView:self.view];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    "C2CAddRemark"="添加备注";
    //    "C2CReceiveUser"="收款用户：";
    self.title = @"C2CWalletTransfer".icanlocalized;
    self.transferAmtLbl.text = @"TransferAmount".icanlocalized;
    self.roundView.layer.cornerRadius = self.roundView.frame.size.height/2;
    self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.height/2;
    self.remarkTextView.placeholder = @"Pleaseenterremarks".icanlocalized;
    if (self.balanceInfo) {
        self.selectCurrencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:self.balanceInfo.code];
        if (!self.selectCurrencyInfo) {
            self.selectCurrencyInfo  = [[CurrencyInfo alloc]init];
            self.selectCurrencyInfo.code = self.balanceInfo.code;
        }
    }else{
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"VirtualCurrency"];
        self.selectCurrencyInfo =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate][3];
    }
    [self setBalanceLabelText];
    [self getUserInfoRequestByAccuracyRequest];
    self.currencyLabel.text = self.selectCurrencyInfo.code;
    [self.currencyImgView setImageWithString:self.selectCurrencyInfo.icon placeholder:@"icon_c2c_currency_default"];
    self.toUserLabel.text = [NSString stringWithFormat:@"iCan ID : %@",self.numberId];
    self.addRemarkLbl.text = @"C2CAddRemark".icanlocalized;
    [self.sureBtn setTitle:@"C2CContinue".icanlocalized forState:UIControlStateNormal];
    self.amountTextField.placeholder = @"PleaseEnterAmount".icanlocalized;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    [RACObserve(self, self.sureBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureBtn.backgroundColor=UIColorThemeMainColor;
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = UICOLOR_RGB_Alpha(0X1D81F5, 0.5);
        }
    }];
    self.sureBtn.enabled = NO;
    RAC(self.sureBtn,enabled)=[RACSignal combineLatest:@[
        self.amountTextField.rac_textSignal]reduce:^(NSString *address) {
        
        return @(address.floatValue>0);
    }];
}

-(IBAction)selectCurrencyAction{
    IcanWalletSelectVirtualViewController * vc = [[IcanWalletSelectVirtualViewController alloc]init];
    vc.type = IcanWalletSelectVirtualTypeAddNewAddress;
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        self.selectCurrencyInfo = info;
        self.currencyLabel.text = info.code;
        [self.currencyImgView setImageWithString:info.icon placeholder:nil];
        [self setBalanceLabelText];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IcanWalletTransferSureUserMessagePopView *)sureUserMessagePopView{
    if (!_sureUserMessagePopView) {
        _sureUserMessagePopView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletTransferSureUserMessagePopView" owner:self options:nil].firstObject;
        _sureUserMessagePopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _sureUserMessagePopView.sureBlock = ^{
            @strongify(self);
            [self transferRequest];
        };
    }
    return _sureUserMessagePopView;
}

-(IBAction)sureAction{
    [self.view endEditing:YES];
    self.sureUserMessagePopView.receiveIdLabel.text = self.numberId;
    self.sureUserMessagePopView.nicknameLabel.text = self.nickname;
    NSString * amount = [[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByNSRoundDownScale:8].currencyString;
    self.sureUserMessagePopView.currencyDetailLabel.text = [NSString stringWithFormat:@"%@ %@",amount,self.selectCurrencyInfo.code];
    NSMutableAttributedString * amountAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",amount,self.selectCurrencyInfo.code]];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(amountAtt.length-self.selectCurrencyInfo.code.length, self.selectCurrencyInfo.code.length)];
    self.sureUserMessagePopView.amountLabel.attributedText = amountAtt;
    [self.sureUserMessagePopView showView];
}

-(void)transferRequest{
    NSString*typeStr ;
    if (BaseSettingManager.isChinaLanguages) {
        typeStr = [NSString stringWithFormat:@"向（%@）转账",self.nickname];
    }else{
        typeStr = [NSString stringWithFormat:@"Transfer to（%@）",self.nickname];
    }
    [[PayManager sharedManager]showC2CInputPasswordWith:self.amountTextField.text typeStr:typeStr currencyInfo:self.selectCurrencyInfo successBlock:^(NSString * _Nonnull password) {
        C2CTransferRequest * request = [C2CTransferRequest request];
        request.amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
        request.currencyCode = self.selectCurrencyInfo.code;
        request.payPassword = password;
        request.toUserId = self.userId;
        if(![self.remarkTextView.text isEqualToString:@""]){
            request.remark = self.remarkTextView.text;
        }
        request.parameters  = [request mj_JSONObject];
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
                [QMUITipsTool showOnlyTextWithMessage:@"Successfultransfer".icanlocalized inView:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:KC2CBalanceChangeNotification object:nil];
                IcanWalletTransferSuccessViewController * vc = [[IcanWalletTransferSuccessViewController alloc]init];
                vc.toIdLabText = self.numberId;
                vc.toNicknameText = self.nickname;
                vc.amountLabelText = [NSString stringWithFormat:@"%@ %@",[[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByNSRoundDownScale:8].currencyString,self.selectCurrencyInfo.code];
                vc.currencyDetailLabText = [NSString stringWithFormat:@"%@ %@",[[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByNSRoundDownScale:8].currencyString,self.selectCurrencyInfo.code];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            if ([info.code isEqual:@"pay.password.error"]) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self transferRequest];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self transferRequest];
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
@end

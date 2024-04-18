//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletTransferInputMoneyViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletPayQrCodeInputMoneyViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "DZUITextField.h"
#import "IcanWalletTransferSureUserMessagePopView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "PayManager.h"
#import "UIViewController+Extension.h"
#import "IcanWalletTransferSuccessViewController.h"
@interface IcanWalletPayQrCodeInputMoneyViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak) IBOutlet UILabel *toUserLabel;
@property(nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property(nonatomic, weak) IBOutlet UIImageView *currencyImgView;

@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet DZUITextField *amountTextField;

@property(nonatomic, weak) IBOutlet UIButton *addRemarkBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeightContraint;

@property (weak, nonatomic) IBOutlet UIView *remarkBgView;
@property (weak, nonatomic) IBOutlet QMUITextView *remarkTextView;
@property(nonatomic, weak) IBOutlet UIButton *sureBtn;

@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property(nonatomic, strong) IcanWalletTransferSureUserMessagePopView *sureUserMessagePopView;
@property(nonatomic, strong) C2CQRCodeReceiveCodeInfo *codeInfo;
@property(nonatomic, strong) C2CUserInfo *c2cUserInfo;
@end

@implementation IcanWalletPayQrCodeInputMoneyViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanWalletTransferInputUserTableViewController",@"QRCodeController"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Transfer".icanlocalized;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"VirtualCurrency"];
    self.selectCurrencyInfo =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate].firstObject;
    self.currencyLabel.text = self.selectCurrencyInfo.code;
    [self.currencyImgView setImageWithString:self.selectCurrencyInfo.icon placeholder:nil];
    self.remarkTextView.placeholder = @"Pleaseenterremarks".icanlocalized;
    [RACObserve(self, self.sureBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureBtn.backgroundColor=UIColorThemeMainColor;
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.sureBtn.enabled = NO;
    RAC(self.sureBtn,enabled)=[RACSignal combineLatest:@[
        self.amountTextField.rac_textSignal]reduce:^(NSString *address) {
        
        return @(address.floatValue>0);
    }];
    [self getUserMessageRequest];
    [self getQrcodeReceiveMessageRequest];
}
-(IBAction)selectCurrencyAction{
    if (!self.codeInfo.currencyCode) {
        IcanWalletSelectVirtualViewController * vc = [[IcanWalletSelectVirtualViewController alloc]init];
        vc.type = IcanWalletSelectVirtualTypeAddNewAddress;
        vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
            self.selectCurrencyInfo = info;
            self.currencyLabel.text = info.code;
            [self.currencyImgView setImageWithString:info.icon placeholder:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
-(IBAction)addRemarkAction{
    self.addRemarkBtn.hidden = YES;
    self.remarkBgView.hidden = NO;
}
-(IBAction)sureAction{
    [self.view endEditing:YES];
    self.sureUserMessagePopView.receiveIdLabel.text = self.c2cUserInfo.numberId;
    self.sureUserMessagePopView.nicknameLabel.text = self.c2cUserInfo.nickname;
    NSString * amount = [[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByRoundingScale:8].currencyString;
    self.sureUserMessagePopView.currencyDetailLabel.text = [NSString stringWithFormat:@"%@ %@",amount,self.selectCurrencyInfo.code];
    NSMutableAttributedString * amountAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",amount,self.selectCurrencyInfo.code]];
    [amountAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(amountAtt.length-self.selectCurrencyInfo.code.length, self.selectCurrencyInfo.code.length)];
    self.sureUserMessagePopView.amountLabel.attributedText = amountAtt;
    [self.sureUserMessagePopView showView];
    
    
}
-(void)getQrcodeReceiveMessageRequest{
    GetQRCodeReceiveMessageRequest * request = [GetQRCodeReceiveMessageRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/qrcodeReceive/%@",self.code];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CQRCodeReceiveCodeInfo class] contentClass:[C2CQRCodeReceiveCodeInfo class] success:^(C2CQRCodeReceiveCodeInfo* response) {
        self.codeInfo = response;
        if (response.currencyCode) {
            self.amountTextField.enabled = NO;
            self.selectCurrencyInfo =  [C2CUserManager.shared getCurrecyInfoWithCode:response.currencyCode];
            self.currencyLabel.text = self.selectCurrencyInfo.code;
            [self.currencyImgView setImageWithString:self.selectCurrencyInfo.icon placeholder:nil];
            self.amountTextField.text = [response.amount calculateByRoundingScale:8].currencyString;
            self.sureBtn.enabled = YES;
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getUserMessageRequest{
    C2CGetUserInfoRequest * request = [C2CGetUserInfoRequest request];
    request.pathUrlString =  [request.baseUrlString stringByAppendingFormat:@"/api/user/%@",self.userId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        self.c2cUserInfo = response;
        self.toUserLabel.text = [NSString stringWithFormat:@"收款用户：%@",response.numberId];
        self.nicknameLabel.text = response.nickname;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)transferRequest{
    NSString*typeStr ;
    if (BaseSettingManager.isChinaLanguages) {
        typeStr = [NSString stringWithFormat:@"向（%@）转账",self.c2cUserInfo.nickname];
    }else{
        typeStr = [NSString stringWithFormat:@"Transfer to（%@）",self.c2cUserInfo.nickname];
    }
    [[PayManager sharedManager]showC2CInputPasswordWith:self.amountTextField.text typeStr:typeStr currencyInfo:self.selectCurrencyInfo successBlock:^(NSString * _Nonnull password) {
        [self.view endEditing:YES];
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        C2CQRCodeReceivePayRequest * request = [C2CQRCodeReceivePayRequest request];
        request.amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
        request.currencyCode = self.selectCurrencyInfo.code;
        request.code = self.code;
        if (self.remarkTextView.text.length>0) {
            request.message = self.remarkTextView.text;
        }
        request.payPassword = password;
        request.parameters  = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            [QMUITipsTool showOnlyTextWithMessage:@"Successfultransfer".icanlocalized inView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:KC2CBalanceChangeNotification object:nil];
            IcanWalletTransferSuccessViewController * vc = [[IcanWalletTransferSuccessViewController alloc]init];
            vc.toIdLabText = self.c2cUserInfo.numberId;
            vc.toNicknameText = self.c2cUserInfo.nickname;
            vc.amountLabelText = [NSString stringWithFormat:@"%@ %@",[[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByRoundingScale:8].currencyString,self.selectCurrencyInfo.code];
            vc.currencyDetailLabText = [NSString stringWithFormat:@"%@ %@",[[NSDecimalNumber decimalNumberWithString:self.amountTextField.text]calculateByRoundingScale:8].currencyString,self.selectCurrencyInfo.code];
            [self.navigationController pushViewController:vc animated:YES];
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

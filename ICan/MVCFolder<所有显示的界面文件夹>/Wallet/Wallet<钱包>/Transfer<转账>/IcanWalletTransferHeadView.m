
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewHeadView.m
- Description:
- Function List:
*/
        

#import "IcanWalletTransferHeadView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"

@interface IcanWalletTransferHeadView ()
@property(nonatomic, weak) IBOutlet UILabel *titleLable;

@property(nonatomic, weak) IBOutlet UIControl *emailBgCon;
@property(nonatomic, weak) IBOutlet UILabel *emailLable;

@property(nonatomic, weak) IBOutlet UIControl *mobileBgCon;
@property(nonatomic, weak) IBOutlet UILabel *mobileLable;

@property(nonatomic, weak) IBOutlet UIControl *idBgCon;
@property(nonatomic, weak) IBOutlet UILabel *idLable;

@property(weak, nonatomic) IBOutlet UIStackView *mobileCodeBgView;
@property(nonatomic, weak) IBOutlet UILabel *mobileCodeLable;
@property(nonatomic, weak) IBOutlet QMUITextField *accountTextField;

@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UIButton *sureBtn;

@property(nonatomic, copy) NSString *mobileCode;
@property(nonatomic, copy) NSString *type;
@end

@implementation IcanWalletTransferHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColor.whiteColor;
    
//    "C2CWalletTransfer"="转账";
//    "C2CWalletReceive"="收款";
//    "C2CEmail"="邮箱";
//    "C2CMobile"="手机号码";
//    "C2CID"="ID";
//    "C2CEmailPlac"="请输入邮箱";
//    "C2CMobilePlac"="请输入手机号码";
//    "C2CIDPlace"="请输入ID";
//    "C2CTransferTips"="转账实时达到，无法退款，请确认对方账号是否正确";
//    "C2CNearyTransfer"="最近转账";
//    "C2CContinue"="继续";
    self.titleLable.text = @"C2CWalletTransfer".icanlocalized;
    self.emailLable.text = @"C2CEmail".icanlocalized;
    self.mobileLable.text = @"C2CMobile".icanlocalized;
    self.idLable.text = @"C2CID".icanlocalized;
    self.tipsLabel.text = @"C2CTransferTips".icanlocalized;
    self.nearyLabel.text = @"C2CNearyTransfer".icanlocalized;
    [self.sureBtn setTitle:@"C2CContinue".icanlocalized forState:UIControlStateNormal];
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMobileCodeAction)];
    [self.mobileCodeLable addGestureRecognizer:tap];
    self.mobileCode = [UserInfoManager sharedManager].areaNum?:@"94";
    self.mobileCodeLable.text=[NSString stringWithFormat:@"+%@",self.mobileCode];
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
        self.accountTextField.rac_textSignal]reduce:^(NSString *account) {
        return @(account.length>0);
    }];
    [self idAction];
}

- (IBAction)emailAction {
    [self dismissKeyboard];
    self.accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailLable.textColor = UIColorWhite;
    self.emailBgCon.backgroundColor = UIColorThemeMainColor;
    self.mobileLable.textColor = UIColor153Color;
    self.mobileBgCon.backgroundColor = UIColorWhite;
    self.idLable.textColor = UIColor153Color;
    self.idBgCon.backgroundColor = UIColorWhite;
    self.mobileCodeBgView.hidden = YES;
    self.type = @"email";
    self.accountTextField.placeholder = @"C2CEmailPlac".icanlocalized;
}

- (IBAction)mobileAction {
    [self dismissKeyboard];
    self.accountTextField.keyboardType = UIKeyboardTypePhonePad;
    self.emailLable.textColor = UIColor153Color;
    self.emailBgCon.backgroundColor = UIColorWhite;
    self.mobileLable.textColor = UIColorWhite;
    self.mobileBgCon.backgroundColor = UIColorThemeMainColor;
    self.idLable.textColor = UIColor153Color;
    self.idBgCon.backgroundColor = UIColorWhite;
    self.mobileCodeBgView.hidden = NO;
    self.type = @"mobile";
    self.accountTextField.placeholder = @"C2CMobilePlac".icanlocalized;
}

- (IBAction)idAction {
    [self dismissKeyboard];
    self.accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.emailLable.textColor = UIColor153Color;
    self.emailBgCon.backgroundColor = UIColorWhite;
    self.mobileLable.textColor = UIColor153Color;
    self.mobileBgCon.backgroundColor = UIColorWhite;
    self.idLable.textColor = UIColorWhite;
    self.idBgCon.backgroundColor = UIColorThemeMainColor;
    self.mobileCodeBgView.hidden = YES;
    self.type = @"id";
    self.accountTextField.placeholder = @"C2CIDPlace".icanlocalized;
}

- (void)dismissKeyboard {
    [self.accountTextField resignFirstResponder];
}

- (IBAction)nextAction {
    !self.sureBlcok?:self.sureBlcok(self.type,self.accountTextField.text,self.mobileCode);
}

- (void)selectMobileCodeAction {
    SelectMobileCodeViewController *vc = [[SelectMobileCodeViewController alloc]init];
    QDNavigationController *nav = [[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AppDelegate shared] presentViewController:nav animated:YES completion:^{
        
    }];
    __weak __typeof(self)weakSelf = self;
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        weakSelf.mobileCode=mobileCode;
        weakSelf.mobileCodeLable.text=[NSString stringWithFormat:@"+%@",mobileCode];
    };
}
@end

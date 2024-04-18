//
/**
 - Copyright © 2020 limao01. All rights reserved.
 - Author: Created  by DZL on 26/11/2020
 - File name:  RegisterViewController.m
 - Description:
 - Function List:
 */


#import "UserBindingMobileOrEmailViewController.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
#import "CheckVersionTool.h"

#import "SettingPasswordViewController.h"
#import "BindingTipsView.h"

@interface UserBindingMobileOrEmailViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headTitle;

@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *emailLoginBtn;
@property (weak, nonatomic) IBOutlet UIControl *areacodeCon;
@property (weak, nonatomic) IBOutlet UILabel *mobileCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileCodeJianGeView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UIView *getCodeBgView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;


/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

/**
 协议
 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@property(nonatomic, copy) NSString *mobileCode;
@property(nonatomic, strong) NSDictionary *openDataDict;
@property(nonatomic, strong) BindingTipsView *tipsView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countdown;
@end

@implementation UserBindingMobileOrEmailViewController
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColor.whiteColor;
    self.headTitle.text=@"Bind account".icanlocalized;
    self.mobileTextField.placeholder=@"Please enter the phone number".icanlocalized;
    [self.emailLoginBtn setTitle:@"Switch to Email" forState:UIControlStateNormal];
    [self.emailLoginBtn setTitle:@"Switch to Phone" forState:UIControlStateSelected];
    
    [self.emailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.emailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    
    
    [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    self.codeTextField.placeholder=@"Enter the verification code".icanlocalized;
    [self.registerBtn setTitle:@"UIAlertController.sure.title".icanlocalized forState:UIControlStateNormal];
    [self.registerBtn layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    [self.mobileBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    
    [self.getCodeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.codeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.selectBtn setBackgroundImage:UIImageMake(@"wallet_recharge_way_select") forState:UIControlStateSelected];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_selectperson_nor") forState:UIControlStateNormal];
    
    [self.emailLoginBtn setTitle:@"Binding Email".icanlocalized forState:UIControlStateNormal];
    [self.emailLoginBtn setTitle:@"Binding phone".icanlocalized forState:UIControlStateSelected];
    self.mobileCode = UserInfoManager.sharedManager.areaNum?:@"94";
    self.tipsLabel.text = @"Please bind mobile phone/email".icanlocalized;
    
    }
- (IBAction)endEditing {
    [self.view endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UserInfoManager sharedManager].mobile||[UserInfoManager sharedManager].email) {
            [self judgeUserHaveSetLoginPassword];
        }
       
    });
}
- (IBAction)emailBtnAction {
    self.mobileTextField.text=@"";
    self.emailLoginBtn.selected=!self.emailLoginBtn.selected;
    if (self.emailLoginBtn.selected) {
        self.mobileTextField.placeholder=@"Please Enter Your Email Account".icanlocalized;
        self.mobileCodeJianGeView.hidden=self.areacodeCon.hidden=YES;
    }else{
        self.mobileTextField.placeholder=@"Please enter the phone number".icanlocalized;
        self.mobileCodeJianGeView.hidden=self.areacodeCon.hidden=NO;
    }
}
- (IBAction)selectAreaCodeAction:(id)sender {
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    __weak __typeof(self)weakSelf = self;
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        weakSelf.mobileCode=mobileCode;
        weakSelf.mobileCodeLabel.text=[NSString stringWithFormat:@"+%@",mobileCode];
    };
}
- (IBAction)registerAction {
    if (self.mobileTextField.text.length<=0) {
        if (self.emailLoginBtn.selected) {
            [QMUITipsTool showOnlyTextWithMessage:@"Please Enter Your Email Account".icanlocalized inView:self.view];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"Please enter the phone number".icanlocalized inView:self.view];
        }
        
        return;
    }else{
        if (self.emailLoginBtn.selected) {
            if (![NSString checkIsEmail:self.mobileTextField.text]) {
                [QMUITipsTool showOnlyTextWithMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
                return;
            }
        }else{
            if (![NSString checkIsPureString:self.mobileTextField.text]) {
                [QMUITipsTool showOnlyTextWithMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
                return;
            }
            
        }
    }
    if (self.codeTextField.text.length<=0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Enter the verification code".icanlocalized inView:self.view];
        return;
    }
    if (self.emailLoginBtn.selected) {
        [self fetchBindEmailRequestWithAcount:self.mobileTextField.text code:self.codeTextField.text];
    }else{
        [self fetchBindMoblieRequestWithAcount:self.mobileTextField.text code:self.codeTextField.text mobileCode:self.mobileCode];
    }
    
}
- (IBAction)getCodeAction:(id)sender {
    if (!self.emailLoginBtn.selected) {
        if (![NSString checkIsPureString:self.mobileTextField.text]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
            return;
        }
    }else{
        if (![NSString checkIsEmail:self.mobileTextField.text]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
            return;
        }
    }
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    
    if ([NSString checkIsEmail:self.mobileTextField.text]) {
        request.username= self.mobileTextField.text;
        
    }else{
        request.username=[NSString stringWithFormat:@"%@ %@",self.mobileCode,self.mobileTextField.text];
    }
    request.type=@(2);
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:@"".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self startCountdown];
        [QMUITipsTool showOnlyTextWithMessage:@"The verification code has been sent, please check it carefully".icanlocalized inView:self.view];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self cancelCountdown];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)startCountdown {
    self.countdown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)cancelCountdown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateCountdown {
    if (self.countdown > 0) {
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2dS", self.countdown] forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        self.countdown--;
    } else {
        [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
        self.getCodeBtn. userInteractionEnabled = YES;
        [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        [self cancelCountdown];
    }
}

-(void)fetchBindEmailRequestWithAcount:(NSString *)acount code:(NSString *)code{
    BindingUserEmailRequest * request = [BindingUserEmailRequest request];
    request.email = acount;
    request.code = code;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"BindingSuccess",绑定成功) inView:self.view];
        [UserInfoManager sharedManager].email = acount;
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindingSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.view endEditing:YES];
        [self judgeUserHaveSetLoginPassword];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}


-(void)fetchBindMoblieRequestWithAcount:(NSString *)acount code:(NSString *)code mobileCode:(NSString*)mobileCode{
    BindingUserMobileRequest * request = [BindingUserMobileRequest request];
    request.mobile = acount;
    request.code = code;
    request.areaNum=mobileCode;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"BindingSuccess",绑定成功) inView:self.view];
        [UserInfoManager sharedManager].mobile = acount;
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindingSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.view endEditing:YES];
        [self judgeUserHaveSetLoginPassword];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)judgeUserHaveSetLoginPassword{
    //没有设置登录密码
    if (!UserInfoManager.sharedManager.isSetPassword) {
        //是不是新用户
        if (UserInfoManager.sharedManager.isNew) {
            self.tipsView=[[NSBundle mainBundle]loadNibNamed:@"BindingTipsView" owner:self options:nil].firstObject;
            self.tipsView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            self.tipsView.tipsLabel.text=@"WarmReminder".icanlocalized;
            self.tipsView.contentLabel.text=@"Your account has not yet set a password, you need to go to improve it before you can continue to use the APP".icanlocalized;
            [self.tipsView.agreeButton setTitle:@"Go to Settings".icanlocalized forState:UIControlStateNormal];
            [self.tipsView.refuseButton setTitle:@"Logout".icanlocalized forState:UIControlStateNormal];
            @weakify(self);
            self.tipsView.agreeBlock = ^{
                @strongify(self);
                SettingPasswordViewController*vc=[[SettingPasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            };
            self.tipsView.logoutBlock = ^{
                ReportUserLogoutRequest*request=[ReportUserLogoutRequest request];
                [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                    [[WebSocketManager sharedManager]userManualLogout];
                    [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    
                }];
            };
            [UIApplication.sharedApplication.keyWindow addSubview:self.tipsView];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)changeToMainView {
    [[BaseSettingManager sharedManager] resetAppToTabbarViewController];
    [[CheckVersionTool sharedManager]getAnnouncementRequest];
}
@end

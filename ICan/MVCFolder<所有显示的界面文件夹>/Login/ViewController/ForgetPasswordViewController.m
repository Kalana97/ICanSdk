//
/**
- Copyright © 2020 limao01. All rights reserved.
- Author: Created  by DZL on 27/11/2020
- File name:  ForgetPasswordViewController.m
- Description:
- Function List:
*/
        

#import "ForgetPasswordViewController.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
@interface ForgetPasswordViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTipLabel;


@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;


@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIControl *areacodeCon;
@property (weak, nonatomic) IBOutlet UILabel *mobileCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileCodeJianGeView;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UIView *getCodeBgView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;

@property(nonatomic, copy) NSString *mobileCode;


@property (weak, nonatomic) IBOutlet UIView *passwordBgView;

@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *againPasswordBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *againPasswordTextField;

@end

@implementation ForgetPasswordViewController
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= UIColorViewBgColor;
    
    [self.nextBtn layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    [self.mobileBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.getCodeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.codeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    
    self.mobileTextField.placeholder=@"Please enter the phone number".icanlocalized;
    self.codeTextField.placeholder=@"Enter the verification code".icanlocalized;
    
    self.title = @"Reset Password".icanlocalized;
    self.headerTipLabel.text=@"Please enter the mobile phone number/email account used when registering".icanlocalized;
    [self.nextBtn setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    
    [self.emailBtn setTitle:@"Email Verification Code".icanlocalized forState:UIControlStateNormal];
    [self.emailBtn setTitle:@"Mobile Verification Code".icanlocalized forState:UIControlStateSelected];
    [self.emailBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.emailBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    
    [self.passwordBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.againPasswordBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
//    "ForgetPasswordViewController.passwordTextField.placeholder"="请输入密码";
//    "ForgetPasswordViewController.againPasswordTextField.placeholder"="请输入确认密码";
    self.passwordTextField.placeholder=@"ForgetPasswordViewController.passwordTextField.placeholder".icanlocalized;
    self.againPasswordTextField.placeholder=@"ForgetPasswordViewController.againPasswordTextField.placeholder".icanlocalized;
    self.mobileCode = [UserInfoManager sharedManager].areaNum?:@"94";
    self.mobileCodeLabel.text = [NSString stringWithFormat:@"+%@",self.mobileCode];
}
- (IBAction)areCodeAction {
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    __weak __typeof(self)weakSelf = self;
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        self.mobileCode = mobileCode;
        weakSelf.mobileCodeLabel.text = [NSString stringWithFormat:@"+%@",mobileCode];
    };
}

- (IBAction)emailBtnAction {
    self.mobileTextField.text=@"";
    self.emailBtn.selected=!self.emailBtn.selected;
    if (self.emailBtn.selected) {
        self.mobileTextField.placeholder=@"Please Enter Your Email Account".icanlocalized;
        self.mobileCodeJianGeView.hidden=self.areacodeCon.hidden=YES;
    }else{
        self.mobileTextField.placeholder=@"Please enter the phone number".icanlocalized;
        self.mobileCodeJianGeView.hidden=self.areacodeCon.hidden=NO;
    }
}
- (IBAction)getCodeBtnAction {
    NSString*accountText=self.mobileTextField.text.remove;
    if (!self.emailBtn.selected) {
        if (accountText.length==0) {
            [QMUITipsTool showErrorWihtMessage:@"ForgetPasswordViewController.accountMobiel.nullTips".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkIsPureString:accountText]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
            return;
        }
    }else{
        if (accountText.length==0) {
            [QMUITipsTool showErrorWihtMessage:@"ForgetPasswordViewController.accountEmail.nullTips".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkIsEmail:accountText]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
            return;
        }
    }
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    if (!self.emailBtn.selected) {
        request.username=[NSString stringWithFormat:@"%@ %@",self.mobileCode,self.mobileTextField.text];
    }else{
        request.username=[NSString stringWithFormat:@"%@",self.mobileTextField.text];
    }
    request.type=@(3);
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Verification code has been sent, please check".icanlocalized inView:nil];
    
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
    [self starTimer];
    
}
- (IBAction)nextBtnAction:(id)sender {
    NSString*accountText=self.mobileTextField.text.remove;
    if (!self.emailBtn.selected) {
//        "ForgetPasswordViewController.accountMobiel.nullTips"="手机号码不能为空";
//        "ForgetPasswordViewController.accountEmail.nullTips"="邮箱账号不能为空";
        if (accountText.length==0) {
            [QMUITipsTool showErrorWihtMessage:@"ForgetPasswordViewController.accountMobiel.nullTips".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkIsPureString:accountText]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
            return;
        }
    }else{
        if (accountText.length==0) {
            [QMUITipsTool showErrorWihtMessage:@"ForgetPasswordViewController.accountEmail.nullTips".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkIsEmail:accountText]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
            return;
        }
    }
    if (self.passwordTextField.text.length<=0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please enter password".icanlocalized inView:self.view];
        return;
    }
    if (![self.againPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        [QMUITipsTool showOnlyTextWithMessage:@"Those password didn't".icanlocalized inView:self.view];
        return;
    }
    if (self.codeTextField.text.length<=0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Enter the verification code".icanlocalized inView:self.view];
        return;
    }
   
    ForgetLoginPasswordRequest * request = [ForgetLoginPasswordRequest request];
    request.username = self.mobileTextField.text;
    request.password = self.passwordTextField.text;
    request.code = self.codeTextField.text;
    if (!self.emailBtn.selected) {
        request.areaNum=self.mobileCode;
    }
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Password has been recovered, please login again".icanlocalized inView:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];

}
-(void)starTimer{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
                self.getCodeBtn. userInteractionEnabled = YES;
                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2dS", seconds] forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}



@end

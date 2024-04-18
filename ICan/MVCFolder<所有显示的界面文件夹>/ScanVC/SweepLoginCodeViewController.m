//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 25/12/2019
 - File name:  SweepLoginCodeViewController.m
 - Description:
 - Function List:
 */


#import "SweepLoginCodeViewController.h"
#import "UIViewController+Extension.h"
@interface SweepLoginCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation SweepLoginCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sureLoginButton setBackgroundColor:UIColorThemeMainColor];
    [self.sureLoginButton layerWithCornerRadius:16 borderWidth:0 borderColor:nil];
    [self.cancelButton setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.closeButton setTitle:@"Close".icanlocalized forState:UIControlStateNormal];
    [self.sureLoginButton setTitle:@"ConfirmLogin".icanlocalized forState:UIControlStateNormal];
    [self.cancelButton layerWithCornerRadius:16 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self.cancelButton setTitle:@"CancelLogin".icanlocalized forState:UIControlStateNormal];
    //    @"桌面端确认登录";
    NSString*string;
    NSString*string1;
    //    "DesktopEndConfirmLogin"="桌面端 确认登录";
    //    "Desktop"="桌面端";
    //    "VIPgroupmanagementbackgroundconfirmlogin"="VIP群管理后台 确认登录";
    //    "VIPgroupmanagementbackground"="VIP群管理后台"
    if (self.isLoginClient) {
        string=@"DesktopEndConfirmLogin".icanlocalized;
        string1=@"Desktop".icanlocalized;
    }else{
        string=@"VIPgroupmanagementbackgroundconfirmlogin".icanlocalized;
        string1=@"VIPgroupmanagementbackground".icanlocalized;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColor252730Color range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(0, string1.length)];
    self.tipsLabel.attributedText=attributedString;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"QRCodeController"]];
}

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.dimssBlock) {
        self.dimssBlock();
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.dimssBlock) {
        self.dimssBlock();
    }
}

- (IBAction)sureLoginButtonAction:(id)sender {
    if (self.isLoginClient) {
        UserWebLoginAgreeRequest*request=[UserWebLoginAgreeRequest request];
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/user/webLogin/agree/%@",self.uuId];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            if (self.dimssBlock) {
                self.dimssBlock();
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else{
        GroupLoginRequest*request=[GroupLoginRequest request];
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/login/%@",self.uuId];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            if (self.dimssBlock) {
                self.dimssBlock();
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
}
@end

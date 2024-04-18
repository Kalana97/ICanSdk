//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletReceiveViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletReceiveViewController.h"
#import "IcanWalletReceiveSettingMoneyViewController.h"
#import "SaveViewManager.h"
@interface IcanWalletReceiveViewController ()
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property(nonatomic, weak) IBOutlet UILabel *tipsLabel2;
@property(nonatomic, weak) IBOutlet UIImageView *qrCodeImgView;

///设置金额之后的view
@property(weak, nonatomic) IBOutlet UIView *settingMoneyBgView;
///设置金额之后的view
@property(weak, nonatomic) IBOutlet UIImageView *currencyImgView;
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property(nonatomic, weak) IBOutlet UILabel *moneyLabel;

@property(nonatomic, weak) IBOutlet UIButton *settingMoneyBtn;
@property(nonatomic, weak) IBOutlet UIButton *saveBtn;

@property(nonatomic, weak) IBOutlet UILabel *myPayIdTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *myPayIdLabel;

@property(nonatomic, strong) CurrencyInfo *currencyInfo;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *code;
@property (weak, nonatomic) IBOutlet UIView *QRViewUI;

@end

@implementation IcanWalletReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.QRViewUI.layer.cornerRadius = 5;
    self.QRViewUI.layer.masksToBounds = TRUE;
//    /q/c2c/receive/{code}/{c2cUserId}/{m}/{unit}     c2c收款码
    self.settingMoneyBgView.hidden = YES;
    self.myPayIdLabel.text = UserInfoManager.sharedManager.numberId;
    if (self.balanceInfo) {
        self.currencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:self.balanceInfo.code];
        if (!self.currencyInfo) {
            self.currencyInfo = [[CurrencyInfo alloc]init];
            self.currencyInfo.code = self.balanceInfo.code;
        }
    }
    [self getQRCodeRequest];
//    "C2CReceiveTips1"="使用二维码收款，您的收款将会进入您的资金钱包";
//    "C2CReceiveTips2"="使用ICanAPP扫码转账";
//    "C2CReceiveClear"="清除金额";
//    "C2CReceiveSettingMoney"="设置金额";
//    "C2CReceiveSave"="保存收款码";
//    "C2CReceiveMyId"="我的支付ID";
    self.titleLabel.text = @"C2CWalletReceive".icanlocalized;
    self.tipsLabel.text = @"C2CReceiveTips1".icanlocalized;
    self.tipsLabel2.text = @"C2CReceiveTips2".icanlocalized;
    [self.settingMoneyBtn setTitle:@"C2CReceiveSettingMoney".icanlocalized forState:UIControlStateNormal];
    [self.saveBtn setTitle:@"C2CReceiveSave".icanlocalized forState:UIControlStateNormal];
    self.myPayIdTitleLabel.text = @"C2CReceiveMyId".icanlocalized;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    //keep these code snippests to future needs
//    if (@available(iOS 15.0, *)) {
//            UINavigationBarAppearance *navBarAppearance = [UINavigationBarAppearance new];
//            navBarAppearance.backgroundColor = UIColor.whiteColor; // 设置导航栏背景色
//            navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor blackColor]};
//            self.navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance;
//            self.navigationController.navigationBar.standardAppearance = navBarAppearance;
//            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    } else {
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_circle_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"C2CWalletReceive".icanlocalized];
    self.navigationItem.titleView = label;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[ UIImage alloc] init] forBarPosition: UIBarPositionAny barMetrics: UIBarMetricsDefault];  // here make the
    [navigationBar setShadowImage:[UIImage imageWithColor:[UIColor redColor]]];
}
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.QRViewUI.layer.cornerRadius = 5;
    self.QRViewUI.layer.masksToBounds = TRUE;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.QRViewUI.layer.cornerRadius = 5;
    self.QRViewUI.layer.masksToBounds = TRUE;
}
-(void)getQRCodeRequest{
    GetC2CQRCodeReceiveRequest * request = [GetC2CQRCodeReceiveRequest request];
    if (self.money) {
        if (self.remark) {
            request.remark = self.remark;
        }
        request.amount = [NSDecimalNumber decimalNumberWithString:self.money];
        request.currencyCode = self.currencyInfo.code;
    }else{
        request.amount = [NSDecimalNumber decimalNumberWithString:@"-1"];
    }
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CQRCodeReceiveCodeInfo class] contentClass:[C2CQRCodeReceiveCodeInfo class] success:^(C2CQRCodeReceiveCodeInfo  * response) {
        self.code = response.code;
        [self settingReceivePaymentCode];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(IBAction)settingAction{
    if (self.money) {
        self.currencyInfo = nil;
        self.money = nil;
        self.remark = nil;
        self.settingMoneyBgView.hidden = YES;
        [self.settingMoneyBtn setTitle:@"C2CReceiveSettingMoney".icanlocalized forState: UIControlStateNormal];
        [self getQRCodeRequest];
    }else{
        IcanWalletReceiveSettingMoneyViewController * vc = [[IcanWalletReceiveSettingMoneyViewController alloc]init];
        vc.balanceInfo = self.balanceInfo;
        vc.sureBlock = ^(CurrencyInfo *  currencyInfo, NSString *  money, NSString *  remark) {
            
            self.settingMoneyBgView.hidden = NO;
            self.currencyInfo = currencyInfo;
            self.money = money;
            self.remark = remark;
            [self.currencyImgView setImageWithString:currencyInfo.icon placeholder:nil];
            self.currencyLabel.text = currencyInfo.code;
            self.moneyLabel.text = [[NSDecimalNumber decimalNumberWithString:money]calculateByNSRoundDownScale:8].currencyString;
            [self.settingMoneyBtn setTitle:@"Clear Amount".icanlocalized forState: UIControlStateNormal];
            [self getQRCodeRequest];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(IBAction)saveAction{
    [SaveViewManager captureImageFromView:self.qrCodeImgView success:^{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
    } failed:^{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
    }];
}
-(IBAction)copyAction{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = UserInfoManager.sharedManager.numberId;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
///q/c2c/receive/{code}/{c2cUserId}/{m}/{unit}     c2c收款码
-(void)settingReceivePaymentCode{
    NSString*qrcode;
    if (self.money) {
        qrcode=[[BaseRequest request].baseUrlString stringByAppendingFormat:@"/q/c2c/receive/%@/%@/%@/%@",self.code,C2CUserManager.shared.userInfo.userId,self.money,self.currencyInfo.code];
    }else{
        qrcode=[[BaseRequest request].baseUrlString stringByAppendingFormat:@"/q/c2c/receive/%@/%@/-1",self.code,C2CUserManager.shared.userInfo.userId];
    }
    UIImage*qrImage=[UIImage dm_QRImageWithString:qrcode size:ScreenWidth-80];
    self.qrCodeImgView.image=qrImage;
    
}
@end

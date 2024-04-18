//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 13/11/2019
 - File name:  BindingViewController.m
 - Description:
 - Function List:
 */


#import "BindingAlipayViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "CommonWebViewController.h"
#import "AddSucessViewController.h"

@interface BindingAlipayViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *textFiledBgView;

@end

@implementation BindingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Add Alipay", 添加支付宝);
    self.tipLabel.text =NSLocalizedString(@"AlipayAccount",支付宝帐号);
    [self.sureButton setTitle: NSLocalizedString(@"Confirm add", 确认添加) forState:UIControlStateNormal];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.tipLabel.textColor=UIColor153Color;
    self.textField.placeholderColor=UIColor153Color;
    self.textField.placeholder=NSLocalizedString(@"Please enter Alipay account number", 请输入支付宝账号);
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textColor = UIColor102Color;
    self.textField.delegate = self;
    self.textFiledBgView.backgroundColor = [UIColor whiteColor];
    self.sureButton.backgroundColor=UIColorThemeMainColor;
    self.view.backgroundColor=UIColorBg243Color;
    NSString*str=NSLocalizedString(@"See protocol", 查看协议);
    NSString*str1=NSLocalizedString(@"WithdrawalAgreement", 提现协议);
    NSString*str2=[NSString stringWithFormat:@"%@%@",str,str1];
    NSRange range1=[str2 rangeOfString:str];
    NSRange range2=[str2 rangeOfString:str1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str2];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12.0f] range:NSMakeRange(0, str2.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:range1];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:range2];
    self.checkLabel.attributedText= attributedString;
    [self.checkLabel yb_addAttributeTapActionWithStrings:@[str1] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        CommonWebViewController*web=[[CommonWebViewController alloc]init];
        NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:@"WithdrawalAgreement".icanlocalized];
        web.title = dict[@"title"];
        web.urlString = dict[@"url"];
        web.modalPresentationStyle=UIModalPresentationFullScreen;
        [self.navigationController pushViewController:web animated:YES];
    }];
    
}
- (IBAction)sureButtonAction:(id)sender {
    if ([NSString checkNumber:self.textField.text] ||[NSString checkIsEmail:self.textField.text]) {
        BindingAliPayRequest*request=[BindingAliPayRequest request];
        request.account=self.textField.text;
        request.parameters=[request mj_JSONString];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [QMUITips hideAllTips];
            !self.bindingSuccessBlock?:self.bindingSuccessBlock();
            AddSucessViewController * vc = [AddSucessViewController new];
            vc.addSucessBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"the Alipay account must be Email or phone number".icanlocalized inView:self.view];
        
    }
    
    
    
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if(![string isEqualToString:blank]) {
        return NO;
    }
    
    return YES;
    
}


@end

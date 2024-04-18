//
//  SetMoneyViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "SetMoneyViewController.h"
#import "DZUITextField.h"
#import "UIViewController+Extension.h"
@interface SetMoneyViewController ()<QMUITextViewDelegate,DZUITextFieldDelegate>
@property(nonatomic, copy) NSString *amount;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet DZUITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic,assign)BOOL isHaveDian;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;
@end

@implementation SetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Set up payment amount".icanlocalized;
    self.tipsLabel.text=@"Received amount".icanlocalized;
    self.textView.placeholder = NSLocalizedString(@"AddNote",添加备注50字以内);
    self.textView.delegate=self;
    [self.sureButton setTitle:@"UIAlertController.sure.title".icanlocalized forState:UIControlStateNormal];
    self.view.backgroundColor = UIColorViewBgColor;
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"QRCodeController"]];
}
- (IBAction)sureButtonAction:(id)sender {
    if (self.isPayment) {
        [self payMoneyRequest];
    }else{
        if (self.settingMoneySuccessBlock) {
            self.settingMoneySuccessBlock(self.moneyTextField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    self.textViewHeight.constant=height;
}


-(void)payMoneyRequest{
    NSString*codeStr=[self.codeStr componentsSeparatedByString:@"payment/"].lastObject;
    PayQRCodePaymentRequest*request=[PayQRCodePaymentRequest request];
    request.code=[codeStr componentsSeparatedByString:@"/"].firstObject;
    request.money=@([self.moneyTextField.text doubleValue]);
    if (self.textView.text.length>0) {
        request.comment=self.textView.text;
    }
    
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Successfully Received".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end


//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/11/2021
- File name:  C2CPublishAdvertFirstStepViewController.m
- Description:
- Function List:
*/
        

#import "C2CPublishAdvertThirdStepViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CPublishAdvertThirdStepViewController ()<UIScrollViewDelegate,QMUITextViewDelegate>
//1/3.设置类型&价格
@property (weak, nonatomic) IBOutlet UILabel *stepTipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgCorView;
//交易条款
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *exchangeProvisionTextView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionTextCountLabel;

//自动回复消息
@property (weak, nonatomic) IBOutlet UILabel *autoSendMessageLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *autoSendMessageTextView;
@property (weak, nonatomic) IBOutlet UILabel *autoSendMessageCountLabel;

//交易用户条件
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *kycButton;
@property (weak, nonatomic) IBOutlet UILabel *kycLabel;

@property (weak, nonatomic) IBOutlet UIButton *conditionSecondButton;
@property (weak, nonatomic) IBOutlet QMUITextField *conditionTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *conditionSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionSecondTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTextFieldWidth;

@property (weak, nonatomic) IBOutlet UIButton *conditionThirdButton;
@property (weak, nonatomic) IBOutlet QMUITextField *conditionAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *conditionThirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionThirdUnitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btcLimitTextFieldWidth;
//立即上线或者是手动上线
@property (weak, nonatomic) IBOutlet UIButton *nowOnLineButton;
@property (weak, nonatomic) IBOutlet UILabel *nowOnLineLabel;

@property (weak, nonatomic) IBOutlet UIButton *laterOnLineButton;
@property (weak, nonatomic) IBOutlet UILabel *laterOnLineLabel;

@property (weak, nonatomic) IBOutlet UIButton *lastStepButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation C2CPublishAdvertThirdStepViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"C2CPublishAdvertFirstStepViewControllerTitle".icanlocalized;
    self.stepTipLabel.text = @"C2CPublishAdvertThirdStepViewControllerStepTipLabel".icanlocalized;
    self.exchangeProvisionLabel.text = @"C2CPublishAdvertThirdStepViewControllerExchangeProvisionLabel".icanlocalized;
    self.exchangeProvisionTextView.placeholder = @"C2CPublishAdvertThirdStepViewControllerExchangeProvisionTextView".icanlocalized;
    self.autoSendMessageLabel.text = @"C2CPublishAdvertThirdStepViewControllerAutoSendMessageLabel".icanlocalized;
    self.autoSendMessageTextView.placeholder = @"C2CPublishAdvertThirdStepViewControllerAutoSendMessageTextView".icanlocalized;
    self.conditionLabel.text = @"C2CPublishAdvertThirdStepViewControllerConditionLabel".icanlocalized;
    self.conditionTitleLabel.text = @"C2CPublishAdvertThirdStepViewControllerConditionTitleLabel".icanlocalized;
    self.kycLabel.text = @"C2CPublishAdvertThirdStepViewControllerKycLabel".icanlocalized;
    self.conditionSecondLabel.text = @"C2CPublishAdvertThirdStepViewControllerConditionSecondLabel".icanlocalized;
    self.conditionSecondTimeLabel.text = @"C2CPublishAdvertThirdStepViewControllerConditionSecondTimeLabel".icanlocalized;
    self.conditionThirdLabel.text = @"C2CPublishAdvertThirdStepViewControllerConditionThirdLabel".icanlocalized;
    self.nowOnLineLabel.text = @"C2CPublishAdvertThirdStepViewControllerNowOnLineLabel".icanlocalized;
    self.laterOnLineLabel.text = @"C2CPublishAdvertThirdStepViewControllerLaterOnLineLabel".icanlocalized;
    [self.nextButton setTitle:@"C2CPublishAdvertThirdStepViewControllerNextButton".icanlocalized forState:UIControlStateNormal];
    [self.lastStepButton setTitle:@"C2CPublishAdvertSecondStepViewControllerlastStepButton".icanlocalized forState:UIControlStateNormal];
    self.exchangeProvisionTextView.text = @"TransactionTermsContent".icanlocalized;
    self.exchangeProvisionTextCountLabel.text = [NSString stringWithFormat:@"%lu/1000",self.exchangeProvisionTextView.text.length];
    self.bgCorView.layer.cornerRadius = 5;
    self.bgCorView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.bgCorView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgCorView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgCorView.layer.shadowRadius = 5;
    
    [self.nextButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.lastStepButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    
    [self.conditionSecondButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_unsel") forState:UIControlStateNormal];
    [self.conditionSecondButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_sel") forState:UIControlStateSelected];
    
    [self.conditionThirdButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_unsel") forState:UIControlStateNormal];
    [self.conditionThirdButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_sel") forState:UIControlStateSelected];
    
    [self.nowOnLineButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_circle_unsel") forState:UIControlStateNormal];
    [self.nowOnLineButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_circle_sel") forState:UIControlStateSelected];
    
    [self.laterOnLineButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_circle_unsel") forState:UIControlStateNormal];
    [self.laterOnLineButton setBackgroundImage:UIImageMake(@"icon_c2c_publish_check_circle_sel") forState:UIControlStateSelected];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.conditionTimeTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.conditionTimeTextField) {
            CGFloat width  = [NSString widthForString:textFiled.text withFontSize:12 height:15];
            if (width<15) {
                width = 15;
            }
            self.timeTextFieldWidth.constant = width+12;

        }

    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.conditionAmountTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.conditionAmountTextField) {
            CGFloat width  = [NSString widthForString:textFiled.text withFontSize:12 height:15];
            if (width<15) {
                width = 15;
            }
            self.btcLimitTextFieldWidth.constant = width+12;
            
        }
        
    }];
    [self nowOnLineAction];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>1000) {
        return;
    }
    if (textView == self.autoSendMessageTextView) {
        self.autoSendMessageCountLabel.text = [NSString stringWithFormat:@"%lu/1000",textView.text.length];
    }else{
        self.exchangeProvisionTextCountLabel.text = [NSString stringWithFormat:@"%lu/1000",textView.text.length];
    }
}
-(IBAction)kycButtonAction{
//    self.kycButton.selected = !self.kycButton.selected;
//    self.kycLabel.textColor = self.kycButton.selected?UIColor252730Color:UIColor153Color;
}
-(IBAction)registerTimeAction{
    self.conditionSecondButton.selected = !self.conditionSecondButton.selected;
    if (self.conditionTimeTextField.text.floatValue == 0.00) {
        self.conditionTimeTextField.text = @"";
    }
    self.conditionSecondLabel.textColor = self.conditionSecondButton.selected?UIColor252730Color:UIColor153Color;
    self.conditionSecondTimeLabel.textColor = self.conditionSecondButton.selected?UIColor252730Color:UIColor153Color;
}
-(IBAction)btcAction{
    if (self.conditionAmountTextField.text.floatValue == 0.00) {
        self.conditionAmountTextField.text = @"";
    }
    self.conditionThirdButton.selected = !self.conditionThirdButton.selected;
    self.conditionThirdLabel.textColor = self.conditionThirdButton.selected?UIColor252730Color:UIColor153Color;
    self.conditionThirdUnitLabel.textColor = self.conditionThirdButton.selected?UIColor252730Color:UIColor153Color;
}
-(IBAction)nowOnLineAction{
    self.nowOnLineButton.selected = YES;
    self.laterOnLineButton.selected = NO;
    self.nowOnLineLabel.textColor = self.nowOnLineButton.selected?UIColor252730Color:UIColor153Color;
    self.laterOnLineLabel.textColor = self.laterOnLineButton.selected?UIColor252730Color:UIColor153Color;
}
-(IBAction)latterOnLinebtcAction{
    
   
    self.nowOnLineButton.selected = NO;
    self.laterOnLineButton.selected = YES;
    self.nowOnLineLabel.textColor = self.nowOnLineButton.selected?UIColor252730Color:UIColor153Color;
    self.laterOnLineLabel.textColor = self.laterOnLineButton.selected?UIColor252730Color:UIColor153Color;
}
-(IBAction)lastStepAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)nextAction{
    NSString * autoMessage = self.autoSendMessageTextView.text.trimmingwhitespaceAndNewline;
    if (autoMessage.length>0) {
        self.publishAdvertRequest.autoMessage = autoMessage;
    }
    NSString * transactionTerms = self.exchangeProvisionTextView.text.trimmingwhitespaceAndNewline;
    if (transactionTerms.length>0) {
        self.publishAdvertRequest.transactionTerms = transactionTerms;
    }
    if (self.nowOnLineButton.selected) {
        self.publishAdvertRequest.available = true;
    }else{
        self.publishAdvertRequest.available = false;
    }
    if (self.conditionSecondButton.selected) {
        self.publishAdvertRequest.registerDay = @(self.conditionTimeTextField.text.integerValue);
    }else{
        self.publishAdvertRequest.registerDay = @(-1);
    }
    if (self.conditionThirdButton.selected) {
        self.publishAdvertRequest.btcLimit = @(self.conditionAmountTextField.text.doubleValue);
    }else{
        self.publishAdvertRequest.btcLimit = @(-1);
    }
   
    self.publishAdvertRequest.parameters = [self.publishAdvertRequest mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:self.publishAdvertRequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [QMUITipsTool showOnlyTextWithMessage:@"SuccessfullyPosted".icanlocalized inView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:kC2CPublishAdverSuccessNotification object:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

@end

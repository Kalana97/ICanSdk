//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/11/2021
- File name:  C2CCancelOrderViewController.m
- Description:
- Function List:
*/
        

#import "C2CCancelOrderViewController.h"
#import "C2COrderDetailViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CCancelOrderViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UILabel *attentionFirstLabel;
@property (nonatomic, weak) IBOutlet UILabel *attentionSecondtipLabel;
@property (nonatomic, weak) IBOutlet UILabel *reasonTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *reasonOneButton;
@property (nonatomic, weak) IBOutlet UILabel *reasonOneLabel;

@property (nonatomic, weak) IBOutlet UIButton *reasonTwoButton;
@property (nonatomic, weak) IBOutlet UILabel *reasonTwoLabel;

@property (nonatomic, weak) IBOutlet UIButton *reasonThreeButton;
@property (nonatomic, weak) IBOutlet UILabel *reasonThreeLabel;

@property (nonatomic, weak) IBOutlet UIButton *reasonFourButton;
@property (nonatomic, weak) IBOutlet UILabel *reasonFourLabel;

@property (nonatomic, weak) IBOutlet UIButton *reasonFiveButton;
@property (nonatomic, weak) IBOutlet UILabel *reasonFiveLabel;

@property (weak, nonatomic) IBOutlet UITextView *otherTextView;
@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@end

@implementation C2CCancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    中文
//    #A1000000001   我不想交易了
//    #A1000000002   我不满足广告交易条款要求
//    #A1000000003   卖家要额外收取费用
//    #A1000000004   卖家收款方式有问题，无法成功打款
//    #A0000000001   超时未支付，系统自动取消
//    英文
//    #A1000000001 I don't want to trade anymore
//    #A1000000002 I do not meet the requirements of the advertising transaction terms
//    #A1000000003 Seller asking for extra fee
//    #A1000000004 There is a problem with the seller's payment method, result in unsuccessful
//    #A0000000001If the payment is not made over time, the system will cancel automaticallypayments.
    self.title = @"C2CCancelOrderViewControllerTitle".icanlocalized;
    self.tipLabel.text = @"C2CCancelOrderViewControllerTipLabel".icanlocalized;
    self.attentionFirstLabel.text = @"C2CCancelOrderViewControllerAttentionFirstLabel".icanlocalized;
    self.attentionSecondtipLabel.text = @"C2CCancelOrderViewControllerAttentionSecondtipLabel".icanlocalized;
    self.reasonTitleLabel.text = @"C2CCancelOrderViewControllerReasonTitleLabel".icanlocalized;
    self.reasonOneLabel.text = @"C2CCancelOrderViewControllerReasonOneLabel".icanlocalized;
    self.reasonTwoLabel.text = @"C2CCancelOrderViewControllerReasonTwoLabel".icanlocalized;
    self.reasonThreeLabel.text = @"C2CCancelOrderViewControllerReasonThreeLabel".icanlocalized;
    self.reasonFourLabel.text = @"C2CCancelOrderViewControllerReasonFourLabel".icanlocalized;
    self.reasonFiveLabel.text = @"C2CCancelOrderViewControllerReasonFiveLabel".icanlocalized;
    [self.sureButton setTitle:@"C2CCancelOrderViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    
//    icon_c2c_publish_check_circle_unsel c2c_icon_confirm
    [self.reasonOneButton setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    [self.reasonTwoButton setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    [self.reasonThreeButton setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    [self.reasonFourButton setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    [self.reasonFiveButton setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    self.sureButton.enabled = NO;
    RAC(self.sureButton,enabled)=[RACSignal combineLatest:@[
        self.otherTextView.rac_textSignal]reduce:^(NSString*other) {
        return @(other.length>0);
    }];
    [RACObserve(self, self.sureButton.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureButton.backgroundColor=UIColorThemeMainColor;
            [self.sureButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureButton.backgroundColor=UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(IBAction)reasonOneButtonAction{
    self.reasonOneButton.selected = YES;
    self.reasonTwoButton.selected = NO;
    self.reasonThreeButton.selected = NO;
    self.reasonFourButton.selected = NO;
    self.reasonFiveButton.selected = NO;
    self.otherTextView.hidden = YES;
    self.sureButton.enabled = YES;
    
}
-(IBAction)reasonTwoButtonAction{
    self.reasonTwoButton.selected = YES;
    self.reasonOneButton.selected = NO;
    self.reasonThreeButton.selected = NO;
    self.reasonFourButton.selected = NO;
    self.reasonFiveButton.selected = NO;
    self.otherTextView.hidden = YES;
    self.sureButton.enabled = YES;
}
-(IBAction)reasonThreeButtonAction{
    self.reasonThreeButton.selected = YES;
    self.reasonTwoButton.selected = NO;
    self.reasonOneButton.selected = NO;
    self.reasonFourButton.selected = NO;
    self.reasonFiveButton.selected = NO;
    self.otherTextView.hidden = YES;
    self.sureButton.enabled = YES;
}
-(IBAction)reasonFourButtonAction{
    self.reasonFourButton.selected = YES;
    self.reasonTwoButton.selected = NO;
    self.reasonThreeButton.selected = NO;
    self.reasonOneButton.selected = NO;
    self.reasonFiveButton.selected = NO;
    self.otherTextView.hidden = YES;
    self.sureButton.enabled = YES;
}
-(IBAction)reasonFiveButtonAction{
    self.reasonFiveButton.selected = YES;
    self.reasonOneButton.selected = NO;
    self.reasonTwoButton.selected = NO;
    self.reasonThreeButton.selected = NO;
    self.reasonFourButton.selected = NO;
    self.otherTextView.hidden = NO;
    self.sureButton.enabled = YES;
    
}
-(IBAction)sureButtonAction{
//    CancelC2cOrderTips
    [UIAlertController alertControllerWithTitle:nil message:@"CancelC2cOrderTips".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            C2CCancelOrderRequest * request = [C2CCancelOrderRequest request];
            ///api/adOrder/cancel/{adOrderId}
            request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/cancel/%ld",self.orderInfo.adOrderId];
            if (self.reasonOneButton.selected) {
                request.reason = @"#A1000000001";
            }else if (self.reasonTwoButton.selected){
                request.reason = @"#A1000000002";
            }else if (self.reasonThreeButton.selected){
                request.reason = @"#A1000000003";
            }else if (self.reasonFourButton.selected){
                request.reason = @"#A1000000004";
            }else if (self.reasonFiveButton.selected){
                if (self.otherTextView.text.length ==0) {
                    [QMUITipsTool showOnlyTextWithMessage:@"Pleasefillinthereason".icanlocalized inView:self.view];
                    return;
                }
                request.reason = self.otherTextView.text;
            }
            request.parameters = [request mj_JSONObject];
            [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
                C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                vc.orderInfo = response;
                [self.navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil userInfo:nil];
            } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }];
        }
    }];
   
}
@end

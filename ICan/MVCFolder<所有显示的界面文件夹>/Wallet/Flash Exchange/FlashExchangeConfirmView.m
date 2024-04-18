//
//  FlashExchangeConfirmView.m
//  ICan
//
//  Created by MAC on 2022-08-19.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "FlashExchangeConfirmView.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "EmailBindingViewController.h"
@interface FlashExchangeConfirmView ()
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fromIcon;
@property (weak, nonatomic) IBOutlet UIImageView *toIcon;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *receiveAmount;
@property (weak, nonatomic) IBOutlet UILabel *fromAmountLabel;
@property (nonatomic,weak) UIViewController * showViewController;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeValLabel;

@end

@implementation FlashExchangeConfirmView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenPopupView)];
    [self.backgroundView addGestureRecognizer:tap];
}

-(void)setupView{
    self.popupView.layer.cornerRadius = 25;
    self.confirmBtn.layer.cornerRadius = 20;
    
    self.titleLabel.text = @"ExchangeConfirmation".icanlocalized;
    self.fromLabel.text = @"From".icanlocalized;
    self.receiveLabel.text = @"Receive".icanlocalized;
    self.feeLabel.text = @"Fee".icanlocalized;
    if ([self.currentCurrencyExchangeObject.handlingFee isEqual: @0]) {
        self.feeValLabel.text = [@":" stringByAppendingString: @"NoFee".icanlocalized];
    }else {
        self.feeValLabel.text = [NSString stringWithFormat:@": %@", self.currentCurrencyExchangeObject.handlingFee];
    }
    
    [self.confirmBtn setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    
    NSData * fromImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.currentCurrencyExchangeObject.fromInfo.icon]];
    self.fromIcon.image = [UIImage imageWithData: fromImageData];
    NSData * toImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:  self.currentCurrencyExchangeObject.toInfo.icon]];
    self.toIcon.image = [UIImage imageWithData: toImageData];
    self.fromAmountLabel.text = [NSString stringWithFormat:@"%@ %@", self.fromAmount,  self.currentCurrencyExchangeObject.fromCode];
    self.receiveAmount.text = [NSString stringWithFormat:@"%@ %@", self.toAmount,  self.currentCurrencyExchangeObject.toCode];
}

- (void)hiddenPopupView {
    if (self.superview) {
        self.hidden = YES;
    }
}

-(void)hiddenView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
        [self layoutIfNeeded];
    }];
    [self setupView];
}

- (IBAction)cancelExchanging:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmExchanging:(id)sender {
    [self showSurePayView];
}

-(void)showSurePayView{
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [[PayManager sharedManager]checkPaymentPassword:self.fromAmount successBlock:^(NSString * _Nonnull password) {
            [self transferRequest:password];
        }];
    }else {
        [self removeFromSuperview];
        [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
            if (index==0) {
                if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                    EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }else{
                    SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }
        }];
    }
}

-(void)transferRequest:(NSString *)password{
    VerifyPaymentPasswordRequest * vRequest = [VerifyPaymentPasswordRequest request];
    vRequest.paymentPassword = password;
    vRequest.parameters = [vRequest mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:vRequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        PostC2CCurrencyExchangeRequest * request =[PostC2CCurrencyExchangeRequest request];
        request.fromCode = self.currentCurrencyExchangeObject.fromCode;
        request.toCode = self.currentCurrencyExchangeObject.toCode;
        request.money = [NSDecimalNumber decimalNumberWithString:self.fromAmount];
        request.payPassword = password;
        request.parameters = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
            [QMUITipsTool showOnlyTextWithMessage:@"ExchangeSuccessful".icanlocalized inView:self];
            
            double delayInSeconds = 2.0;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self removeFromSuperview];
                if(self.sureBlock) {
                    self.sureBlock();
                }
            });
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self];
        }];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self showSurePayView];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self showSurePayView];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self];
            }
        } else {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self];
        }
    }];
}

@end

//
//  VerifyOTPVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "VerifyOTPVC.h"

@interface VerifyOTPVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet QMUITextField *PinTxt;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *otpTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *otpTipLbl;
@end

@implementation VerifyOTPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PinTxt.maximumTextLength = 4;
    self.verifyBtn.layer.cornerRadius = 10.0;
    self.verifyBtn.layer.masksToBounds = YES;
    [self.confirmView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.confirmView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.confirmView.layer.shadowOffset = CGSizeMake(0, 2);
    self.confirmView.layer.shadowOpacity = 0.5;
    self.confirmView.layer.shadowRadius = 5.0;
    self.confirmView.layer.masksToBounds = NO;
    [self addLocalize];
}

-(void)addLocalize{
    [self.verifyBtn setTitle:@"Verify".icanlocalized forState:UIControlStateNormal];
    self.otpTitleLbl.text = @"Enter the OTP".icanlocalized;
    [self.PinTxt layerWithCornerRadius:10 borderWidth:0.5 borderColor:UIColor.blackColor];
    self.otpTipLbl.text = @"Verification code sent to account holder".icanlocalized;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.bgView.bounds;
    blurView.alpha = 1.0;
    [self.bgView addSubview:blurView];
}

- (IBAction)verifyAction:(id)sender {
    if (self.addBlock) {
        self.addBlock(self.PinTxt.text);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)closeBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

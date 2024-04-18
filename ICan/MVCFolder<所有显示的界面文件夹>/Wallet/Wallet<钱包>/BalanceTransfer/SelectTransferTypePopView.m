//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  SelectTransferTypePopView.m
- Description:
- Function List:
*/
        
#import "SelectTransferTypePopView.h"
#import "TransferInputIdViewController.h"
#import "IcanTransferBankViewController.h"
#import "IcanTransferAlipayViewController.h"
#import "CertificationViewController.h"

@interface SelectTransferTypePopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *icanBgView;
@property (weak, nonatomic) IBOutlet UILabel *icanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *icanDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *huioneBgView;
@property (weak, nonatomic) IBOutlet UILabel *huioneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *huioneDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *abaBgView;
@property (weak, nonatomic) IBOutlet UILabel *abaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abaDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *bankBgView;
@property (weak, nonatomic) IBOutlet UILabel *bankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *alipayBgView;
@property (weak, nonatomic) IBOutlet UILabel *alipayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipayDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end
@implementation SelectTransferTypePopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = @"Transfer".icanlocalized;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer *tap15 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.icanBgView addGestureRecognizer:tap15];
    UITapGestureRecognizer *tap30 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bankBgView addGestureRecognizer:tap30];
    UITapGestureRecognizer *tap45 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.alipayBgView addGestureRecognizer:tap45];
    UITapGestureRecognizer *tap60 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.huioneBgView addGestureRecognizer:tap60];
    UITapGestureRecognizer *tap75 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.abaBgView addGestureRecognizer:tap75];
    self.icanTitleLabel.text = @"TransferToICANBalance".icanlocalized;
    self.icanDetailLabel.text = @"Realtimetransfer0handlingfee".icanlocalized;
    self.bankTitleLabel.text = @"TransfertoBankCard".icanlocalized;
    self.bankDetailLabel.text = @"Thetransferhandlingfee".icanlocalized;
    self.alipayTitleLabel.text = @"TransferToAlipay".icanlocalized;
    self.alipayDetailLabel.text = @"Thetransferhandlingfee".icanlocalized;
    self.huioneTitleLabel.text = @"TransferToHuione".icanlocalized;
    self.huioneDetailLabel.text = @"Thetransferhandlingfee".icanlocalized;
    self.abaTitleLabel.text = @"TransferToABA".icanlocalized;
    self.abaDetailLabel.text = @"Thetransferhandlingfee".icanlocalized;
}

- (void)tapAction:(UITapGestureRecognizer*)gest {
    UIView * view = gest.view;
    switch (view.tag) {
        case 100:{
            TransferInputIdViewController *vc = [[TransferInputIdViewController alloc]init];
            vc.isCNY = YES;
            [[AppDelegate shared] pushViewController:vc animated:YES];
        }
            break;
        case 101:{
            if([self checkAuth]) {
                IcanTransferBankViewController *vc = [[IcanTransferBankViewController alloc]init];
                vc.bankType = @"Bank";
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }
        }
            break;
        case 102:{
            if([self checkAuth]) {
                IcanTransferAlipayViewController *vc = [[IcanTransferAlipayViewController alloc]init];
                vc.bankType = @"Alipay";
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }
        }
            break;
        case 103:{
            if([self checkAuth]) {
                IcanTransferAlipayViewController *vc = [[IcanTransferAlipayViewController alloc]init];
                vc.bankType = @"Huione";
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }
        }
            break;
        case 104:{
            if([self checkAuth]) {
                IcanTransferBankViewController *vc = [[IcanTransferBankViewController alloc]init];
                vc.bankType = @"ABA";
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
    [self hiddenView];
}

- (BOOL)checkAuth {
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        return YES;
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.superview];
        return NO;
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        [UIAlertController alertControllerWithTitle:@"RealnameNoAuthTip".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index == 1) {
                if(self.navigateToAuth) {
                    self.navigateToAuth();
                }
            }
        }];
        return NO;
    }else {
        return NO;
    }
}

- (void)hiddenView {
    self.backgroundColor = UIColor.clearColor;
    self.hidden = YES;
}

- (void)showView {
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
}

@end

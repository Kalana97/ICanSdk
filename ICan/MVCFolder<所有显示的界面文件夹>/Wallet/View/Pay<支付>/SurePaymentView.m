//
//  PaymentPassWordView.m
//  CaiHongApp
//
//  Created by lidazhi on 2019/4/11.
//  Copyright © 2019 DW. All rights reserved.
//

#import "SurePaymentView.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "PrivacyPermissionsTool.h"

@interface  SurePaymentView ()
@property (nonatomic,weak) IBOutlet UIStackView * bgContentView;
/**关闭*/
@property (nonatomic,weak) IBOutlet UIButton * closeButton;

@property (weak, nonatomic) IBOutlet UIView *handBgView;
/** 手续费 */
@property(nonatomic, strong) IBOutlet UILabel *handLabel;
@property (weak, nonatomic) IBOutlet UIView *rateBgView;

/** 手续费率 */
@property(nonatomic, strong) IBOutlet UILabel *rateLabel;




@end

@implementation SurePaymentView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgContentView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    @weakify(self);
    self.payInputView.RedEnvelopPayInPutViewDidCompletion = ^(NSString *text) {
        @strongify(self);
        [self.payInputView endInput];
        [self hiddenSurePaymentView];
        !self.payViewPasswordBlock?:self.payViewPasswordBlock(text);
    };
    self.titleLabel.text = @"ICanPay".icanlocalized;
    self.handLabel.text = @"HandlingFee".icanlocalized;
    self.rateLabel.text = @"HandlingFeeRate".icanlocalized;
    self.attemptHintLabel.text = @"payPassHint".icanlocalized;
}
-(void)setAmount:(NSString *)amount{
    _amount=amount;
    self.moneyLabel.text=[NSString stringWithFormat:@"￥%.2f", [amount doubleValue]];
}
-(void)setTypeStr:(NSString *)typeStr{
    _typeStr=typeStr;
    self.typeLabel.text=typeStr;
}

- (void)setAttemptStr:(NSString *)attemptStr{
    _attemptStr=attemptStr;
    self.attemptsLabel.text=attemptStr;
}

-(void)setSurePaymentViewType:(SurePaymentViewType)surePaymentViewType{
    _surePaymentViewType=surePaymentViewType;
    if (surePaymentViewType==SurePaymentView_Withdraw) {
        self.balanceBgView.hidden=YES;
        self.handBgView.hidden = self.rateBgView.hidden = NO;
        
    }else if (surePaymentViewType==SurePaymentView_c2cConfirmReceiptMoney){
        self.balanceBgView.hidden=YES;
    }
}

-(void)showSurePaymentView{
    if (UserInfoManager.sharedManager.isPayBlocked){
        self.blockInfoLabel.hidden = NO;
        self.attemptHintLabel.hidden = YES;
        self.attemptsLabel.text = [NSString stringWithFormat:@"%@ 0", @"payPassRemainingAttempt".icanlocalized];
        self.blockInfoLabel.text = [NSString stringWithFormat:@"%@ %@", @"payPassUnblockHint".icanlocalized, UserInfoManager.sharedManager.unblockTime];
    } else if (UserInfoManager.sharedManager.attemptCount != nil) {
        self.attemptHintLabel.hidden = NO;
        self.attemptsLabel.text = [NSString stringWithFormat:@"%@ %@", @"payPassRemainingAttempt".icanlocalized, UserInfoManager.sharedManager.attemptCount];
    } else {
        self.attemptsLabel.hidden = YES;
        self.attemptHintLabel.hidden = YES;
    }
    [self.payInputView beginInput];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
}
-(void)hiddenSurePaymentView{
    dispatch_main_async_safe(^{
        [self removeFromSuperview];
    });
    
}
//-(SelectPayWayView *)paywayView{
//    if (!_paywayView) {
//        _paywayView=[[NSBundle mainBundle]loadNibNamed:@"SelectPayWayView" owner:self options:nil].firstObject;
//        _paywayView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        @weakify(self);
//        _paywayView.closeBlock = ^{
//            @strongify(self);
//            self.hidden=NO;
//            self.paywayView.hidden=YES;
//            [self.payInputView beginInput];
//        };
//        _paywayView.selectChannelInfoBlock = ^(RechargeChannelInfo * _Nonnull info) {
//            @strongify(self);
//            self.hidden=NO;
//            self.selectChannelInfo=info;
//            self.payWayIconImageView.image=UIImageMake(info.imageurl);
//            if ([info.payType isEqualToString:@"Banlance"]) {
//                self.payWayLabel.text=[NSString stringWithFormat:@"%@(￥%.2f)",@"Balance".icanlocalized,[info.maxAmount doubleValue]];
//            }else{
//                self.payWayLabel.text=info.channelName;
//            }
//            [self.payInputView beginInput];
//        };
//        _paywayView.sureButtonBlock = ^(RechargeChannelInfo * _Nonnull info) {
//            @strongify(self);
//            self.hidden=YES;
//            self.selectChannelInfo=info;
//            !self.payViewPasswordBlock?:self.payViewPasswordBlock(@"");
//        };
//    }
//    return _paywayView;
//}
- (IBAction)closeBtnAction:(id)sender {
    [UserInfoManager sharedManager].attemptCount = nil;
    [UserInfoManager sharedManager].isPayBlocked = NO;
    !self.cancleButtonBlock?:self.cancleButtonBlock();
    [self hiddenSurePaymentView];
}

// 设置指纹验证
- (void)verificationlocalAuthen {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    __block NSString*title;
    __block NSString*message;
    [PrivacyPermissionsTool judgeSupporFaceIDOrTouchID:^(NSString *str) {
        if ([str isEqualToString:@"FACEID"]) {
            title=@"请验证已有的面部ID，用于支付";
            message=@"开启后，可使用face ID验证指纹快速完成付款";
        }else if ([str isEqualToString:@"TOUCHID"]){
            title=@"请验证已有的指纹，用于支付";
            message=@"开启后，可使用face ID验证指纹快速完成付款";
        }else{
            
        }
    }];
    NSString *myLocalizedReasonString = title;
    // 判断设备是否支持指纹识别
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        // 指纹识别只判断当前用户是否机主
        @weakify(self);
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
            @strongify(self);
            if (success) {
                [self hiddenSurePaymentView];
                !self.localAuthenSuccessBlock?:self.localAuthenSuccessBlock();
                DDLogInfo(@"指纹认证成功");
                
            } else {
                !self.localAuthenfailBlock?:self.localAuthenfailBlock();
                // User did not authenticate successfully, look at error and take appropriate action
                DDLogInfo(@"指纹认证失败，%@",error.description);
                
                switch (error.code) {
                    case -1:
                    {
                        DDLogInfo(@"连续三次指纹识别错误");
                    }
                        break;
                    case -2:
                    {
                        DDLogInfo(@"在TouchID对话框中点击了取消按钮");
                        
                    }
                        break;
                    case -3:
                    {
                        DDLogInfo(@"在TouchID对话框中点击了输入密码按钮");
                    }
                        break;
                    case -4:
                    {
                        DDLogInfo(@"TouchID对话框被系统取消，例如按下Home或者电源键");
                    }
                        break;
                    case -8:
                    {
                        DDLogInfo(@"连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码");
                    }
                        break;
                    default:
                        break;
                }
                
                // 错误码 error.code
                // -1: 连续三次指纹识别错误
                // -2: 在TouchID对话框中点击了取消按钮
                // -3: 在TouchID对话框中点击了输入密码按钮
                // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
            }
        }];
        
    } else {
        
        // TouchID没有设置指纹
        // 关闭密码（系统如果没有设置密码TouchID无法启用）
    }
}
@end

//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 31/3/2020
 - File name:  SendSingleRedTableViewController.m
 - Description:
 - Function List:
 */


#import "SendSingleRedTableViewController.h"
#import "ChatUtil.h"
#import "PayManager.h"
#import "RedPacketRecordingViewController.h"
#import "DZUITextField.h"
@interface SendSingleRedTableViewController ()<DZUITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong)IBOutlet UIView *bgAmountView;
@property(nonatomic, strong)IBOutlet UILabel *amoutLabel;
@property(nonatomic, strong)IBOutlet DZUITextField *amountTextfield;
@property(nonatomic, strong)IBOutlet UILabel *cnyLabel;

@property(nonatomic, strong)IBOutlet UIView *commentView;
@property(nonatomic, strong)IBOutlet QMUITextView *commentTextView;

@property(nonatomic, strong)IBOutlet UILabel *allMoneyLabel;
@property(nonatomic, strong)IBOutlet UIButton *sendButton;

@property(nonatomic, copy) NSString *amount;

@property(nonatomic, strong) PayManager *payManager;
/** 当金额不合法的时候 提示语 高度是30*/
@property(nonatomic, strong)IBOutlet UILabel *tipsLabel;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@end

@implementation SendSingleRedTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        self.balanceInfo = balance;
    }];
    self.tipsLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(moreButtonAction)];
    self.title=NSLocalizedString(@"SendRedPacket", 发红包);
    [self.sendButton setTitle:NSLocalizedString(@"PrepareRedPacket", 塞钱进红包) forState:UIControlStateNormal];
    self.commentTextView.placeholder=NSLocalizedString(@"BlessingWords", 恭喜发财大吉大利);
    
    [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.cnyLabel.text = NSLocalizedString(@"YuanChat", CNY);
    }
    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.cnyLabel.text = NSLocalizedString(@"Yuan", CNT);
    }
    self.amoutLabel.text = NSLocalizedString(@"Amount", 金额);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction) name:UITextFieldTextDidChangeNotification object:_amountTextfield];
    self.view.backgroundColor = UIColorBg243Color;
    
}

-(void)moreButtonAction{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"SentPackets", 发出的红包)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
        vc.receive=NO;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ReceivedPackets", 收到的红包) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
        vc.receive=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)textChangeAction{
    
    NSString*textstr=self.amountTextfield.text;
    NSString * errorTipsStr;
    double oneRedPacket=[textstr doubleValue];
    BOOL isShowTips=YES;
    if(oneRedPacket>10000.00){
        //        errorTipsStr=@"单个红包金额不超过10000元";
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            errorTipsStr = @"Up to 10000CNY for each Red Packet Chat".icanlocalized;
        }
        
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            errorTipsStr = @"Up to 10000CNY for each Red Packet".icanlocalized;
        }
        self.sendButton.enabled = NO;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        isShowTips = YES;
    }else if (textstr.length==4){
        //        errorTipsStr=@"单个红包金额不低于0.01元";
        if (oneRedPacket<0.01) {
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                errorTipsStr=@"The red packet amount cannot be less than 0.01CNY Chat".icanlocalized;
            }
            
            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                errorTipsStr=@"The red packet amount cannot be less than 0.01CNY".icanlocalized;
            }
            
            self.sendButton.enabled=NO;
            isShowTips=YES;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        }else{
            self.sendButton.enabled=YES;
            [self.sendButton setBackgroundColor:UIColorMake(243, 92, 75)];
            isShowTips=NO;
        }
        
    }else if([self isDoubleEqualToZero:oneRedPacket] == YES){
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            errorTipsStr = @"The red packet amount cannot be less than 0.01CNY Chat".icanlocalized;
        }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            errorTipsStr = @"The red packet amount cannot be less than 0.01CNY".icanlocalized;
        }
        self.sendButton.enabled = NO;
        isShowTips = YES;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
    }else{
        isShowTips=NO;
        NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.amountTextfield.text];
        if ([total isEqualToNumber:[NSDecimalNumber notANumber]]) {
            self.sendButton.enabled=NO;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        }else{
            self.sendButton.enabled=YES;
            [self.sendButton setBackgroundColor:UIColorMake(243, 92, 75)];
        }
        
        
    }
    if (isShowTips) {
        self.tipsLabel.text=errorTipsStr;
        self.tipsLabel.hidden = NO;
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:1 borderColor:[UIColor redColor]];
    }else{
        self.tipsLabel.hidden = YES;
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    self.allMoneyLabel.text=[NSString stringWithFormat:@"%.2f CNT",[textstr doubleValue]];
}
-(IBAction)sendButtonAction{
    if (self.balanceInfo) {
        [self showSurePayView];
    }else{
        [UserInfoManager.sharedManager fetchUserBalanceRequest:^(UserBalanceInfo * _Nonnull balance) {
            self.balanceInfo = balance;
            [self showSurePayView];
        }];
    }
}
-(void)showSurePayView{
    NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.amountTextfield.text];
    if ([total compare:self.balanceInfo.balance] == NSOrderedAscending || [total compare:self.balanceInfo.balance] == NSOrderedSame) {
        [self.payManager showPayViewWithAmount:total.stringValue typeTitleStr:@"chatView.function.redPacket".icanlocalized SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
            [self sendRedPacketRequest:password];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:self.view];
    }
}
-(void)sendRedPacketRequest:(NSString*)passwprd{
    SendSingleRedPacketRequest*request=[SendSingleRedPacketRequest request];
    request.to=self.toUserId;
    request.amount=self.amountTextfield.text;
    request.comment=self.commentTextView.text.length>0?self.commentTextView.text:NSLocalizedString(@"BlessingWords", 恭喜发财大吉大利);
    request.payPassword=passwprd;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[SendSingleRedPacketInfo class] contentClass:[SendSingleRedPacketInfo class] success:^(SendSingleRedPacketInfo* response) {
        [QMUITips hideAllTips];
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        if(response.status == 3 || response.status == 2){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
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
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
}

- (BOOL)isDoubleEqualToZero:(double)value {
    double epsilon = 0.000001; // Choose an appropriate epsilon value
    // Compare the absolute difference between the value and 0 with the epsilon
    if (fabs(value - 0.0) <= epsilon || fabs(value - 0.00 ) <= epsilon || fabs(value - 0 ) <= epsilon) {
        return YES;
    } else {
        return NO;
    }
}
@synthesize floatLenth;

@end

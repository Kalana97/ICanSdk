//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 23/11/2021
 - File name:  C2CConfirmReceiptMoneyViewController.m
 - Description:
 - Function List:
 */


#import "C2CPaymentViewController.h"
#import "C2COrderDetailViewController.h"
#import "UIViewController+Extension.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "YBImageBrowerTool.h"
#import "C2CBuyerQuestionViewController.h"
#import "WebSocketManager+HandleMessage.h"
#import "WCDBManager+ChatList.h"

@interface C2CPaymentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *payTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *relationLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIView *bankBgView;
@property (weak, nonatomic) IBOutlet UILabel *bankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;

@property (weak, nonatomic) IBOutlet UIView *branchBgView;
@property (weak, nonatomic) IBOutlet UILabel *branchTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;

///收款二维码
@property (weak, nonatomic) IBOutlet UIView *receiveMoneyBgView;
@property (weak, nonatomic) IBOutlet UILabel *receiveQrCodeTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiveQrCodeImgView;

//交易条款
@property (weak, nonatomic) IBOutlet UIView *exchangeProvisionBgContentView;
///交易条款的title
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionTitleLabel;
@property (weak, nonatomic) IBOutlet UIControl *exchangeProvisionBgView;
///交易条款的内容
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exchangeProvisionImgView;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *namePasteDataButton;
@property (weak, nonatomic) IBOutlet UIButton *accountNoPasteDataButton;
@property (weak, nonatomic) IBOutlet UIButton *bankNamePasteDataButton;
@property (weak, nonatomic) IBOutlet UIButton *accountBranchPasteDataButton;
@end

@implementation C2CPaymentViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"C2CPConfirmOrderViewController",@"C2COptionalSaleViewController"]];
    [self checkHaveUnreadMsg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkHaveUnreadMsg) name:kC2COrderNotification object:nil];
    self.view.backgroundColor = UIColorBg243Color;
    self.title = @"C2CPaymentViewControllerTitle".icanlocalized;
    self.payTipsLabel.text = @"C2CPaymentViewControllerPayTipsLabel".icanlocalized;
    self.timeTipsLabel.text = @"C2CPaymentViewControllerTimeTipsLabel".icanlocalized;
    self.relationLabel.text = @"C2CPaymentViewControllerRelationLabel".icanlocalized;
    self.stepOneLabel.text = @"C2CPaymentViewControllerStepOneLabel".icanlocalized;
    self.stepTwoLabel.text = @"C2CPaymentViewControllerStepTwoLabel".icanlocalized;
    
    self.nameTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerNameTitleLabel".icanlocalized;
    self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
    self.branchTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBranchTitleLabel".icanlocalized;
    self.exchangeProvisionTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerExchangeProvisionTitleLabel".icanlocalized;
    [self.complaintButton setTitle:@"C2CPaymentViewControllerComplaintButton".icanlocalized forState:UIControlStateNormal];
    [self.sureButton setTitle:@"C2CPaymentViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    self.receiveQrCodeTipLabel.text = @"ReceiveQrCode".icanlocalized;
    [self.complaintButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self starTimer];
    [self setTimeLabelWith:self.payCancelTime];
    /** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
    NSArray * nameItems = [self.methodInfo.name componentsSeparatedByString:@" "];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nameItems.lastObject,nameItems.firstObject];
    if(self.methodInfo.account){
        self.accountLabel.text = self.methodInfo.account;
        self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
    }else{
        self.accountLabel.text = self.methodInfo.mobile;
        self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
    }
    if ([self.methodInfo.paymentMethodType isEqualToString:@"BankTransfer"]) {
        self.payWayLabel.text = @"C2CBankCard".icanlocalized;
        self.receiveMoneyBgView.hidden = YES;
        if (self.methodInfo.bankName.length>0) {
            self.bankBgView.hidden = NO;
            self.bankLabel.text = self.methodInfo.bankName;
        }else{
            self.bankBgView.hidden = YES;
        }
        if (self.methodInfo.branch.length>0) {
            self.branchBgView.hidden = NO;
            self.branchLabel.text = self.methodInfo.branch;
        }else{
            self.branchBgView.hidden = YES;
        }
    }
    if ([self.methodInfo.paymentMethodType isEqualToString:@"AliPay"]) {
        self.payWayLabel.text = @"C2CAlipay".icanlocalized;
        self.bankBgView.hidden = YES;
        self.branchBgView.hidden = YES;
        if (self.methodInfo.qrCode) {
            self.receiveMoneyBgView.hidden = NO;
            [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.methodInfo.qrCode]];
        }
    }
    if ([self.methodInfo.paymentMethodType isEqualToString:@"Wechat"]) {
        self.payWayLabel.text = @"C2CWeChat".icanlocalized;
        self.branchBgView.hidden = YES;
        self.bankBgView.hidden = YES;
        if (self.methodInfo.qrCode) {
            self.receiveMoneyBgView.hidden = NO;
            [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.methodInfo.qrCode]];
        }
    }
    if ([self.methodInfo.paymentMethodType isEqualToString:@"Cash"]) {
        self.payWayLabel.text = @"Cash".icanlocalized;
        if(self.methodInfo.account){
            self.accountLabel.text = self.methodInfo.account;
            self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
        }else{
            self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
            NSString *mobile = self.methodInfo.mobile;
            for (int i = mobile.length/2; i < mobile.length ; i++) {
                
                if (![[mobile substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                    NSRange range = NSMakeRange(i, 1);
                    mobile = [mobile stringByReplacingCharactersInRange:range withString:@"*"];
                }
            }
            self.accountLabel.text = mobile;
        }
        if(self.methodInfo.bankName){
            self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
            self.bankLabel.text = self.methodInfo.bankName;
        }else{
            self.bankTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
            NSString *address = self.methodInfo.address;
            for (int i = 0; i < address.length / 2 ; i++) {
                if (![[address substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                    NSRange range = NSMakeRange(i, 1);
                    address = [address stringByReplacingCharactersInRange:range withString:@"*"];
                }
            }
            self.bankLabel.text = address;
        }
        self.branchBgView.hidden = YES;
        self.receiveMoneyBgView.hidden = YES;
        self.namePasteDataButton.hidden = YES;
        self.accountNoPasteDataButton.hidden = YES;
        self.bankNamePasteDataButton.hidden = YES;
        self.accountBranchPasteDataButton.hidden = YES;
    }
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",self.orderInfo.totalCount.floatValue];
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.legalTender];
    self.symbolLabel.text = info.symbol;
    if (self.orderInfo.transactionTerms) {
        self.exchangeProvisionBgContentView.hidden = NO;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }else{
        self.exchangeProvisionBgContentView.hidden = YES;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showReceiveQRcode)];
    [self.receiveQrCodeImgView addGestureRecognizer:tap];
    [self.unReadLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self checkHaveUnreadMsg];
}

-(void)showReceiveQRcode{
    YBImageBrowerTool * tool = [[YBImageBrowerTool alloc]init];
    [tool showC2CQrCodeImageWith:self.methodInfo.qrCode];
}
///隐藏或者显示交易条款
- (IBAction)hiddenOrShowProvisionAction {
    self.exchangeProvisionBgView.hidden = !self.exchangeProvisionBgView.hidden;
    self.exchangeProvisionImgView.image = self.exchangeProvisionBgView.hidden?UIImageMake(@"icon_c2c_arrow_up"):UIImageMake(@"icon_c2c_arrow_down");
}

-(void)starTimer{
    NSTimeInterval currenTime = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval creatTime = self.orderInfo.createTime.integerValue;
    __block NSTimeInterval time =self.orderInfo.payCancelTime*60- (currenTime-creatTime)/1000;
    if (currenTime-creatTime>self.orderInfo.payCancelTime*60*1000) {
        C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
        vc.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:vc animated:YES];
        self.timeLabel.hidden = YES;
        self.timeTipsLabel.hidden = YES;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置按钮的样式
                    self.timeLabel.hidden = YES;
                    self.timeTipsLabel.hidden = YES;
                    C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                    vc.orderInfo = self.orderInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLabel.text =[NSString stringWithFormat:@"%@",[self setTimeLabelWith:time]] ;
                });
                time--;
            }
        });
        dispatch_resume(_timer);
    }
    
}
-(NSString*)setTimeLabelWith:(NSInteger)second{
    if (second<60) {
        return [NSString stringWithFormat:@"%.2ld",second];
    }else if (60<=second&&second<3600){
        return [NSString stringWithFormat:@"%.2ld:%.2ld",second/60,second%60];
    }
    NSInteger hour = second/3600;
    NSInteger minute = second/60%60;
    NSInteger seconds = second%60;
    return [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,seconds];
    return nil;
}
///联系卖家
- (IBAction)relationAction {
    self.unReadLabel.hidden = YES;
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.sellUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.sellUser.userId,kC2COrderId:self.orderInfo.orderId}];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)copyAMountAction{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.orderInfo.totalCount.stringValue;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
-(IBAction)copyNameAction{
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.methodInfo.name;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
-(IBAction)copyAccountAction{
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.methodInfo.account;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
-(IBAction)copyBankNameAction{
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.methodInfo.bankName;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
-(IBAction)copyBranchAction{
    UIPasteboard * past = [UIPasteboard generalPasteboard];
    past.string = self.methodInfo.branch;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
//遇到问题
-(IBAction)complaintAction{
    C2CBuyerQuestionViewController*vc = [[C2CBuyerQuestionViewController alloc]init];
    vc.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
//我已经付款
-(IBAction)sureAction{
    C2CConfirmOrderPayRequest * request = [C2CConfirmOrderPayRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/pay/%ld/%@",(long)self.orderInfo.adOrderId,self.methodInfo.paymentMethodId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
        C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
        vc.orderInfo = response;
        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil userInfo:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (void)checkHaveUnreadMsg {
    NSNumber *count = 0;
    if(_orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:_orderInfo.sellUser.userId c2cOrderId:_orderInfo.orderId icanUserId:_orderInfo.sellUser.uid];
    }else {
        count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:_orderInfo.buyUser.userId c2cOrderId:_orderInfo.orderId icanUserId:_orderInfo.buyUser.uid];
    }
    if([count intValue] > 0) {
        self.unReadLabel.text = count.stringValue;
        self.unReadLabel.hidden = NO;
    }else {
        self.unReadLabel.hidden = YES;
    }
}
@end

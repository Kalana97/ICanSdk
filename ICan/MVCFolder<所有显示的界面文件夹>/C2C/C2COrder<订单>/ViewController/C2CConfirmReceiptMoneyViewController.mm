//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 23/11/2021
 - File name:  C2CConfirmReceiptMoneyViewController.m
 - Description:
 - Function List:
 */


#import "C2CConfirmReceiptMoneyViewController.h"
#import "C2CConfirmReceiptMoneyPopView.h"
#import "UIColor+DZExtension.h"
#import "C2CSaleSuccessViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "WCDBManager+ChatList.h"
#import "C2CComplaintOrderViewController.h"
#import "C2CComplaintTipView.h"
#import "PayManager.h"
@interface C2CConfirmReceiptMoneyViewController ()
@property (nonatomic, weak) IBOutlet UILabel *sureTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *sureTipsLabel;

@property (weak, nonatomic) IBOutlet UIControl *relationsBgCon;
@property (nonatomic, weak) IBOutlet UILabel *relationsSellerLabel;
///未读消息提示
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *SellerAppealTimeLab;


@property (weak, nonatomic) IBOutlet UILabel *saleTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
//总额
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;
///手续费率
@property (weak, nonatomic) IBOutlet UIView *serviceFeeRateBgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateLabel;
///手续费
@property (weak, nonatomic) IBOutlet UIView *serviceFeeBgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTipsLabel;
///买家信息
@property (weak, nonatomic) IBOutlet UILabel *buyerUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerUserNameDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyerUserIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerUserIDDetailLabel;
//收款方式
@property (weak, nonatomic) IBOutlet UILabel *receiveWayLabel;
///姓名
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

@property (nonatomic, strong) C2CConfirmReceiptMoneyPopView *popView;
@property (nonatomic, strong) C2CPaymentMethodInfo *methodInfo;
@property(nonatomic, assign) BOOL canClickComplaintBtn;
@property(nonatomic, strong) PayManager*manager;
@end

@implementation C2CConfirmReceiptMoneyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self getUnReadCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C2CConfirmReceiptMoneyViewControllerTitle".icanlocalized;
    self.sureTitleLabel.text = @"C2COrderStatePaid".icanlocalized;
    self.sureTipsLabel.text = @"C2COrderStatePaidTips".icanlocalized;
    self.relationsSellerLabel.text = @"C2CConfirmReceiptMoneyViewControllerRelationsSellerLabel".icanlocalized;
    self.saleTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerSaleTitleLabel".icanlocalized;
    self.totalAmountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerTotalAmountTitleLabel".icanlocalized;
    self.priceTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerPriceTitleLabel".icanlocalized;
    self.countTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerCountTitleLabel".icanlocalized;
    self.orderIdTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerOrderIdTitleLabel".icanlocalized;
    self.nameTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerNameTitleLabel".icanlocalized;
    self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
    self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
    self.branchTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBranchTitleLabel".icanlocalized;
    self.exchangeProvisionTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerExchangeProvisionTitleLabel".icanlocalized;
    [self.complaintButton setTitle:@"C2CConfirmReceiptMoneyViewControllerComplaintButton".icanlocalized forState:UIControlStateNormal];
    [self.sureButton setTitle:@"C2CConfirmReceiptMoneyViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    self.buyerUserLabel.text = @"BuyerInformation".icanlocalized;
    self.buyerUserIdLabel.text = @"mine.profile.title.more.IDNumber".icanlocalized;
    self.buyerUserNameLabel.text = @"Name".icanlocalized;
    [self.complaintButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self setData];
    [self getBuyerIcanUserMessage];
    self.serviceFeeRateTitleLabel.text = @"HandlingFeeRate".icanlocalized;
    self.serviceFeeTitleLabel.text = @"HandlingFee".icanlocalized;
    if ([self.orderInfo.transactionType isEqualToString:@"Sell"]) {
        //如果购买的人和自己是同一个人
        if (self.orderInfo.buyUserId != C2CUserManager.shared.userId.integerValue) {
            self.serviceFeeBgView.hidden = YES;
            self.serviceFeeRateBgView.hidden = YES;
        }
    }else{
        if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
            self.serviceFeeBgView.hidden = YES;
            self.serviceFeeRateBgView.hidden = YES;
        }
    }
    self.serviceFeeRateLabel.text = [NSString stringWithFormat:@"%@%%",[[self.orderInfo.handlingFee decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] calculateByNSRoundDownScale:2].currencyString];
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@%@",[self.orderInfo.handlingFeeMoney calculateByNSRoundDownScale:2].currencyString,self.orderInfo.virtualCurrency];
    [self getUnReadCount];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUnReadCount) name:KChatListRefreshNotification object:nil];
    [self.unReadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self getUnReadCount];
}

- (void)getUnReadCount {
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        NSNumber *count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:self.orderInfo.sellUser.userId c2cOrderId:self.orderInfo.orderId icanUserId:self.orderInfo.sellUser.uid];
        if(count.integerValue > 0) {
            self.unReadLabel.text = count.stringValue;
            self.unReadLabel.hidden = NO;
        }else {
            self.unReadLabel.hidden = YES;
        }
    }else{
        NSNumber *count = [[WCDBManager sharedManager]fetchC2COrderUnReadMessageCountWith:self.orderInfo.buyUser.userId c2cOrderId:self.orderInfo.orderId icanUserId:self.orderInfo.buyUser.uid];
        if(count.integerValue > 0) {
            self.unReadLabel.text = count.stringValue;
            self.unReadLabel.hidden = NO;
        }else {
            self.unReadLabel.hidden = YES;
        }
    }
}

-(void)setData{
    CGRect realRect = self.relationsBgCon.bounds;
    //    CAGradientLayer *gradientLayer = [UIColor caGradientLayerWithFrame:realRect cornerRadius:0 colors:@[(__bridge id)UIColorMake(156, 196, 243).CGColor, (__bridge id)UIColorMake(200, 220, 243).CGColor, (__bridge id)UIColorMake(243, 243, 243).CGColor] locations:@[@0.0,@0.6,@1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    //    [self.relationsBgCon.layer insertSublayer:gradientLayer atIndex:0];
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:realRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = realRect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.relationsBgCon.layer.mask = maskLayer;
    self.relationsBgCon.backgroundColor = UIColorMakeHEXCOLOR(0Xcce1fa);
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.virtualCurrency];
    [self.currencyImageView setImageWithString:info.icon placeholder:nil];
    //    "C2CPaymentViewControllerRelationLabel"="联系卖家";
    //    "C2CPaymentViewControllerRelationLabelBuy"="联系买家";
    self.relationsSellerLabel.text = @"C2CPaymentViewControllerRelationLabelBuy".icanlocalized;
    self.saleCurrencyLabel.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
    self.saleCurrencyLabel.textColor = UIColorMake(239, 51, 79);
    NSPredicate * dpredicate = [NSPredicate predicateWithFormat:@"code contains [cd] %@ ",self.orderInfo.legalTender];
    CurrencyInfo * dinfo =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:dpredicate].firstObject;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@%@",dinfo.symbol,self.orderInfo.totalCount.stringValue.currencyString];
    self.priceLabel.text =[NSString stringWithFormat:@"%@%@",dinfo.symbol,self.orderInfo.unitPrice.stringValue.currencyString]; ;
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderInfo.quantity.stringValue.currencyString,self.orderInfo.virtualCurrency];
    self.orderIdLabel.text = self.orderInfo.orderId;
    if (self.orderInfo.transactionTerms) {
        self.exchangeProvisionBgContentView.hidden = NO;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }else{
        self.exchangeProvisionBgContentView.hidden = YES;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }
    self.currencyLabel.text = self.orderInfo.virtualCurrency;
    [self starTimer];
    
}
-(void)starTimer{
    NSTimeInterval currenTime = [[NSDate date]timeIntervalSince1970]*1000;
    ///交易时间
    NSTimeInterval transactionTime = self.orderInfo.transactionTime.integerValue;
    ///剩余的申诉倒计时
    __block NSTimeInterval time =C2CUserManager.shared.sellerAppealTime.integerValue*60- (currenTime-transactionTime)/1000;
    ///允许点击申诉
    if (currenTime-transactionTime>transactionTime*60*1000) {
        self.SellerAppealTimeLab.hidden = YES;
        self.SellerAppealTimeLab.hidden = YES;
        self.canClickComplaintBtn = YES;
    }else{
        self.canClickComplaintBtn = NO;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.SellerAppealTimeLab.hidden = YES;
                    self.SellerAppealTimeLab.hidden = YES;
                    self.canClickComplaintBtn = YES;
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.SellerAppealTimeLab.text =[NSString stringWithFormat:@"%@",[self setTimeLabelWith:time]] ;
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
}
-(IBAction)relationAction{
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.buyUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.buyUser.userId,kC2COrderId:self.orderInfo.orderId}];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)copyAction{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.orderInfo.orderId;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
-(IBAction)openExchangeProvisionAction{
    self.exchangeProvisionBgView.hidden = !self.exchangeProvisionBgView.hidden;
    self.exchangeProvisionImgView.image = self.exchangeProvisionBgView.hidden?UIImageMake(@"icon_c2c_arrow_up"):UIImageMake(@"icon_c2c_arrow_down");
    
}
-(IBAction)complaintAction{
    if (self.canClickComplaintBtn) {
        C2CComplaintOrderViewController*vc = [C2CComplaintOrderViewController new];
        vc.orderInfo = self.orderInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [C2CComplaintTipView showC2CComplaintTipView];
    }
    
}
-(IBAction)sureAction{
    [self.popView showView];
}
-(void)getBuyerIcanUserMessage{
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=self.orderInfo.buyUser.uid;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        [self getC2CGetPaymentMethodDetailRequest:response];
        if (BaseSettingManager.isChinaLanguages) {
            self.receiveTipsLabel.text = [NSString stringWithFormat:@"请前往以下账户，确认买家（%@ %@）付款",response.lastName,response.firstName];
            self.buyerUserNameDetailLabel.text = [NSString stringWithFormat:@"%@ %@",response.lastName,response.firstName];
        }else{
            self.buyerUserNameDetailLabel.text = [NSString stringWithFormat:@"%@  %@",response.firstName,response.lastName];
            self.receiveTipsLabel.text = [NSString stringWithFormat:@"Please go to the following account to confirm the buyer (%@ %@) payment",response.firstName,response.lastName];
        }
        self.buyerUserIDDetailLabel.text = response.cardId;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)getC2CGetPaymentMethodDetailRequest:(UserMessageInfo*)userDetails{
    //    /api/paymentMethod/{id}
    C2CGetPaymentMethodDetailRequest * request = [C2CGetPaymentMethodDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/paymentMethod/%ld",self.orderInfo.sellPaymentMethodId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CPaymentMethodInfo class] contentClass:[C2CPaymentMethodInfo class] success:^(C2CPaymentMethodInfo*  _Nonnull response) {
        self.methodInfo = response;
        /** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
        NSArray * nameItems = [self.methodInfo.name componentsSeparatedByString:@" "];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nameItems.lastObject,nameItems.firstObject];
        self.accountLabel.text = self.methodInfo.account;
        if ([self.methodInfo.paymentMethodType isEqualToString:@"BankTransfer"]) {
            self.receiveWayLabel.text = @"C2CBankCard".icanlocalized;
            
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
            self.receiveWayLabel.text = @"C2CAlipay".icanlocalized;
            self.accountTitleLabel.text = @"Account".icanlocalized;
            self.bankBgView.hidden = YES;
            self.branchBgView.hidden = YES;
        }
        if ([self.methodInfo.paymentMethodType isEqualToString:@"Wechat"]) {
            self.receiveWayLabel.text = @"C2CWeChat".icanlocalized;
            self.branchBgView.hidden = YES;
            self.bankBgView.hidden = YES;
            self.accountTitleLabel.text = @"Account".icanlocalized;
        }
        if ([self.methodInfo.paymentMethodType isEqualToString:@"Cash"]) {
            self.receiveWayLabel.text = @"Cash".icanlocalized;
            if (BaseSettingManager.isChinaLanguages) {
                self.receiveTipsLabel.text = [NSString stringWithFormat:@"请您在确认订单之前清点(%@)卖家支付的现金。",userDetails.lastName];
            }else{
                self.receiveTipsLabel.text = [NSString stringWithFormat:@"Please count your money the buyer (%@) handover  before confirm the order.",userDetails.lastName];
            }
            if(self.methodInfo.mobile){
                self.accountTitleLabel.text = @"C2CMobile".icanlocalized;
                self.accountLabel.text =self.methodInfo.mobile;
            }
            if(self.methodInfo.address){
                self.bankTitleLabel.text = @"Address".icanlocalized;
                self.bankLabel.text = self.methodInfo.address;
            }
            self.branchBgView.hidden = YES;
        }
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
    }];
    
}
-(C2CConfirmReceiptMoneyPopView *)popView{
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"C2CConfirmReceiptMoneyPopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _popView.sureBlock = ^{
            @strongify(self);
            [self confirmRequest];
        };
    }
    return _popView;
}
///确认收款
-(void)confirmRequest{
    self.manager = [[PayManager alloc]init];
    [self.manager showC2CConfirmReceiptMoney:[NSString stringWithFormat:@"%@ %@",self.orderInfo.virtualCurrency,self.orderInfo.quantity.stringValue.currencyString] SuccessBlock:^(NSString *  password) {
        C2CConfirmOrderRequest * request  = [C2CConfirmOrderRequest request];
        request.adOrderId = self.orderInfo.adOrderId;
        request.payPassword = password;
        request.parameters = [request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil userInfo:nil];
            if([response.status  isEqual: @"3"] || [response.status  isEqual: @"2"]){
                [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            }else{
                C2CSaleSuccessViewController * vc = [[C2CSaleSuccessViewController alloc]init];
                vc.orderInfo = response;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            if ([info.code isEqual:@"pay.password.error"]) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self confirmRequest];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self confirmRequest];
                } else {
                    [UserInfoManager sharedManager].attemptCount = nil;
                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
                }
            } else {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }
        }];
    }];
    
}
@end

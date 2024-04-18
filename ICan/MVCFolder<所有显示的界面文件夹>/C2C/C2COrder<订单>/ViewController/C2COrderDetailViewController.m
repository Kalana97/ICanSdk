//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 23/11/2021
 - File name:  C2CConfirmReceiptMoneyViewController.m
 - Description:
 - Function List:
 */


#import "C2COrderDetailViewController.h"
#import "C2CComplaintOrderViewController.h"
#import "C2CUserDetailViewController.h"
#import "UIViewController+Extension.h"
#import "UIColor+DZExtension.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import <MJRefresh.h>
#import "FriendDetailViewController.h"
#import "CommonWebViewController.h"
#import "ServiceTableViewController.h"
#import "C2CComplaintTipView.h"
#import "C2CCancelOrderViewController.h"
#import "WebSocketManager+HandleMessage.h"
#import "WCDBManager+ChatList.h"

@interface C2COrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *stateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateTipsLabel;

//联系卖家
@property (weak, nonatomic) IBOutlet UIControl *contactBgView;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerAppealTimeLab;
//出售文字
@property (weak, nonatomic) IBOutlet UILabel *saleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
//总额
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *totalAmountImgView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
///手续费率
@property (weak, nonatomic) IBOutlet UIView *serviceFeeRateBgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateLabel;
///手续费
@property (weak, nonatomic) IBOutlet UIView *serviceFeeBgView;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;

//创建时间
@property (weak, nonatomic) IBOutlet UILabel *creatTitmeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyNicknameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNicknameLabel;

//联系客服
@property (weak, nonatomic) IBOutlet UILabel *contactServiceLabel;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(nonatomic, assign) BOOL canClickComplaintBtn;
@property(nonatomic, strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@end

@implementation C2COrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkHaveUnreadMsg) name:kC2COrderNotification object:nil];
    self.title = @"OrderDetails".icanlocalized;
    self.view.backgroundColor = UIColorBg243Color;
    self.stateTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerSureTitleLabel".icanlocalized;
    self.stateTipsLabel.text = @"C2CConfirmReceiptMoneyViewControllerSureTipsLabel".icanlocalized;
    
    self.saleTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerSaleTitleLabel".icanlocalized;
    self.totalAmountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerTotalAmountTitleLabel".icanlocalized;
    self.priceTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerPriceTitleLabel".icanlocalized;
    self.countTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerCountTitleLabel".icanlocalized;
    self.orderIdTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerOrderIdTitleLabel".icanlocalized;
//    "C2COrderDetailViewControllerCreatTitmeTitleLabel"="Creation time";
//    "C2COrderDetailViewControllerContactServiceLabel"="Contact customer service";
//    "C2COrderDetailViewControllerComplaintButton"="Appeal";
    self.creatTitmeTitleLabel.text = @"C2COrderDetailViewControllerCreatTitmeTitleLabel".icanlocalized;
    self.contactServiceLabel.text = @"C2COrderDetailViewControllerContactServiceLabel".icanlocalized;
    [self.complaintButton setTitle:@"C2COrderDetailViewControllerComplaintButton".icanlocalized forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"C2CCancelOrderViewControllerTitle".icanlocalized forState:UIControlStateNormal];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOrderDetailInfoRequest)];
    if (self.orderInfo) {
        [self setData];
    }
    CGRect realRect = self.contactBgView.bounds;
//    CAGradientLayer *gradientLayer = [UIColor caGradientLayerWithFrame:realRect cornerRadius:0 colors:@[(__bridge id)UIColorMake(156, 196, 243).CGColor, (__bridge id)UIColorMake(200, 220, 243).CGColor, (__bridge id)UIColorMake(243, 243, 243).CGColor] locations:@[@0.0,@0.6,@1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
//    [self.contactBgView.layer insertSublayer:gradientLayer atIndex:0];
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:realRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = realRect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.contactBgView.layer.mask = maskLayer;
    self.contactBgView.backgroundColor = UIColorMakeHEXCOLOR(0Xcce1fa);
    [self getOrderDetailInfoRequest];
    self.serviceFeeRateTitleLabel.text = @"HandlingFeeRate".icanlocalized;
    self.serviceFeeTitleLabel.text = @"HandlingFee".icanlocalized;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getOrderDetailInfoRequest) name:kC2CRefreshOrderListNotification object:nil];
    [self.unReadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self checkHaveUnreadMsg];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"C2CPConfirmOrderViewController",@"C2CPaymentViewController",@"C2CCancelOrderViewController",@"C2CConfirmReceiptMoneyViewController",@"C2CSaleSuccessViewController",@"C2COptionalSaleViewController",@"C2CBuyerQuestionViewController"]];
    [self checkHaveUnreadMsg];
}

//联系对方
- (IBAction)relationOtherAction {
    //如果购买的人和自己是同一个人
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.sellUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.sellUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.buyUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.buyUser.userId,kC2COrderId:self.orderInfo.orderId}];
         [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)copyAction{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.orderIdLabel.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}
- (IBAction)cancelBtnAction {
    C2CCancelOrderViewController * vc = [C2CCancelOrderViewController new];
    vc.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:vc animated:YES];
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
- (IBAction)contactServiceAction {
    UserServiceListRequest*request=[UserServiceListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[CustomerServicesInfo class] contentClass:[CustomerServicesInfo class] success:^(CustomerServicesInfo* response) {
        if (response.csUserList) {
            if (response.csUserList.count==1) {
                FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
                vc.friendDetailType=FriendDetailType_push;
                ServicesInfo*info=response.csUserList[0];
                vc.userId=info.ID;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }else if (response.csWebList){
            if (response.csWebList.count==1) {
                CommonWebViewController*vc=[CommonWebViewController new];
                ServicesInfo*info=response.csWebList[0];
                vc.urlString=info.linkUrl;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        ServiceTableViewController *serviceVC = [[ServiceTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        serviceVC.info=response;
        [self.navigationController pushViewController:serviceVC animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
///跳转到某个用户详情
- (IBAction)goToUserDetail {
    C2CUserDetailViewController * vc = [[C2CUserDetailViewController alloc]init];
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        vc.userId = self.orderInfo.sellUser.userId.integerValue;
    }else{
        vc.userId = self.orderInfo.buyUser.userId.integerValue;
    }
   
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setData{
    /**
     "C2COrderStateUnpaid"="未付款";
     "C2COrderStateUnpaidTips"="订单未付款";
     "C2COrderStatePaid"="已付款";
     "C2COrderStatePaidTips"="订单已付款";
     "C2COrderStateAppeal"="申诉";
     "C2COrderStateAppealTips"="订单正在进行申诉";
     "C2COrderStateCompleted"="已完成";
     "C2COrderStateCompletedTips"="订单已完成";
     "C2COrderStateCancelled"="已取消";
     "C2COrderStateCancelledTip"="订单已取消";
     */
    NSString*stateStr;
    NSString*stateTips;
    if ([self.orderInfo.status isEqualToString:@"Unpaid"]) {
        stateStr = @"C2COrderStateUnpaid".icanlocalized;
        stateTips = @"C2COrderStateUnpaidTips".icanlocalized;
        self.complaintButton.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.buyerAppealTimeLab.hidden = YES;
    }else if ([self.orderInfo.status isEqualToString:@"Paid"]) {
        stateStr = @"C2COrderStatePaid".icanlocalized;
        stateTips = @"C2COrderStatePaidTips".icanlocalized;
        
    }else if ([self.orderInfo.status isEqualToString:@"Appeal"]) {
        stateStr = @"C2COrderStateAppeal".icanlocalized;
        stateTips = @"C2COrderStateAppealTips".icanlocalized;
        self.complaintButton.hidden = NO;
        self.buyerAppealTimeLab.hidden = YES;
        self.cancelBtn.hidden = YES;
    }else if ([self.orderInfo.status isEqualToString:@"Completed"]) {
        stateStr = @"C2COrderStateCompleted".icanlocalized;
        stateTips = @"C2COrderStateCompletedTips".icanlocalized;
        self.complaintButton.hidden = YES;
        self.buyerAppealTimeLab.hidden = YES;
        self.cancelBtn.hidden = YES;
    }else if ([self.orderInfo.status isEqualToString:@"Cancelled"]) {
        stateStr = @"C2COrderStateCancelled".icanlocalized;
        self.complaintButton.hidden = YES;
        self.buyerAppealTimeLab.hidden = YES;
        self.cancelBtn.hidden = YES;
        if ([self.orderInfo.cancelReason isEqualToString:@"#A1000000001"]) {
            stateTips = @"#A1000000001".icanlocalized;
        }else if ([self.orderInfo.cancelReason isEqualToString:@"#A1000000002"]) {
            stateTips = @"#A1000000002".icanlocalized;
        }else if ([self.orderInfo.cancelReason isEqualToString:@"#A1000000003"]) {
            stateTips = @"#A1000000003".icanlocalized;
        }else if ([self.orderInfo.cancelReason isEqualToString:@"#A1000000004"]) {
            stateTips = @"#A1000000004".icanlocalized;
        }else if ([self.orderInfo.cancelReason isEqualToString:@"#A0000000001"]) {
            stateTips = @"#A0000000001".icanlocalized;
        }else{
            stateTips = self.orderInfo.cancelReason;
        }
    }
    self.stateTitleLabel.text = stateStr;
    self.stateTipsLabel.text = stateTips;
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
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.orderInfo.handlingFeeMoney calculateByNSRoundDownScale:2].currencyString,self.orderInfo.virtualCurrency];
    //如果购买的人和自己是同一个人 那么这个是一个购买订单
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) { ///联系卖家
        self.saleCurrencyLabel.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
        self.saleCurrencyLabel.textColor = UIColorThemeMainColor;
        self.buyNicknameLabel.text = self.orderInfo.sellUser.nickname;
        self.buyNicknameTitleLabel.text = @"C2COptionalSaleViewControllerNicknameTitleLabelSell".icanlocalized;
        self.relationLabel.text = @"C2CPaymentViewControllerRelationLabel".icanlocalized;
       
    }else{
        self.saleCurrencyLabel.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
        self.saleCurrencyLabel.textColor = UIColorMake(239, 51, 79);
        self.buyNicknameLabel.text = self.orderInfo.buyUser.nickname;
        self.buyNicknameTitleLabel.text = @"C2COptionalSaleViewControllerNicknameTitleLabel".icanlocalized;
        self.relationLabel.text = @"C2CPaymentViewControllerRelationLabelBuy".icanlocalized;
    }
    
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.legalTender];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %@",info.symbol,self.orderInfo.totalCount.stringValue.currencyString];
    CurrencyInfo * virtualInfo =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.virtualCurrency];
    [self.currencyImageView setImageWithString:virtualInfo.icon placeholder:nil];
    self.priceLabel.text =[NSString stringWithFormat:@"%@ %@",info.symbol,[self.orderInfo.unitPrice calculateByNSRoundDownScale:2].currencyString]; ;
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[self.orderInfo.quantity calculateByNSRoundDownScale:2].currencyString,self.orderInfo.virtualCurrency];
    self.orderIdLabel.text = self.orderInfo.orderId;
    self.currencyLabel.text = self.orderInfo.virtualCurrency;
    self.createTimeLabel.text = [GetTime convertDateWithString:self.orderInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm"];
    [self starTimer];
}
-(void)starTimer{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    NSTimeInterval currenTime = [[NSDate date]timeIntervalSince1970]*1000;
    ///交易时间
    NSTimeInterval transactionTime = self.orderInfo.transactionTime.integerValue;
    ///剩余的申诉倒计时
    __block NSTimeInterval time =C2CUserManager.shared.buyerAppealTime.integerValue*60- (currenTime-transactionTime)/1000;
    ///允许点击申诉
    if (currenTime-transactionTime>transactionTime*60*1000) {
        self.buyerAppealTimeLab.hidden = YES;
        self.canClickComplaintBtn = YES;
    }else{
        self.canClickComplaintBtn = NO;
        self.buyerAppealTimeLab.hidden = NO;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(self.timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(self.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.buyerAppealTimeLab.hidden = YES;
                    self.canClickComplaintBtn = YES;
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.buyerAppealTimeLab.text =[NSString stringWithFormat:@"%@",[self setTimeLabelWith:time]] ;
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
-(void)getOrderDetailInfoRequest{
    C2CGetOrderDetailRequest * request = [C2CGetOrderDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/%ld",self.orderInfo.adOrderId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
        self.orderInfo = response;
        [self.scrollView.mj_header endRefreshing];
        [self setData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self.scrollView.mj_header endRefreshing];
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

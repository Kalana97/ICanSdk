//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 23/11/2021
 - File name:  C2CConfirmReceiptMoneyViewController.m
 - Description:
 - Function List:
 */


#import "C2CPConfirmOrderViewController.h"
#import "UIColor+DZExtension.h"
#import "C2CPaymentViewController.h"
#import "SelectReceiveMethodViewController.h"
#import "C2CCancelOrderViewController.h"
#import "C2CPConfirmOrderSelectMethodPopView.h"
#import "C2COrderDetailViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "C2CUserDetailViewController.h"
#import "UIViewController+Extension.h"
#import "WebSocketManager+HandleMessage.h"
#import "WCDBManager+ChatList.h"
#import "C2CPaymentMethodTableViewCell.h"
#import "C2CMineViewController.h"
#import "PopupView.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "C2COssWrapper.h"

@interface C2CPConfirmOrderViewController ()<WebSocketManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *payTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIView *lb1;
@property (weak, nonatomic) IBOutlet UIView *lb2;
@property (weak, nonatomic) IBOutlet UIView *lb3;
@property (weak, nonatomic) IBOutlet UIView *lb4;
@property (weak, nonatomic) IBOutlet UIView *sp1;
@property (weak, nonatomic) IBOutlet UIView *lb5;
@property (weak, nonatomic) IBOutlet UIView *sp2;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//联系卖家
@property (weak, nonatomic) IBOutlet UIControl *contactBgView;
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
@property (weak, nonatomic) IBOutlet UIView *contactRightView;

@property (weak, nonatomic) IBOutlet UILabel *tipsOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsTwoLabel;


@property (weak, nonatomic) IBOutlet UILabel *saleCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
//总额
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *totalAmountImgView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

//价格
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *buyCurrencyView;
@property (weak, nonatomic) IBOutlet UIView *tickView;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priceImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *duplicateButton;

@property (weak, nonatomic) IBOutlet UILabel *payWayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIView *branchBgView;
@property (weak, nonatomic) IBOutlet UIView *bankBgView;

//交易条款
@property (weak, nonatomic) IBOutlet UIView *exchangeProvisionBgContentView;

///交易条款的title
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionTitleLabel;
@property (weak, nonatomic) IBOutlet UIControl *exchangeProvisionBgView;
///交易条款的内容
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionLabel;
///交易条款的内容
@property (weak, nonatomic) IBOutlet UIImageView *exchangeProvisionImgView;
@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

///银行卡
@property (weak, nonatomic) IBOutlet UIStackView *bankCardBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
///支付宝
@property (weak, nonatomic) IBOutlet UIStackView *alipayBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
///微信
@property (weak, nonatomic) IBOutlet UIStackView *weixinBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;

@property(nonatomic, assign) NSInteger payCancelTime;

@property (weak, nonatomic) IBOutlet UILabel *payTipLab;
@property (weak, nonatomic) IBOutlet UILabel *payWayLbl;
@property (weak, nonatomic) IBOutlet UIButton *nameCopyBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *accountNoDataPasteBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLbl;
@property (weak, nonatomic) IBOutlet UIButton *bankNoPasteDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *branchTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveQrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiveQrCodeImgView;
@property (weak, nonatomic) IBOutlet UIView *receiveMoneyBgView;
@property (weak, nonatomic) IBOutlet UIButton *accountBranchPasteDataButton;
@property (weak, nonatomic) IBOutlet UIView *payWayColorLine;
@property (nonatomic, strong) C2CPConfirmOrderSelectMethodPopView *methodPopView;
@property (weak, nonatomic) IBOutlet UILabel *stepOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *payWaySelectedLbl;
@property (weak, nonatomic) IBOutlet UILabel *minePaymentMethodTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *minePayWaySelectedLbl;
@property (nonatomic, strong) C2CPaymentMethodInfo *methodInfo;
@property (nonatomic, strong) C2CPaymentMethodInfo *minePaymentMethodInfo;
@property (weak, nonatomic) IBOutlet UILabel *mineNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mineNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mineNameCopyBtn;
@property (weak, nonatomic) IBOutlet UILabel *mineAccountTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *mineAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *mineaccountNoDataPasteBtn;
@property (weak, nonatomic) IBOutlet UILabel *mineBankTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mineBankLabel;
@property (weak, nonatomic) IBOutlet UIButton *minebankNoPasteDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *mineBranchTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *mineBranchLabel;
@property (weak, nonatomic) IBOutlet UIButton *mineAccountBranchPasteDataButton;
@property (weak, nonatomic) IBOutlet UILabel *mineReceiveQrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mineReceiveQrCodeImgView;
@property (weak, nonatomic) IBOutlet UIView *payMethdTypeView;
@property (weak, nonatomic) IBOutlet UIView *mineReceiveMoneyBgView;
@property (weak, nonatomic) IBOutlet UIView *mineBranchBgView;
@property (weak, nonatomic) IBOutlet UIView *mineBankBgView;
@property (weak, nonatomic) IBOutlet UILabel *minePaymentSelectLabel;
@property (weak, nonatomic) IBOutlet UIView *payWayView;
@property (nonatomic, assign) BOOL isBuyer;
@property (weak, nonatomic) IBOutlet UILabel *transferAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferAmountValue;
@property (nonatomic, strong) NSArray<C2CPaymentMethodInfo*> *minePaymentMethods;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *uploadBgView;
@property (weak, nonatomic) IBOutlet UIView *successBgView;
@property (weak, nonatomic) IBOutlet UILabel *transcrptionLabel;
@property(nonatomic, copy) NSString *qrCodeUrl;
@property (assign, nonatomic) BOOL uploadButtonSelected;
@end

@implementation C2CPConfirmOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"C2COptionalSaleViewController"]];
    [self checkHaveUnreadMsg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkHaveUnreadMsg) name:kC2COrderNotification object:nil];
    self.view.backgroundColor = UIColorBg243Color;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [self.receiveQrCodeImgView addGestureRecognizer:tapGestureRecognizer];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UITapGestureRecognizer *tapGesturePayway = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePayWayTap:)];
    [self.payMethdTypeView addGestureRecognizer:tapGesture];
    [self.payWayView addGestureRecognizer:tapGesturePayway];
    self.payMethdTypeView.userInteractionEnabled = YES;
    self.payWayView.userInteractionEnabled = YES;
//    "C2COptionalSaleViewControllerCountTitleLabel"="数量";
//    "C2COptionalSaleViewControllerTotalAmountTitleLabel"="总额";
//    "C2CConfirmReceiptMoneyViewControllerPriceTitleLabel"="价格";
//    "C2CConfirmReceiptMoneyViewControllerOrderIdTitleLabel"="订单号";
    self.countTitleLabel.text = @"C2COptionalSaleViewControllerCountTitleLabel".icanlocalized;
    self.totalAmountTitleLabel.text = @"C2COptionalSaleViewControllerTotalAmountTitleLabel".icanlocalized;
    self.priceTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerPriceTitleLabel".icanlocalized;
    self.orderIdTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerOrderIdTitleLabel".icanlocalized;
    
    self.title = @"C2CPConfirmOrderViewControllerTitle".icanlocalized;
    self.payTipsLabel.text = @"C2CPaymentViewControllerPayTipsLabel".icanlocalized;
    self.timeTipsLabel.text = @"C2CPaymentViewControllerTimeTipsLabel".icanlocalized;
    self.relationLabel.text = @"C2CPaymentViewControllerRelationLabel".icanlocalized;
    self.tipsOneLabel.text = @"C2CPConfirmOrderViewControllerTipsOneLabel".icanlocalized;
    self.tipsTwoLabel.text = @"C2CPConfirmOrderViewControllerTipsTwoLabel".icanlocalized;
    self.saleCurrencyLabel.text = @"C2CPConfirmOrderViewControllerSaleCurrencyLabel".icanlocalized;
    self.payWayTitleLabel.text = @"C2CPConfirmOrderViewControllerPayWayTitleLabel".icanlocalized;
    NSString *termsLabelStr = [NSString stringWithFormat:@"%@ %@", @"C2CConfirmReceiptMoneyViewControllerExchangeProvisionTitleLabel".icanlocalized, @"*"];
    NSMutableAttributedString *atrributedTxt = [[NSMutableAttributedString alloc] initWithString:termsLabelStr];
    [atrributedTxt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[termsLabelStr rangeOfString:@"*"]];
    self.exchangeProvisionTitleLabel.attributedText = atrributedTxt;
    [self.complaintButton setTitle:@"C2CPConfirmOrderViewControllerComplaintButton".icanlocalized forState:UIControlStateNormal];
    self.paymentMethodTitleLbl.text = @"SelectPayWayViewController.tipsLabel".icanlocalized;
    self.minePaymentMethodTitleLbl.text = @"SelectPayWayViewController.tipsLabel".icanlocalized;
    [self.sureButton setTitle:@"C2CPaymentViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    [self.complaintButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    self.bankLabel.text = @"C2CBankCard".icanlocalized;
    self.alipayLabel.text = @"C2CAlipay".icanlocalized;
    self.weixinLabel.text = @"C2CWeChat".icanlocalized;
    self.payTipLab.text = @"C2CPConfirmOrderTips".icanlocalized;
    self.transferAmountLabel.text = @"TransferAmount".icanlocalized;
    self.minePaymentSelectLabel.text = @"C2CPConfirmOrderViewControllerPayWayTitleLabel".icanlocalized;
    [self starTimer];
    [self getC2CUserInfo];
    [self setData];
    [self getMinePaymentMethodRequest];
//    self.timeTipsLabel.text = @"C2CPaymentViewControllerTimeTipsLabel".icanlocalized;
//    self.relationLabel.text = @"C2CPaymentViewControllerRelationLabel".icanlocalized;
    self.stepOneLabel.text = @"C2CPaymentViewControllerStepOneLabel".icanlocalized;
    self.stepTwoLabel.text = @"C2CPaymentViewControllerStepTwoLabel".icanlocalized;
    self.nameTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerNameTitleLabel".icanlocalized;
    self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
    self.branchTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBranchTitleLabel".icanlocalized;
    self.mineNameTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerNameTitleLabel".icanlocalized;
    self.mineBankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
    self.mineBranchTitleLbl.text = @"C2CConfirmReceiptMoneyViewControllerBranchTitleLabel".icanlocalized;
    self.transcrptionLabel.text = @"Upload a transaction proof".icanlocalized;
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.legalTender];
    self.transferAmountValue.text = [NSString stringWithFormat:@"%@%.2f",info.symbol,self.orderInfo.totalCount.floatValue];
    self.methodInfo = self.adverInfo.paymentMethods[0];
    NSArray * nameItems = [self.adverInfo.paymentMethods[0].name componentsSeparatedByString:@" "];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nameItems.lastObject,nameItems.firstObject];
    if(self.adverInfo.paymentMethods[0].account){
        self.accountLabel.text = self.adverInfo.paymentMethods[0].account;
        self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
    }else{
        self.accountLabel.text = self.adverInfo.paymentMethods[0].mobile;
        self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
    }
    if ([self.adverInfo.paymentMethods[0].paymentMethodType isEqualToString:@"BankTransfer"]) {
        self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CBankCard".icanlocalized];
        self.payWaySelectedLbl.text = @"C2CBankCard".icanlocalized;
        self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0XED9E15);
        self.receiveMoneyBgView.hidden = YES;
        if (self.adverInfo.paymentMethods[0].bankName.length>0) {
            self.bankBgView.hidden = NO;
            self.bankLabel.text = self.adverInfo.paymentMethods[0].bankName;
        }else{
            self.bankBgView.hidden = YES;
        }
        if (self.adverInfo.paymentMethods[0].branch.length>0) {
            self.branchBgView.hidden = NO;
            self.branchLabel.text = self.adverInfo.paymentMethods[0].branch;
        }else{
            self.branchBgView.hidden = YES;
        }
    }
    if ([self.adverInfo.paymentMethods[0].paymentMethodType isEqualToString:@"AliPay"]) {
        self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CAlipay".icanlocalized];
        self.payWaySelectedLbl.text = @"C2CAlipay".icanlocalized;
        self.bankBgView.hidden = YES;
        self.branchBgView.hidden = YES;
        if (self.adverInfo.paymentMethods[0].qrCode) {
            self.receiveMoneyBgView.hidden = NO;
            [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.adverInfo.paymentMethods[0].qrCode]];
        }
    }
    if ([self.adverInfo.paymentMethods[0].paymentMethodType isEqualToString:@"Wechat"]) {
        self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CWeChat".icanlocalized];
        self.payWaySelectedLbl.text = @"C2CWeChat".icanlocalized;
        self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0X3CB617);
        self.branchBgView.hidden = YES;
        self.bankBgView.hidden = YES;
        if (self.adverInfo.paymentMethods[0].qrCode) {
            self.receiveMoneyBgView.hidden = NO;
            [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.adverInfo.paymentMethods[0].qrCode]];
        }
    }
    if ([self.adverInfo.paymentMethods[0].paymentMethodType isEqualToString:@"Cash"]) {
        self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"Cash".icanlocalized];
        self.payWaySelectedLbl.text = @"Cash".icanlocalized;
        self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0X1D80F3);
        if(self.adverInfo.paymentMethods[0].account){
            self.accountLabel.text = self.adverInfo.paymentMethods[0].account;
            self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
        }else{
            self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
            NSString *mobile = self.adverInfo.paymentMethods[0].mobile;
            for (int i = mobile.length/2; i < mobile.length ; i++) {

                if (![[mobile substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                    NSRange range = NSMakeRange(i, 1);
                    mobile = [mobile stringByReplacingCharactersInRange:range withString:@"*"];
                }
            }
            self.accountLabel.text = mobile;
        }
        if(self.adverInfo.paymentMethods[0].bankName){
            self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
            self.bankLabel.text = self.adverInfo.paymentMethods[0].bankName;
        }else{
            self.bankTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
            NSString *address = self.adverInfo.paymentMethods[0].address;
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
        self.nameCopyBtn.hidden = YES;
        self.accountNoDataPasteBtn.hidden = YES;
        self.bankNoPasteDataBtn.hidden = YES;
        self.accountBranchPasteDataButton.hidden = YES;
    }
    if(self.fromTopup == YES){
        self.blueView.hidden = YES;
        self.buyCurrencyView.hidden = YES;
        self.tickView.hidden = YES;
    }
}

- (void)imageViewTapped:(UITapGestureRecognizer *)sender {
    PopupView *view = [[NSBundle mainBundle]loadNibNamed:@"PopupView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [view.imageView sd_setImageWithURL:[NSURL URLWithString:self.adverInfo.paymentMethods[0].qrCode]];
//    view.qrCodeViewTyep=QRCodeViewTyep_user;
    [view showQRCodeView];
}

-(void)setData{
    
    CGRect realRect = self.contactBgView.bounds;
//    CAGradientLayer *gradientLayer = [UIColor caGradientLayerWithFrame:realRect cornerRadius:0 colors:@[(__bridge id)UIColorMake(156, 196, 243).CGColor, (__bridge id)UIColorMake(200, 220, 243).CGColor, (__bridge id)UIColorMake(243, 243, 243).CGColor] locations:@[@0.0,@0.6,@1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
//    [self.contactBgView.layer insertSublayer:gradientLayer atIndex:0];
//    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:realRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = realRect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.contactBgView.layer.mask = maskLayer;
    self.contactBgView.backgroundColor = UIColorMakeHEXCOLOR(0Xcce1fa);
    //如果购买的人和自己是同一个人
    if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) {
        self.saleCurrencyLabel.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
        self.saleCurrencyLabel.textColor = UIColorThemeMainColor;
    }else{
        self.saleCurrencyLabel.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
        self.saleCurrencyLabel.textColor = UIColorMake(239, 51, 79);
    }
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.legalTender];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@%.2f",info.symbol,self.orderInfo.totalCount.floatValue];
    self.priceLabel.text =[NSString stringWithFormat:@"%@%.2f",info.symbol,self.orderInfo.unitPrice.floatValue]; ;
    self.countLabel.text = [NSString stringWithFormat:@"%.6f %@",self.orderInfo.quantity.floatValue,self.orderInfo.virtualCurrency];
    self.orderIdLabel.text = self.orderInfo.orderId;
    CurrencyInfo * virtualinfo =  [C2CUserManager.shared getCurrecyInfoWithCode:self.orderInfo.virtualCurrency];
    [self.currencyImageView setImageWithString:virtualinfo.icon placeholder:nil];
    ///订单是出售的 那么支付方式选择订单详情的支付方式
    if ([self.orderInfo.transactionType isEqualToString:@"Sell"]) {
        if ([self.orderInfo.sellPaymentMethod.paymentMethodType isEqualToString:@"Wechat"]) {
            self.weixinBgStackView.hidden = NO;
        }
        if ([self.orderInfo.sellPaymentMethod.paymentMethodType isEqualToString:@"AliPay"]) {
            self.alipayBgStackView.hidden = NO;
        }
        if ([self.orderInfo.sellPaymentMethod.paymentMethodType isEqualToString:@"BankTransfer"]) {
            self.bankCardBgStackView.hidden = NO;
        }
    }else{
        for (C2CPaymentMethodInfo*payInfo in self.adverInfo.paymentMethods) {
            if ([payInfo.paymentMethodType isEqualToString:@"Wechat"]) {
                self.weixinBgStackView.hidden = NO;
            }
            if ([payInfo.paymentMethodType isEqualToString:@"AliPay"]) {
                self.alipayBgStackView.hidden = NO;
            }
            if ([payInfo.paymentMethodType isEqualToString:@"BankTransfer"]) {
                self.bankCardBgStackView.hidden = NO;
            }
        }
    }
    if (self.orderInfo.transactionTerms) {
        self.exchangeProvisionBgContentView.hidden = NO;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }else{
        self.exchangeProvisionBgContentView.hidden = YES;
        self.exchangeProvisionLabel.text = self.orderInfo.transactionTerms;
    }
    self.currencyLabel.text = self.orderInfo.virtualCurrency;
    [self.unReadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    [self checkHaveUnreadMsg];
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
                    self.timeLabel.hidden = YES;
                    self.timeTipsLabel.hidden = YES;
                    //设置按钮的样式
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
}
//联系卖家
- (IBAction)relationAction { 
    self.haveUnreadMsg = NO;
    UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:[NSString stringWithFormat:@"%@",self.orderInfo.sellUser.uid],kchatType:UserChat,kauthorityType:AuthorityType_c2c,kC2CUserId:self.orderInfo.sellUser.userId,kC2COrderId:self.orderInfo.orderId}];
     [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)iconAction {
    C2CUserDetailViewController * vc = [C2CUserDetailViewController new];
    vc.userId = self.orderInfo.sellUser.userId.integerValue;
    [[AppDelegate shared]pushViewController:vc animated:YES];
}

-(IBAction)copyIdAction{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.orderInfo.orderId;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
    
}
-(IBAction)openExchangeProvisionAction{
    
    self.exchangeProvisionBgView.hidden = !self.exchangeProvisionBgView.hidden;
    self.exchangeProvisionImgView.image = self.exchangeProvisionBgView.hidden?UIImageMake(@"icon_c2c_arrow_up"):UIImageMake(@"icon_c2c_arrow_down");
    
    
}
//取消订单
-(IBAction)complaintAction{
    C2CCancelOrderViewController * vc = [C2CCancelOrderViewController new];
    vc.orderInfo = self.orderInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
//去付款
-(IBAction)sureAction{
    C2CConfirmOrderPayV2Request * request = [C2CConfirmOrderPayV2Request request];
    if (![NSString isEmptyString:self.qrCodeUrl]) {
        request.certificate = self.qrCodeUrl;
        request.parameters = [request mj_JSONObject];
    }
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/adOrder/pay/v2/%ld/%@",(long)self.orderInfo.adOrderId,self.methodInfo.paymentMethodId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
        C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
        vc.orderInfo = response;
        [self.navigationController pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil userInfo:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
/*
 获取用户信息
 GET
 /api/user/{id}
 */
-(void)getC2CUserInfo{
    C2CGetUserInfoRequest * request = [C2CGetUserInfoRequest request];
    request.pathUrlString =  [request.baseUrlString stringByAppendingFormat:@"/api/user/%ld",self.orderInfo.sellUserId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        [self.iconImageView setImageWithString:response.headImgUrl placeholder:BoyDefault];
        self.userNameLabel.text = response.nickname;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(C2CPConfirmOrderSelectMethodPopView *)methodPopView{
    if (!_methodPopView) {
        _methodPopView = [[NSBundle mainBundle]loadNibNamed:@"C2CPConfirmOrderSelectMethodPopView" owner:self options:nil].firstObject;
        _methodPopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _methodPopView.minePaymentMethods = self.minePaymentMethods;
        _methodPopView.adverDetailInfo = self.adverInfo;
        _methodPopView.orderInfo = self.orderInfo;
        @weakify(self);
        _methodPopView.selectBlock = ^(C2CPaymentMethodInfo * _Nonnull info) {
            @strongify(self);
            self.methodInfo = info;
            if(!self.isBuyer){
                NSArray * nameItems = [info.name componentsSeparatedByString:@" "];
                self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nameItems.lastObject,nameItems.firstObject];
                if(info.account){
                    self.accountLabel.text = info.account;
                    self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
                }else{
                    self.accountLabel.text = info.mobile;
                    self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
                }
                if ([info.paymentMethodType isEqualToString:@"BankTransfer"]) {
                    self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CBankCard".icanlocalized];
                    self.payWaySelectedLbl.text = @"C2CBankCard".icanlocalized;
                    self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0XED9E15);
                    self.receiveMoneyBgView.hidden = YES;
                    if (info.bankName.length>0) {
                        self.bankBgView.hidden = NO;
                        self.bankLabel.text = info.bankName;
                    }else{
                        self.bankBgView.hidden = YES;
                    }
                    if (info.branch.length>0) {
                        self.branchBgView.hidden = NO;
                        self.branchLabel.text = info.branch;
                    }else{
                        self.branchBgView.hidden = YES;
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"AliPay"]) {
                    self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CAlipay".icanlocalized];
                    self.payWaySelectedLbl.text = @"C2CAlipay".icanlocalized;
                    self.bankBgView.hidden = YES;
                    self.branchBgView.hidden = YES;
                    if (info.qrCode) {
                        self.receiveMoneyBgView.hidden = NO;
                        [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:info.qrCode]];
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"Wechat"]) {
                    self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"C2CWeChat".icanlocalized];
                    self.payWaySelectedLbl.text = @"C2CWeChat".icanlocalized;
                    self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0X3CB617);
                    self.branchBgView.hidden = YES;
                    self.bankBgView.hidden = YES;
                    if (info.qrCode) {
                        self.receiveMoneyBgView.hidden = NO;
                        [self.receiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:info.qrCode]];
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"Cash"]) {
                    self.payWayLabel.text = [NSString stringWithFormat:@"%@", @"Cash".icanlocalized];
                    self.payWaySelectedLbl.text = @"Cash".icanlocalized;
                    self.payWayColorLine.backgroundColor = UIColorMakeHEXCOLOR(0X1D80F3);
                    if(info.account){
                        self.accountLabel.text = info.account;
                        self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
                    }else{
                        self.accountTitleLabel.text = @"MobileNumber".icanlocalized;
                        NSString *mobile = info.mobile;
                        for (int i = mobile.length/2; i < mobile.length ; i++) {

                            if (![[mobile substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                                NSRange range = NSMakeRange(i, 1);
                                mobile = [mobile stringByReplacingCharactersInRange:range withString:@"*"];
                            }
                        }
                        self.accountLabel.text = mobile;
                    }
                    if(info.bankName){
                        self.bankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
                        self.bankLabel.text = info.bankName;
                    }else{
                        self.bankTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
                        NSString *address = info.address;
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
                    self.nameCopyBtn.hidden = YES;
                    self.accountNoDataPasteBtn.hidden = YES;
                    self.bankNoPasteDataBtn.hidden = YES;
                    self.accountBranchPasteDataButton.hidden = YES;

                }
            }else{
                self.minePaymentMethodInfo = info;
                NSArray * myNameItems = [info.name componentsSeparatedByString:@" "];
                self.mineNameLabel.text = [NSString stringWithFormat:@"%@ %@",myNameItems.lastObject,myNameItems.firstObject];
                if(info.account){
                    self.mineAccountLabel.text = info.account;
                    self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
                }else{
                    self.mineAccountLabel.text = info.mobile;
                    self.mineAccountTitleLbl.text = @"MobileNumber".icanlocalized;
                }
                if ([info.paymentMethodType isEqualToString:@"BankTransfer"]) {
                    self.minePayWaySelectedLbl.text = @"C2CBankCard".icanlocalized;
                    self.mineReceiveMoneyBgView.hidden = YES;
                    if (info.bankName.length>0) {
                        self.mineBankBgView.hidden = NO;
                        self.mineBankLabel.text = info.bankName;
                    }else{
                        self.bankBgView.hidden = YES;
                    }
                    if (info.branch.length>0) {
                        self.mineBranchBgView.hidden = NO;
                        self.mineBranchLabel.text = info.branch;
                    }else{
                        self.mineBranchBgView.hidden = YES;
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"AliPay"]) {
                    self.minePayWaySelectedLbl.text = @"C2CAlipay".icanlocalized;
                    self.mineBankBgView.hidden = YES;
                    self.mineBranchBgView.hidden = YES;
                    if (info.qrCode) {
                        self.mineReceiveMoneyBgView.hidden = NO;
                        [self.mineReceiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:info.qrCode]];
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"Wechat"]) {
                    self.minePayWaySelectedLbl.text = @"C2CWeChat".icanlocalized;
                    self.mineBranchBgView.hidden = YES;
                    self.mineBankBgView.hidden = YES;
                    if (info.qrCode) {
                        self.mineReceiveMoneyBgView.hidden = NO;
                        [self.mineReceiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:info.qrCode]];
                    }
                }
                if ([info.paymentMethodType isEqualToString:@"Cash"]) {
                    self.minePayWaySelectedLbl.text = @"Cash".icanlocalized;
                    if(info.account){
                        self.mineAccountLabel.text = info.account;
                        self.mineAccountTitleLbl.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
                    }else{
                        self.mineAccountTitleLbl.text = @"MobileNumber".icanlocalized;
                        NSString *mobile = info.mobile;
                        for (int i = mobile.length/2; i < mobile.length ; i++) {

                            if (![[mobile substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                                NSRange range = NSMakeRange(i, 1);
                                mobile = [mobile stringByReplacingCharactersInRange:range withString:@"*"];
                            }
                        }
                        self.mineAccountLabel.text = mobile;
                    }
                    if(info.bankName){
                        self.mineBankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
                        self.mineBankLabel.text = info.bankName;
                    }else{
                        self.mineBankTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
                        NSString *address = info.address;
                        for (int i = 0; i < address.length / 2 ; i++) {
                            if (![[address substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                                NSRange range = NSMakeRange(i, 1);
                                address = [address stringByReplacingCharactersInRange:range withString:@"*"];
                            }
                        }
                        self.mineBankLabel.text = address;
                    }
                    self.mineBranchBgView.hidden = YES;
                    self.mineReceiveMoneyBgView.hidden = YES;
                    self.mineNameCopyBtn.hidden = YES;
                    self.mineaccountNoDataPasteBtn.hidden = YES;
                    self.minebankNoPasteDataBtn.hidden = YES;
                    self.mineAccountBranchPasteDataButton.hidden = YES;
                }
                
            }
        };
        
    }
    return _methodPopView;
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
- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if(self.minePaymentMethods.count == 0){
            SelectReceiveMethodViewController * vc = [[SelectReceiveMethodViewController alloc]init];
            vc.adverDetailInfo = self.adverInfo;
            vc.type = SelectReceiveMethodType_Mine;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            self.isBuyer = YES;
            [self.methodPopView showView:YES];
        }
    }
}

- (void)handlePayWayTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.isBuyer = NO;
        [self.methodPopView showView:NO];
    }
}
- (IBAction)payWaySelectAction:(id)sender {
    self.isBuyer = NO;
    [self.methodPopView showView:NO];
}

- (IBAction)minePayWaySelectAction:(id)sender {
    if(self.minePaymentMethods.count == 0){
        SelectReceiveMethodViewController * vc = [[SelectReceiveMethodViewController alloc]init];
        vc.adverDetailInfo = self.adverInfo;
        vc.type = SelectReceiveMethodType_Mine;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.isBuyer = YES;
        [self.methodPopView showView:YES];
    }
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

-(void)getMinePaymentMethodRequest{
    C2CGetPaymentMethodRequest * request = [C2CGetPaymentMethodRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CPaymentMethodInfo class] success:^(NSArray<C2CPaymentMethodInfo*>* response) {
        if(response.count == 0){
            self.minePayWaySelectedLbl.text = @"Add payment method".icanlocalized;
            self.lb1.hidden = YES;
            self.lb2.hidden = YES;
            self.lb3.hidden = YES;
            self.lb4.hidden = YES;
            self.lb5.hidden = YES;
            self.sp1.hidden = YES;
            self.sp2.hidden = YES;
        }else{
            self.minePaymentMethods = response;
            self.minePayWaySelectedLbl.text = @"Select payment method".icanlocalized;
            self.minePaymentMethodInfo = self.minePaymentMethods[0];
            NSArray * myNameItems = [self.minePaymentMethodInfo.name componentsSeparatedByString:@" "];
            self.mineNameLabel.text = [NSString stringWithFormat:@"%@ %@",myNameItems.lastObject,myNameItems.firstObject];
            if(self.minePaymentMethodInfo.account){
                self.mineAccountLabel.text = self.minePaymentMethodInfo.account;
                self.accountTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
            }else{
                self.mineAccountLabel.text = self.minePaymentMethodInfo.mobile;
                self.mineAccountTitleLbl.text = @"MobileNumber".icanlocalized;
            }
            if ([self.minePaymentMethodInfo.paymentMethodType isEqualToString:@"BankTransfer"]) {
                self.minePayWaySelectedLbl.text = @"C2CBankCard".icanlocalized;
                self.mineReceiveMoneyBgView.hidden = YES;
                if (self.minePaymentMethodInfo.bankName.length>0) {
                    self.mineBankBgView.hidden = NO;
                    self.mineBankLabel.text = self.minePaymentMethodInfo.bankName;
                }else{
                    self.bankBgView.hidden = YES;
                }
                if (self.minePaymentMethodInfo.branch.length>0) {
                    self.mineBranchBgView.hidden = NO;
                    self.mineBranchLabel.text = self.minePaymentMethodInfo.branch;
                }else{
                    self.mineBranchBgView.hidden = YES;
                }
            }
            if ([self.minePaymentMethodInfo.paymentMethodType isEqualToString:@"AliPay"]) {
                self.minePayWaySelectedLbl.text = @"C2CAlipay".icanlocalized;
                self.mineBankBgView.hidden = YES;
                self.mineBranchBgView.hidden = YES;
                if (self.minePaymentMethodInfo.qrCode) {
                    self.mineReceiveMoneyBgView.hidden = NO;
                    [self.mineReceiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.minePaymentMethodInfo.qrCode]];
                }
            }
            if ([self.minePaymentMethodInfo.paymentMethodType isEqualToString:@"Wechat"]) {
                self.minePayWaySelectedLbl.text = @"C2CWeChat".icanlocalized;
                self.mineBranchBgView.hidden = YES;
                self.mineBankBgView.hidden = YES;
                if (self.minePaymentMethodInfo.qrCode) {
                    self.mineReceiveMoneyBgView.hidden = NO;
                    [self.mineReceiveQrCodeImgView sd_setImageWithURL:[NSURL URLWithString:self.minePaymentMethodInfo.qrCode]];
                }
            }
            if ([self.minePaymentMethodInfo.paymentMethodType isEqualToString:@"Cash"]) {
                self.minePayWaySelectedLbl.text = @"Cash".icanlocalized;
                if(self.minePaymentMethodInfo.account){
                    self.mineAccountLabel.text = self.minePaymentMethodInfo.account;
                    self.mineAccountTitleLbl.text = @"C2CConfirmReceiptMoneyViewControllerAccountTitleLabel".icanlocalized;
                }else{
                    self.mineAccountTitleLbl.text = @"MobileNumber".icanlocalized;
                    NSString *mobile = self.minePaymentMethodInfo.mobile;
                    for (int i = mobile.length/2; i < mobile.length ; i++) {

                        if (![[mobile substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                            NSRange range = NSMakeRange(i, 1);
                            mobile = [mobile stringByReplacingCharactersInRange:range withString:@"*"];
                        }
                    }
                    self.mineAccountLabel.text = mobile;
                }
                if(self.minePaymentMethodInfo.bankName){
                    self.mineBankTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerBankTitleLabel".icanlocalized;
                    self.mineBankLabel.text = self.minePaymentMethodInfo.bankName;
                }else{
                    self.mineBankTitleLabel.text = @"C2CWithdrawAddress".icanlocalized;
                    NSString *address = self.minePaymentMethodInfo.address;
                    for (int i = 0; i < address.length / 2 ; i++) {
                        if (![[address substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                            NSRange range = NSMakeRange(i, 1);
                            address = [address stringByReplacingCharactersInRange:range withString:@"*"];
                        }
                    }
                    self.mineBankLabel.text = address;
                }
                self.mineBranchBgView.hidden = YES;
                self.mineReceiveMoneyBgView.hidden = YES;
                self.mineNameCopyBtn.hidden = YES;
                self.mineaccountNoDataPasteBtn.hidden = YES;
                self.minebankNoPasteDataBtn.hidden = YES;
                self.mineAccountBranchPasteDataButton.hidden = YES;
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
- (IBAction)uploadAction:(id)sender {
    self.uploadButtonSelected = !self.uploadButtonSelected;
    if (self.uploadButtonSelected) {
        [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
            [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:NO pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
                [self setHeadPicWithImage:photos.firstObject];
            } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        } failure:^{
            self.successBgView.hidden = YES;
        }];
    } else {
        self.qrCodeUrl = @"";
        self.successBgView.hidden = YES;
        self.uploadBgView.image = [UIImage imageNamed:@"c2c_upload"];
    }
}
-(void)setHeadPicWithImage:(UIImage*)image{
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[C2COssWrapper shared]uploadImage:image successHandler:^(NSString * _Nonnull imgModels) {
        self.qrCodeUrl = imgModels;
        self.successBgView.hidden = NO;
        self.uploadBgView.image = [UIImage imageNamed:@"c2c_cancel"];
        [QMUITips hideAllTips];
    }];
}

@end

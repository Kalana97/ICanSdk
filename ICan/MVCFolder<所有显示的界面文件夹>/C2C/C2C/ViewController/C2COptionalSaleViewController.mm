//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/11/2021
 - File name:  C2CPublishAdvertFirstStepViewController.m
 - Description:
 - Function List:
 */


#import "C2COptionalSaleViewController.h"
#import "SelectReceiveMethodViewController.h"
#import "C2CPConfirmOrderViewController.h"
#import "C2CUserDetailViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "WCDBManager+ChatModel.h"
#import "ChatUtil.h"
#import "DZUITextField.h"
#import "C2COrderDetailViewController.h"
#import "DecimalKeyboard.h"
@interface C2COptionalSaleViewController ()<UIScrollViewDelegate>
/** 单价 */
@property (weak, nonatomic) IBOutlet UILabel *unitPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
/** 刷新 */
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;


@property (weak, nonatomic) IBOutlet UILabel *limitCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel;

@property (weak, nonatomic) IBOutlet UIView *bgCorView;
//头部的按金额出售或者按数量出售
@property (weak, nonatomic) IBOutlet UIControl *buyBgView;
@property (weak, nonatomic) IBOutlet UILabel *amountSaleTitleLabel;

@property (weak, nonatomic) IBOutlet UIControl *saleView;
@property (weak, nonatomic) IBOutlet UILabel *countSaleTitleLabel;
//按金额出售时候 的单位
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet DZUITextField *amountTextField;
///货币的code
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIView *amountBgView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
/// 选择收款方式的间隔
@property (weak, nonatomic) IBOutlet UIView *selectReceiVeLineView;
/// 选择收款方式的背景
@property (weak, nonatomic) IBOutlet UIControl *selectReceiveBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *selectReceiveTextField;
//数量
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//总额
@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/// 交易前 请仔细阅读下方条款
@property (weak, nonatomic) IBOutlet UIControl *readTipsBgCon;
@property (weak, nonatomic) IBOutlet UILabel *readTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *readTipLineView;

//交易信息
@property (weak, nonatomic) IBOutlet UILabel *tradeInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nicknameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *payWayTitleLabel;

/// 交易条款背景
@property (weak, nonatomic) IBOutlet UIStackView *exchangeProvisionBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionTitleLabel;
/// 交易条款内容
@property (weak, nonatomic) IBOutlet UILabel *exchangeProvisionLabel;
@property (nonatomic, strong) C2CPaymentMethodInfo *payMethodInfo;
/** 是否是按照数量出售 */
@property(nonatomic, assign) BOOL isCountBuy;
/** 金额购买或者出售的大金额 */
@property(nonatomic, strong) NSDecimalNumber* minAmountPrice;
/** 金额购买或者出售的大金额 */
@property(nonatomic, strong) NSDecimalNumber* maxAmountPrice;

/** 数量购买或者出售的最小数量 */
@property(nonatomic, strong) NSDecimalNumber* minCount;
/** 数量购买或者出售的最大数量 */
@property(nonatomic, strong) NSDecimalNumber* maxCount;
/** 广告的剩余数量 */
@property(nonatomic, strong) NSDecimalNumber* surplusCount;
/** 按照金额出售时候的输入框数据 */
@property(nonatomic, copy) NSString *amountTextFieldText;
@property (weak, nonatomic) IBOutlet UILabel *errorTipsLabel;

///银行卡
@property (weak, nonatomic) IBOutlet UIStackView *bankCardBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
///支付宝
@property (weak, nonatomic) IBOutlet UIStackView *alipayBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
///微信
@property (weak, nonatomic) IBOutlet UIStackView *weixinBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;

@property (weak, nonatomic) IBOutlet UIStackView *cashBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

///当前的资产
@property(nonatomic, strong) C2CBalanceListInfo *currencyBalanceListInfo;
/** 按照数量出售时候的输入框数据 */
@property(nonatomic, copy) NSString *countTextFieldText;
@property (nonatomic, strong) CurrencyInfo *currentCurrencyInfo;
///购买的金额
@property(nonatomic, strong) NSDecimalNumber *buyPrice;
///购买的数量
@property(nonatomic, strong) NSDecimalNumber *buyQuantity;
@property (weak, nonatomic) IBOutlet UIView *byFiatLineView;
@property (weak, nonatomic) IBOutlet UIView *byCryptLineView;
@end

@implementation C2COptionalSaleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
        for (UIView *subview1 in self.navigationController.navigationBar.subviews) {
            for (UIView *subview in subview1.subviews) {
                    if ([subview isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.image = [UIImage imageNamed:@"discover_bg"];
                        imageView.frame = CGRectMake(0, 0, subview.width, subview.height);
                        imageView.backgroundColor = UIColorThemeMainColor;
                        [subview addSubview:imageView];
                    }
            }
        }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    for (UIView *subview1 in self.navigationController.navigationBar.subviews) {
        for (UIView *subview in subview1.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                for (UIView *subview2 in subview.subviews) {
                    [subview2 removeFromSuperview];
                }
            }
        }
    }
}

- (UIColor *)navigationBarTintColor{
    return UIColorWhite;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.unitPriceTitleLabel.text = @"C2COptionalSaleViewControllerUnitPriceTitleLabel".icanlocalized;
    self.limitCountTitleLabel.text = @"C2COptionalSaleViewControllerLimitCountTitleLabel".icanlocalized;
    
    [IQKeyboardManager sharedManager].enable=YES;
    [self.allButton setTitle:@"C2COptionalSaleViewControllerAllButton".icanlocalized forState:UIControlStateNormal];
    self.amountTextField.placeholder = @"C2COptionalSaleViewControllerAmountTextFieldAmount".icanlocalized;
    self.selectReceiveTextField.placeholder = @"C2COptionalSaleViewControllerSelectReceiveTextField".icanlocalized;
    self.countTitleLabel.text = @"C2COptionalSaleViewControllerCountTitleLabel".icanlocalized;
    self.totalAmountTitleLabel.text = @"C2COptionalSaleViewControllerTotalAmountTitleLabel".icanlocalized;
    
    self.tradeInformationLabel.text = @"C2COptionalSaleViewControllerTradeInformationLabel".icanlocalized;
    self.payTimeTitleLabel.text = @"C2COptionalSaleViewControllerPayTimeTitleLabel".icanlocalized;
    self.nicknameTitleLabel.text = @"C2COptionalSaleViewControllerNicknameTitleLabel".icanlocalized;
    self.payWayTitleLabel.text = @"C2COptionalSaleViewControllerPayWayTitleLabel".icanlocalized;
    self.amountSaleTitleLabel.textColor = UIColor252730Color;
    self.countSaleTitleLabel.textColor = UIColor153Color;
    
    self.readTipsLabel.text = @"C2COptionalBuyViewControllerTipsLabel".icanlocalized;
    NSString *termsLabelStr = [NSString stringWithFormat:@"%@ %@", @"C2COptionalBuyViewControllerExchangeProvisionTitleLabel".icanlocalized, @"*"];
    NSMutableAttributedString *atrributedTxt = [[NSMutableAttributedString alloc] initWithString:termsLabelStr];
    [atrributedTxt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[termsLabelStr rangeOfString:@"*"]];
    self.exchangeProvisionTitleLabel.attributedText = atrributedTxt;
    self.bankLabel.text = @"C2CBankCard".icanlocalized;
    self.alipayLabel.text = @"C2CAlipay".icanlocalized;
    self.weixinLabel.text = @"C2CWeChat".icanlocalized;
    self.cashLabel.text = @"Cash".icanlocalized;
    self.currencyCodeLabel.hidden = YES;
    self.currencyCodeLabel.text = self.adverInfo.virtualCurrency;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    DecimalKeyboard *decimalKeyboard2 = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    [decimalKeyboard2 setTargetTextField:self.selectReceiveTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    decimalKeyboard2.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    self.selectReceiveTextField.inputView = decimalKeyboard2;
    if (self.isBuy) {
        NSString *titleString = [NSString stringWithFormat:@"%@ %@", @"C2COptionalBuyViewControllerNextButton".icanlocalized, self.adverInfo.virtualCurrency];
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.attributedText = attributedTitle;
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
        [self.nextButton setTitle:[NSString stringWithFormat:@"%@ %@",@"C2COptionalBuyViewControllerNextButton".icanlocalized,self.adverInfo.virtualCurrency] forState:UIControlStateNormal];
        [self getC2CAdverDetailInfo];
        self.amountSaleTitleLabel.text = @"C2COptionalSaleViewControllerAmountSaleTitleLabelBuy".icanlocalized;
        self.countSaleTitleLabel.text = @"C2COptionalSaleViewControllerCountSaleTitleLabelBuy".icanlocalized;
        self.selectReceiveBgView.hidden = YES;
        self.selectReceiVeLineView.hidden = YES;
        
        self.balanceLabel.hidden = YES;
    }else{
        self.balanceLabel.hidden = NO;
        [self getCurrencyRequest];
        NSString *titleString = [NSString stringWithFormat:@"%@ %@",@"C2COptionalSaleViewControllerNextButton".icanlocalized,self.adverInfo.virtualCurrency];
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.attributedText = attributedTitle;
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
        [self.nextButton setTitle:[NSString stringWithFormat:@"%@ %@",@"C2COptionalSaleViewControllerNextButton".icanlocalized,self.adverInfo.virtualCurrency] forState:UIControlStateNormal];
        self.readTipsBgCon.hidden = YES;
        self.amountSaleTitleLabel.text = @"C2COptionalSaleViewControllerAmountSaleTitleLabel".icanlocalized;
        self.countSaleTitleLabel.text = @"C2COptionalSaleViewControllerCountSaleTitleLabel".icanlocalized;
    }
    if (self.adverInfo.transactionTerms.length>0) {
        self.exchangeProvisionLabel.text = self.adverInfo.transactionTerms;
    }else{
        self.exchangeProvisionBgStackView.hidden = YES;
    }
    self.bgCorView.layer.cornerRadius = 5;
    self.bgCorView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.bgCorView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgCorView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgCorView.layer.shadowRadius = 5;
    [self.nextButton layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.currentCurrencyInfo =  [C2CUserManager.shared getCurrecyInfoWithCode:self.adverInfo.legalTender];
    [self setData];
    
    self.nextButton.enabled = NO;
    self.byCryptLineView.hidden = YES;
    if (!self.isBuy) {
        ///当前的虚拟资产
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"code == %@",self.adverInfo.virtualCurrency];
        NSArray *array = [C2CUserManager.shared.c2cBalanceListItems filteredArrayUsingPredicate:gpredicate];
        self.currencyBalanceListInfo = array.firstObject;
        if (self.currencyBalanceListInfo) {
            self.balanceLabel.text = [NSString stringWithFormat:@"%@:%@%@ ≈ %@%@",@"AvailableBalance".icanlocalized,[self.currencyBalanceListInfo.money calculateByNSRoundDownScale:2].currencyString,self.currencyBalanceListInfo.code,[[self.currencyBalanceListInfo.money decimalNumberByMultiplyingBy:self.adverInfo.fixedPrice.decimalNumber] calculateByNSRoundDownScale:2].currencyString,self.adverInfo.legalTender];
            
            
        }else{
            self.balanceLabel.text = [NSString stringWithFormat:@"%@:0.00%@",@"AvailableBalance".icanlocalized,self.adverInfo.virtualCurrency];
        }
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
///获取数据设置默认值
-(void)setData{
    ///设置单价
    self.unitPriceLabel.text =[NSString stringWithFormat:@"%@%@",self.currentCurrencyInfo.symbol,[[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber] calculateByNSRoundDownScale:2]];
    self.payTimeLabel.text = [NSString stringWithFormat:@"%ld%@",self.adverInfo.payCancelTime,@"minutes".icanlocalized];
    NSMutableAttributedString *nickNameLblTxt = [[NSMutableAttributedString alloc] initWithString:self.adverInfo.user.nickname attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    self.nicknameLabel.attributedText = nickNameLblTxt;
    //支付方式
    NSMutableString * supportPayWay = [[NSMutableString alloc]init];
    if (self.adverInfo.supportBankTransfer) {
        [supportPayWay appendFormat:@"%@",@"C2CBankCard".icanlocalized];
    }
    self.bankCardBgStackView.hidden = !self.adverInfo.supportBankTransfer;
    self.alipayBgStackView.hidden = !self.adverInfo.supportAliPay;
    self.weixinBgStackView.hidden = !self.adverInfo.supportWechat;
    self.cashBgStackView.hidden = !self.adverInfo.supportCash;
    ///货币
    CurrencyInfo * info = [C2CUserManager.shared getCurrecyInfoWithCode:self.adverInfo.legalTender];
    self.unitLabel.text = info.symbol;
    //设置默认值
    //"C2CMyAdvertisingListTableViewCellLimitLabel"="限额";
    //"C2COptionalSaleViewControllerLimitCountTitleLabel"="限量";
    //默认是限额
    self.limitCountTitleLabel.text = @"C2CMyAdvertisingListTableViewCellLimitLabel".icanlocalized;
    //得到广告的剩余数量 ///所有的金额都等到显示的时候 才去计算
    
    self.surplusCount = [self.adverInfo.count.decimalNumber decimalNumberBySubtracting:self.adverInfo.finishCount.decimalNumber];
    self.minAmountPrice = self.adverInfo.min.decimalNumber;
    self.maxAmountPrice = self.adverInfo.max.decimalNumber;
    //计算最小的数量
    self.minCount = [self.adverInfo.min.decimalNumber decimalNumberByDividingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
    self.maxCount = [self.adverInfo.max.decimalNumber decimalNumberByDividingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
    
    ///限额
    self.limitCountLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",self.currentCurrencyInfo.symbol,[self.minAmountPrice calculateByNSRoundDownScale:2].currencyString,self.currentCurrencyInfo.symbol,[self.maxAmountPrice calculateByNSRoundDownScale:2].currencyString];
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"0 %@",self.adverInfo.legalTender];
    self.countLabel.text = [NSString stringWithFormat:@"0 %@",self.adverInfo.virtualCurrency];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.amountTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.amountTextField) {
            ///按照数量购买
            if (self.isCountBuy) {
                self.countTextFieldText = textFiled.text;
                if (textFiled.text.floatValue>0) {
                    self.buyQuantity = [NSDecimalNumber decimalNumberWithString:textFiled.text];
                    self.buyPrice = [self.buyQuantity decimalNumberByMultiplyingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
                }else{
                    self.buyQuantity = [NSDecimalNumber decimalNumberWithString:@"0.00"];
                    self.buyPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];;
                }
            }else{
                self.amountTextFieldText = textFiled.text;
                if (textFiled.text.floatValue>0) {
                    self.buyPrice = [NSDecimalNumber decimalNumberWithString:textFiled.text];
                    self.buyQuantity = [self.buyPrice decimalNumberByDividingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
                }else{
                    self.buyQuantity = [NSDecimalNumber decimalNumberWithString:@"0.00"];
                    self.buyPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];;
                }
                
                
            }
            [self setCountAndTotalAmount];
        }
        
    }];
    self.nextButton.enabled = NO;
    [self.nextButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
    self.nextButton.backgroundColor = UIColorMakeWithRGBA(197, 205, 214, 1);
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [RACObserve(self, self.nextButton.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.nextButton.backgroundColor= UIColorMakeHEXCOLOR(0x256AD2);
            [self.nextButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.nextButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.nextButton.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    
}
-(void)setNextIsEnabled:(BOOL)enabled{
    if (enabled) {
        [self.amountBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        self.errorTipsLabel.hidden = YES;
        self.nextButton.enabled = YES;
    }else{
        [self.amountBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
        self.errorTipsLabel.hidden = NO;
        self.nextButton.enabled = NO;
    }
}
/// 刷新广告详情获取最新数据
-(IBAction)refreshBtnAction{
    [self getC2CAdverDetailInfo];
}
-(IBAction)allButonAction{
    self.buyPrice  = [self.surplusCount decimalNumberByMultiplyingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
    self.buyQuantity = self.surplusCount;
    if (self.isBuy) {
        if (self.isCountBuy) {
            self.countTextFieldText = [self.surplusCount calculateByNSRoundDownScale:2].currencyString;
        }else{
            //按照金额购买
            self.amountTextFieldText = [self.buyPrice calculateByNSRoundDownScale:2].currencyString;
        }
        [self setCountAndTotalAmount];
    }else{
        ///余额的数量比广告剩余的数量要少
        if (self.currencyBalanceListInfo.money.floatValue<self.surplusCount.floatValue) {
            if (self.currencyBalanceListInfo.money.floatValue==0.00) {
                self.buyPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];
                self.buyQuantity = [NSDecimalNumber decimalNumberWithString:@"0.00"];
                self.countTextFieldText = @"0.00";
                self.amountTextFieldText = @"0.00";
            }else{
                self.buyQuantity = self.currencyBalanceListInfo.money;
                self.buyPrice = [self.buyQuantity decimalNumberByMultiplyingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
                ///按照数量出售
                if (self.isCountBuy) {
                    self.countTextFieldText = [self.buyQuantity calculateByNSRoundDownScale:2].currencyString;
                }else{
                    self.amountTextFieldText = [self.buyPrice calculateByNSRoundDownScale:2].currencyString;
                }
                
            }
        }else{
            if (self.isCountBuy) {
                self.countTextFieldText = [self.buyQuantity calculateByNSRoundDownScale:2].currencyString;
            }else{
                self.amountTextFieldText = [self.buyPrice calculateByNSRoundDownScale:2].currencyString;
            }
        }
    }
    [self setCountAndTotalAmount];
}
/// 按照数量购买或者出售
-(IBAction)countSaleAction{
    self.currencyCodeLabel.hidden = NO;
    self.isCountBuy = YES;
    self.amountTextField.floatLenth = 8;
    self.amountTextField.placeholder =@"C2COptionalSaleViewControllerAmountTextFieldCount".icanlocalized;
    self.amountSaleTitleLabel.textColor = UIColor153Color;
    self.countSaleTitleLabel.textColor = UIColor252730Color;
    self.unitLabel.hidden = YES;
    self.byFiatLineView.hidden = YES;
    self.byCryptLineView.hidden = NO;
    if (self.countTextFieldText.floatValue>0) {
        self.buyQuantity = [NSDecimalNumber decimalNumberWithString:self.countTextFieldText];
        self.buyPrice = [self.buyQuantity decimalNumberByMultiplyingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
    }else{
        self.buyQuantity = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        self.buyPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
    
    [self setCountAndTotalAmount];
    
    
}
/// 按照金额购买或者出售
-(IBAction)amountSaleAction{
    self.currencyCodeLabel.hidden = YES;
    self.isCountBuy = NO;
    self.amountTextField.floatLenth = 2;
    self.amountTextField.placeholder =@"C2COptionalSaleViewControllerAmountTextFieldAmount".icanlocalized;
    self.amountSaleTitleLabel.textColor = UIColor252730Color;
    self.countSaleTitleLabel.textColor = UIColor153Color;
    self.unitLabel.hidden = NO;
    self.byFiatLineView.hidden = NO;
    self.byCryptLineView.hidden = YES;
    //默认是限额
    self.limitCountTitleLabel.text = @"C2CMyAdvertisingListTableViewCellLimitLabel".icanlocalized;
    self.limitCountLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",self.currentCurrencyInfo.symbol,[self.minAmountPrice calculateByNSRoundDownScale:2].currencyString,self.currentCurrencyInfo.symbol,[self.maxAmountPrice calculateByNSRoundDownScale:2].currencyString];
    if (self.amountTextFieldText.floatValue>0) {
        self.buyPrice = [NSDecimalNumber decimalNumberWithString:self.amountTextFieldText];
        self.buyQuantity = [self.buyPrice decimalNumberByDividingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
    }else{
        self.buyQuantity = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        self.buyPrice = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
    
    [self setCountAndTotalAmount];
    
}
///当金额或者数量改变的时候 判断能否点击购买按钮
-(void)setCountAndTotalAmount{
    if (self.isCountBuy) {
        if ([self.buyQuantity compare:self.maxCount] == NSOrderedDescending||[self.buyQuantity compare:self.minCount] == NSOrderedAscending) {
            if (BaseSettingManager.isChinaLanguages) {
                self.errorTipsLabel.text = [NSString stringWithFormat:@"数量必须在[%@,%@]范围内",[self.minCount calculateByNSRoundDownScale:2].currencyString,[self.maxCount calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.errorTipsLabel.text = [NSString stringWithFormat:@"The quantity must be in the range of [%@,%@]",[self.minCount calculateByNSRoundDownScale:2].currencyString,[self.maxCount calculateByNSRoundDownScale:2].currencyString];
            }
            [self setNextIsEnabled:NO];
            
        }else{
            if ([self.surplusCount compare:self.buyQuantity]==NSOrderedAscending) {
                [self setNextIsEnabled:NO];
                self.errorTipsLabel.text = @"Insufficientremainingquantity".icanlocalized;
            }else{
                [self setNextIsEnabled:YES];
            }
        }
        //限量
        self.limitCountTitleLabel.text = @"C2COptionalSaleViewControllerLimitCountTitleLabel".icanlocalized;
        self.limitCountLabel.text = [NSString stringWithFormat:@"%@ - %@ %@",[self.minCount calculateByNSRoundDownScale:2].currencyString,[self.maxCount calculateByNSRoundDownScale:2].currencyString,self.adverInfo.virtualCurrency];
        self.amountTextField.text = self.countTextFieldText;
        if (self.buyQuantity.doubleValue == 0.00) {
            self.countLabel.text = [NSString stringWithFormat:@"%@ %@",@"0.00",self.adverInfo.virtualCurrency];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %@",@"0.00",self.adverInfo.legalTender];
        }else{
            self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[self.buyQuantity calculateByNSRoundDownScale:2].currencyString,self.adverInfo.virtualCurrency];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %@",[self.buyPrice calculateByNSRoundDownScale:2].currencyString,self.adverInfo.legalTender];
            
        }
    }else{
        if ([self.buyPrice compare:self.maxAmountPrice]==NSOrderedDescending||[self.buyPrice compare:self.minAmountPrice]==NSOrderedAscending) {
            if (BaseSettingManager.isChinaLanguages) {
                self.errorTipsLabel.text = [NSString stringWithFormat:@"金额必须在[%@,%@]范围内",[self.minAmountPrice calculateByNSRoundDownScale:2].currencyString,[self.maxAmountPrice calculateByNSRoundDownScale:2].currencyString];
            }else{
                self.errorTipsLabel.text = [NSString stringWithFormat:@"The amount must be within the range of [%@,%@]",[self.minAmountPrice calculateByNSRoundDownScale:2].currencyString,[self.maxAmountPrice calculateByNSRoundDownScale:2].currencyString];
            }
            [self setNextIsEnabled:NO];
        }else{
            NSDecimalNumber*countNumber = [self.buyPrice decimalNumberByDividingBy:[self.adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:self.adverInfo.priceFluctuationIndex.decimalNumber]];
            if ([self.surplusCount compare:countNumber]==NSOrderedAscending) {
                [self setNextIsEnabled:NO];
                self.errorTipsLabel.text = @"Insufficientremainingquantity".icanlocalized;
            }else{
                [self setNextIsEnabled:YES];
            }
        }
        //限额
        self.amountTextField.text = self.amountTextFieldText;
        self.limitCountTitleLabel.text = @"C2CMyAdvertisingListTableViewCellLimitLabel".icanlocalized;
        self.limitCountLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",self.currentCurrencyInfo.symbol,[self.minAmountPrice calculateByNSRoundDownScale:2].currencyString,self.currentCurrencyInfo.symbol,[self.maxAmountPrice calculateByNSRoundDownScale:2].currencyString];
        if (self.amountTextFieldText.doubleValue==0.00) {
            self.countLabel.text = [NSString stringWithFormat:@"%@ %@",@"0.00",self.adverInfo.virtualCurrency];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"0.00 %@",self.adverInfo.legalTender];
        }else{
            self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[self.buyQuantity calculateByNSRoundDownScale:2],self.adverInfo.virtualCurrency];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"%@ %@",[self.buyPrice calculateByNSRoundDownScale:2].currencyString,self.adverInfo.legalTender];
        }
    }
    ///如果当前是出售 需要判断余额是否足够
    if (!self.isBuy&&self.amountTextField.text.length>0) {
        if (self.buyQuantity .floatValue>self.currencyBalanceListInfo.money.floatValue||self.buyQuantity.floatValue==0.00) {
            [self setNextIsEnabled:NO];
            self.errorTipsLabel.text = @"NotEnoughBalance".icanlocalized;
            
        }
    }
    
    
}

/// 选择收款方式
-(IBAction)selectReceiveAction{
    SelectReceiveMethodViewController * vc = [[SelectReceiveMethodViewController alloc]init];
    vc.adverDetailInfo = self.adverInfo;
    vc.type = SelectReceiveMethodType_Sale;
    vc.selectReceiveMethodBlock = ^(C2CPaymentMethodInfo * _Nonnull info) {
        self.payMethodInfo = info;
        if ([info.paymentMethodType isEqualToString:@"BankTransfer"]) {
            self.selectReceiveTextField.text = [NSString stringWithFormat:@"%@ %@",@"C2CBankCard".icanlocalized,info.account];
        }else if([info.paymentMethodType isEqualToString:@"Wechat"]) {
            self.selectReceiveTextField.text =[NSString stringWithFormat:@"%@ %@",@"C2CWeChat".icanlocalized,info.account];
        }else if([info.paymentMethodType isEqualToString:@"AliPay"]) {
            self.selectReceiveTextField.text = [NSString stringWithFormat:@"%@ %@",@"C2CAlipay".icanlocalized,info.account];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//跳转到用户详情
- (IBAction)gotoUserDetail {
    C2CUserDetailViewController * vc = [[C2CUserDetailViewController alloc]init];
    vc.userId  = self.adverInfo.user.userId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 获取广告详情
-(void)getC2CAdverDetailInfo{
    C2CGetAdverDetailRequest * request = [C2CGetAdverDetailRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/ad/%ld",self.adverInfo.adId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAdverInfo class] contentClass:[C2CAdverInfo class] success:^(C2CAdverInfo*  _Nonnull response) {
        self.adverInfo = response;
        [self setData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(IBAction)saleAction{
    if (self.isBuy) {
        C2CBuyAdverRequest * request = [C2CBuyAdverRequest request];
        request.adId = self.adverInfo.adId;
        if (self.isCountBuy) {
            request.buyQuantity = [self.buyQuantity calculateWithRoundingMode:NSRoundDown scale:8];
        }else{
            request.buyPrice = [self.buyPrice calculateWithRoundingMode:NSRoundDown scale:2];
        }
        request.parameters = [request mj_JSONObject];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
            C2CPConfirmOrderViewController * vc = [C2CPConfirmOrderViewController new];
            vc.orderInfo = response;
            vc.adverInfo = self.adverInfo;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
            //创建文本消息
            if (self.adverInfo.autoMessage) {
                ChatModel * model = [[ChatModel alloc]init];
                model.authorityType = AuthorityType_c2c;
                model.c2cUserId = self.adverInfo.user.userId;
                model.chatID = self.adverInfo.user.uid;
                model.chatType = UserChat;
                model.c2cOrderId = response.orderId;
                ChatModel *textModel = [ChatUtil initTextMessage:self.adverInfo.autoMessage config:model];
                textModel.isOutGoing = NO;
                textModel.sendState = 1;
                [[WCDBManager sharedManager]cacheMessageWithChatModel:textModel isNeedSend:NO];
            }
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }else{
        if (self.payMethodInfo) {
            C2CSellAdverRequest*request = [C2CSellAdverRequest request];
            request.adId = self.adverInfo.adId;
            if (self.isCountBuy) {
                request.buyQuantity = [self.buyQuantity calculateWithRoundingMode:NSRoundDown scale:8];
            }else{
                request.buyPrice = [self.buyPrice calculateWithRoundingMode:NSRoundDown scale:2];
            }
            request.sellPaymentMethodId = self.payMethodInfo.paymentMethodId;
            request.parameters = [request mj_JSONObject];
            [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderInfo class] contentClass:[C2COrderInfo class] success:^(C2COrderInfo*  _Nonnull response) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
                if (self.adverInfo.autoMessage) {
                    ChatModel * model = [[ChatModel alloc]init];
                    model.authorityType = AuthorityType_c2c;
                    model.c2cUserId = self.adverInfo.user.userId;
                    model.chatID = self.adverInfo.user.uid;
                    model.chatType = UserChat;
                    model.c2cOrderId = response.orderId;
                    ChatModel *textModel = [ChatUtil initTextMessage:self.adverInfo.autoMessage config:model];
                    textModel.isOutGoing = NO;
                    textModel.sendState = 1;
                    [[WCDBManager sharedManager]cacheMessageWithChatModel:textModel isNeedSend:NO];
                }
                C2COrderDetailViewController * vc = [[C2COrderDetailViewController alloc]init];
                vc.orderInfo = response;
                [self.navigationController pushViewController:vc animated:YES];
                
            } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"PleaseSelectPaymentMethod".icanlocalized inView:self.view];
        }
        
    }
    
}
-(void)getCurrencyRequest{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        if (!self.isBuy) {
            ///当前的虚拟资产
            NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"code == %@",self.adverInfo.virtualCurrency];
            NSArray *array = [C2CUserManager.shared.c2cBalanceListItems filteredArrayUsingPredicate:gpredicate];
            self.currencyBalanceListInfo = array.firstObject;
            if (self.currencyBalanceListInfo) {
                self.balanceLabel.text = [NSString stringWithFormat:@"%@:%@%@ ≈ %@%@",@"AvailableBalance".icanlocalized,[self.currencyBalanceListInfo.money calculateByNSRoundDownScale:2].currencyString,self.currencyBalanceListInfo.code,[[self.currencyBalanceListInfo.money decimalNumberByMultiplyingBy:self.adverInfo.fixedPrice.decimalNumber]calculateByNSRoundDownScale:2].currencyString,self.adverInfo.legalTender];
            }else{
                self.balanceLabel.text = [NSString stringWithFormat:@"%@:0.00%@",@"AvailableBalance".icanlocalized,self.adverInfo.virtualCurrency];
            }
        }
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        
    }];
}
@end

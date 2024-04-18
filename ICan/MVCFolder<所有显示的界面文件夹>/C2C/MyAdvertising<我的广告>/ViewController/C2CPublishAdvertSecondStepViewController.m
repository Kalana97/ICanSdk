//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/11/2021
- File name:  C2CPublishAdvertFirstStepViewController.m
- Description:
- Function List:
*/
        

#import "C2CPublishAdvertSecondStepViewController.h"
#import "C2CPublishAdvertThirdStepViewController.h"

#import "C2CPaymentMethodTableViewCell.h"
#import "DecimalKeyboard.h"
#import "SelectReceiveMethodViewController.h"
#import "SelectLimitTimePopView.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CPublishAdvertSecondStepViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,QMUITextFieldDelegate>
//1/3.设置类型&价格
@property (weak, nonatomic) IBOutlet UILabel *stepTipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgCorView;
///广告bgView
@property (weak, nonatomic) IBOutlet UIView *adverCountBgView;
@property (weak, nonatomic) IBOutlet UILabel *adverTitleLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *adverCountTextField;
@property (weak, nonatomic) IBOutlet UILabel *countErrorTipsLabel;
///手续费率
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateLabel;
///手续费
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;


@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
///价格
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;
///拥有的虚拟币
@property (weak, nonatomic) IBOutlet UILabel *canUseCountLabel;
//最小限额
@property (weak, nonatomic) IBOutlet UIControl *minPriceBgView;
@property (weak, nonatomic) IBOutlet UILabel *limitTitleLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *littleTextField;
@property (weak, nonatomic) IBOutlet UILabel *littleUnitLabel;
//最小金额错误提示
@property (weak, nonatomic) IBOutlet UILabel *minPriceErrorTipsLabel;

//最大限额
@property (weak, nonatomic) IBOutlet UIControl *maxPriceBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *bigTextField;
@property (weak, nonatomic) IBOutlet UILabel *bigUnitLabel;
//最小金额提示
@property (weak, nonatomic) IBOutlet UILabel *maxPriceErrorTipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *receiveTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@property (weak, nonatomic) IBOutlet UILabel *payTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;


@property (weak, nonatomic) IBOutlet UIButton *lastStepButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SelectLimitTimePopView *limitPopView;

@property (weak, nonatomic) IBOutlet UIView *tableViewBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBgViewHeight;
@property (nonatomic, strong) C2CPublishAdvertThirdStepViewController *thirdVc;
@property (nonatomic, strong) NSMutableArray <C2CPaymentMethodInfo*>*receiveMethodItems;

@property(nonatomic, copy) NSString *littleTextFieldText;
@property(nonatomic, copy) NSString *bigTextFieldText;
@property(nonatomic, strong) C2CBalanceListInfo *currencyBalanceListInfo;
/** 当前选择的法币对应的货币数据 */
@property(nonatomic, strong) CurrencyInfo *currentCurrencyInfo;
@end

@implementation C2CPublishAdvertSecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.serviceFeeRateTitleLabel.text = @"HandlingFeeRate".icanlocalized;
//    self.serviceFeeTitleLabel.text = @"HandlingFee".icanlocalized;
    self.title = @"C2CPublishAdvertFirstStepViewControllerTitle".icanlocalized;
    self.stepTipLabel.text = @"C2CPublishAdvertSecondStepViewControllerStepTipLabel".icanlocalized;
    self.adverTitleLabel.text = @"PurchaseQuantity".icanlocalized;
    self.adverCountTextField.placeholder = @"PleaseEnterThePurchaseQuantity".icanlocalized;
    [self.allButton setTitle:@"C2CPublishAdvertSecondStepViewControllerAllButton".icanlocalized forState:UIControlStateNormal];
    self.canUseLabel.text = @"C2CPublishAdvertSecondStepViewControllerCanUseLabel".icanlocalized;
    self.limitTitleLabel.text = @"C2CPublishAdvertSecondStepViewControllerLimitTitleLabel".icanlocalized;
    self.receiveTitleLabel.text = @"C2CPublishAdvertSecondStepViewControllerReceiveTitleLabel".icanlocalized;
    self.receiveTipsLabel.text = @"C2CPublishAdvertSecondStepViewControllerReceiveTipsLabel".icanlocalized;
    self.addLabel.text = @"C2CPublishAdvertSecondStepViewControllerAddLabel".icanlocalized;
    self.payTimeTitleLabel.text = @"C2CPublishAdvertSecondStepViewControllerPayTimeTitleLabel".icanlocalized;
    [self.lastStepButton setTitle:@"C2CPublishAdvertSecondStepViewControllerlastStepButton".icanlocalized forState:UIControlStateNormal];
    [self.nextButton setTitle:@"C2CPublishAdvertFirstStepViewControllerhighPricenextButton".icanlocalized forState:UIControlStateNormal];
    self.bgCorView.layer.cornerRadius = 5;
    self.bgCorView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.bgCorView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgCorView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgCorView.layer.shadowRadius = 5;
    
    [self.nextButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.lastStepButton layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
    self.tableViewBgViewHeight.constant = 0;
    [self.tableView registNibWithNibName:kC2CPaymentMethodTableViewCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.payTimeLabel.text = @"15Minutes".icanlocalized;
    
    self.littleUnitLabel.text = self.publishAdvertRequest.legalTender;
    self.bigUnitLabel.text = self.publishAdvertRequest.legalTender;
    self.unitLabel.text = self.publishAdvertRequest.virtualCurrency;
    self.amountLabel.text = [NSString stringWithFormat:@"≈ 0 %@",self.publishAdvertRequest.legalTender];
    self.nextButton.enabled = NO;
    [self.nextButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
    self.nextButton.backgroundColor = UIColorMakeWithRGBA(197, 205, 214, 1);
    
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    DecimalKeyboard *decimalKeyboard2 = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    DecimalKeyboard *decimalKeyboard3 = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.adverCountTextField];
    [decimalKeyboard2 setTargetTextField:self.littleTextField];
    [decimalKeyboard3 setTargetTextField:self.bigTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    decimalKeyboard2.translatesAutoresizingMaskIntoConstraints = NO;
    decimalKeyboard3.translatesAutoresizingMaskIntoConstraints = NO;
    self.adverCountTextField.inputView = decimalKeyboard;
    self.littleTextField.inputView = decimalKeyboard2;
    self.bigTextField.inputView = decimalKeyboard3;
    
    [RACObserve(self, self.nextButton.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.nextButton.backgroundColor=UIColorThemeMainColor;
            [self.nextButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.nextButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.nextButton.backgroundColor=UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    //广告数量
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.adverCountTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.adverCountTextField) {
            
            [self setAmountTextWhenChange];
        }
        
    }];
//    "TheMinimumAmountCannotBeLessThan"="最小金额不可小于";
//    "TheMinimumAmountCannotBeGreaterThan"="最小金额不可大于";
//    "TheMaximumAmountCannotBeGreaterThan"="最大金额不可大于";
//    "TheMaximumAmountCannotBeLessThan"="最大金额不可小于";
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.littleTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.littleTextField) {
            if (textFiled.text.floatValue<self.selectExchangeRateInfo.minQuota.floatValue) {
                self.minPriceErrorTipsLabel.hidden = NO;
                self.nextButton.enabled = NO;
                self.minPriceErrorTipsLabel.text = [NSString stringWithFormat:@"%@%.2f",@"TheMinimumAmountCannotBeLessThan".icanlocalized,self.selectExchangeRateInfo.minQuota.floatValue];
                [self.minPriceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
                return;
            }
            //如果当前最大金额输入框的内容大于最小金额 才进行判断
            if (self.bigTextFieldText.floatValue>self.selectExchangeRateInfo.minQuota.floatValue) {
                if (textFiled.text.floatValue>self.bigTextFieldText.floatValue) {
                    self.minPriceErrorTipsLabel.hidden = NO;
                    self.nextButton.enabled = NO;
                    self.minPriceErrorTipsLabel.text = [NSString stringWithFormat:@"%@%.2f",@"TheMinimumAmountCannotBeGreaterThan".icanlocalized,self.bigTextFieldText.floatValue];
                    [self.minPriceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
                    return;
                }
            }
            
            self.minPriceErrorTipsLabel.hidden = YES;
            self.nextButton.enabled = YES;
            [self.minPriceBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
            self.littleTextFieldText = textFiled.text;
            self.publishAdvertRequest.min = [NSDecimalNumber decimalNumberWithString:textFiled.text];
        }
        
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.bigTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.bigTextField) {
            //如果输入的最大金额大于限定最大金额
            if (textFiled.text.floatValue>self.selectExchangeRateInfo.maxQuota.floatValue) {
                self.maxPriceErrorTipsLabel.hidden = NO;
                self.nextButton.enabled = NO;
                self.maxPriceErrorTipsLabel.text = [NSString stringWithFormat:@"%@%.2f",@"TheMaximumAmountCannotBeGreaterThan".icanlocalized,self.bigTextFieldText.floatValue];
                [self.maxPriceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
                return;
            }
            if (textFiled.text.floatValue<self.littleTextFieldText.floatValue) {
                self.maxPriceErrorTipsLabel.hidden = NO;
                self.nextButton.enabled = NO;
                [self.maxPriceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
                if (self.littleTextFieldText.floatValue>self.selectExchangeRateInfo.minQuota.floatValue) {
                    self.maxPriceErrorTipsLabel.text = [NSString stringWithFormat:@"%@%.2f",@"TheMaximumAmountCannotBeLessThan".icanlocalized,self.littleTextFieldText.floatValue];
                }else{
                    self.maxPriceErrorTipsLabel.text = [NSString stringWithFormat:@"%@%.2f",@"TheMaximumAmountCannotBeLessThan".icanlocalized,self.selectExchangeRateInfo.minQuota.floatValue];
                }
                return;
            }
            
            self.maxPriceErrorTipsLabel.hidden = YES;
            self.nextButton.enabled = YES;
            [self.maxPriceBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
            self.bigTextFieldText = textFiled.text;
            self.publishAdvertRequest.max = [NSDecimalNumber decimalNumberWithString:textFiled.text];
        }
        
    }];
    self.publishAdvertRequest.payCancelTime = 15;
    self.littleTextField.text = self.selectExchangeRateInfo.minQuota.stringValue;
    self.bigTextField.text = self.selectExchangeRateInfo.maxQuota.stringValue;
    self.publishAdvertRequest.min = self.selectExchangeRateInfo.minQuota;
    self.publishAdvertRequest.max = self.selectExchangeRateInfo.maxQuota;
    [self setShowUi];
   
}

-(void)setPublishAdvertRequest:(C2CPublishAdvertRequest *)publishAdvertRequest{
    _publishAdvertRequest = publishAdvertRequest;
    ///当前的虚拟资产
    [self setShowUi];
}
-(void)setShowUi{
//    "PurchaseQuantity"="购买数量";
//    "PleaseEnterThePurchaseQuantity"="请输入购买数量";
//    "SellQuantity"="出售数量";
//    "PleaseenterthequantitySell"="请输入出售数量";
    self.currentCurrencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:self.publishAdvertRequest.legalTender];
    self.littleUnitLabel.text = self.publishAdvertRequest.legalTender;
    self.bigUnitLabel.text = self.publishAdvertRequest.legalTender;
    self.unitLabel.text = self.publishAdvertRequest.virtualCurrency;
    self.littleTextField.text = self.selectExchangeRateInfo.minQuota.stringValue;
    self.bigTextField.text = self.selectExchangeRateInfo.maxQuota.stringValue;
    self.serviceFeeRateLabel.text = [NSString stringWithFormat:@"%@ %@ %%",@"HandlingFeeRate".icanlocalized,[[self.selectExchangeRateInfo.handlingFee decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]calculateByNSRoundDownScale:2].currencyString];
    if ([self.publishAdvertRequest.transactionType isEqualToString:@"Sell"]) {
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"code == %@",self.publishAdvertRequest.virtualCurrency];
        self.currencyBalanceListInfo = [C2CUserManager.shared.c2cBalanceListItems filteredArrayUsingPredicate:gpredicate].firstObject;
        if (self.currencyBalanceListInfo) {
            self.canUseCountLabel.text = [NSString stringWithFormat:@"%@ %@",[self.currencyBalanceListInfo.money calculateByNSRoundDownScale:2].currencyString,self.currencyBalanceListInfo.code];
        }else{
            self.canUseCountLabel.text = [NSString stringWithFormat:@"0 %@",self.selectExchangeRateInfo.virtualCurrency];
        }
        self.adverTitleLabel.text = @"SellQuantity".icanlocalized;
        self.adverCountTextField.placeholder = @"PleaseenterthequantitySell".icanlocalized;
        self.canUseLabel.hidden = NO;
        self.canUseCountLabel.hidden = NO;
        self.allButton.hidden = NO;
    }else{
        self.adverTitleLabel.text = @"PurchaseQuantity".icanlocalized;
        self.adverCountTextField.placeholder = @"PleaseEnterThePurchaseQuantity".icanlocalized;
        self.canUseLabel.hidden = YES;
        self.canUseCountLabel.hidden = YES;
        self.allButton.hidden = YES;
    }
    [self setAmountTextWhenChange];
}
-(void)setAmountTextWhenChange{
    NSDecimalNumber * inputCount = [NSDecimalNumber decimalNumberWithString:self.adverCountTextField.text];
    if ([self.publishAdvertRequest.transactionType isEqualToString:@"Sell"]) {
        if ([inputCount isEqualToNumber:[NSDecimalNumber notANumber]]) {
            self.nextButton.enabled = NO;
            self.countErrorTipsLabel.hidden = YES;
            [self.adverCountBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        }else{
            NSComparisonResult  result = [inputCount compare:self.currencyBalanceListInfo.money];
            if (result == NSOrderedDescending) {
                self.nextButton.enabled = NO;
                self.countErrorTipsLabel.hidden = NO;
                self.countErrorTipsLabel.text = @"NotEnoughBalance".icanlocalized;
                [self.adverCountBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
            }else{
                self.nextButton.enabled = YES;
                self.countErrorTipsLabel.hidden = YES;
                [self.adverCountBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
            }
        }
        
    }else{
        self.countErrorTipsLabel.hidden = YES;
        [self.adverCountBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        NSComparisonResult  result = [inputCount compare:[NSDecimalNumber decimalNumberWithString:@"0.00"]];
        if (result == NSOrderedDescending) {
            self.nextButton.enabled = YES;
        }else{
            self.nextButton.enabled = NO;
        }
    }
    self.publishAdvertRequest.count = inputCount;
    if ([inputCount isEqualToNumber:[NSDecimalNumber notANumber]]) {
        self.amountLabel.text = [NSString stringWithFormat:@"≈ 0.00 %@",self.publishAdvertRequest.legalTender];
        self.serviceFeeLabel.text =  [NSString stringWithFormat:@"%@ 0.00 %@",@"HandlingFee".icanlocalized,self.publishAdvertRequest.virtualCurrency];;
    }else{
        /// 是浮动价格  is a floating price
        if ([self.publishAdvertRequest.priceType isEqualToString:@"Fluctuation"]) {
            float amount = self.publishAdvertRequest.fixedPrice.floatValue * inputCount.floatValue * self.publishAdvertRequest.priceFluctuationIndex.floatValue;
            self.amountLabel.text = [NSString stringWithFormat:@"≈ %.2f %@",amount,self.publishAdvertRequest.legalTender];
        }else{
            float amount = self.publishAdvertRequest.fixedPrice.floatValue * inputCount.floatValue;
            self.amountLabel.text = [NSString stringWithFormat:@"≈ %.2f %@",amount,self.publishAdvertRequest.legalTender];
        }
        
        self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"HandlingFee".icanlocalized,[[inputCount decimalNumberByMultiplyingBy:self.selectExchangeRateInfo.handlingFee]calculateByNSRoundDownScale:2].currencyString,self.selectExchangeRateInfo.virtualCurrency];
    }
   
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receiveMethodItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CPaymentMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CPaymentMethodTableViewCell];
    C2CPaymentMethodInfo * info = self.receiveMethodItems[indexPath.row];
    cell.paymentMethodInfo = info;
    cell.cellType = C2CPaymentMethodTableViewCellTypePublishAdvert;
    if (indexPath.row == self.receiveMethodItems.count-1) {
        cell.bottomLineView.hidden = YES;
    }else{
        cell.bottomLineView.hidden = NO;
    }
    cell.rightBtnBlock = ^{
        for (C2CPaymentMethodInfo*hasInfo in self.receiveMethodItems) {
            if ([hasInfo.paymentMethodId isEqualToString:info.paymentMethodId]) {
                [self.receiveMethodItems removeObject:info];
                break;
            }
        }
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.receiveMethodItems.count];
        for (C2CPaymentMethodInfo*info in self.receiveMethodItems) {
            [array addObject:info.paymentMethodId];
        }
        self.publishAdvertRequest.payMethodIds = array;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        self.tableViewBgViewHeight.constant = self.tableView.contentSize.height;
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}



-(IBAction)selectTimeAction{
    [self.limitPopView showView];
}
///出售的时候的全部按钮
-(IBAction)allAction{
    if (!self.currencyBalanceListInfo) {
        self.adverCountTextField.text = @"0";
    }else{
        NSString * count = [self.currencyBalanceListInfo.money  calculateWithRoundingMode:NSRoundDown scale:8].currencyString;
        self.adverCountTextField.text = count;
    }
    
    [self setAmountTextWhenChange];
}
-(IBAction)addButtonAction{
    SelectReceiveMethodViewController * vc = [[SelectReceiveMethodViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.currentCurrencyInfo = self.currentCurrencyInfo;
    vc.type = SelectReceiveMethodType_PublishAdver;
    vc.selectReceiveMethodBlock = ^(C2CPaymentMethodInfo * _Nonnull info) {
        if (self.receiveMethodItems.count==5) {
            return;
        }
        BOOL shouldAdd = YES;
        for (C2CPaymentMethodInfo*hasInfo in self.receiveMethodItems) {
            if ([hasInfo.paymentMethodId isEqualToString:info.paymentMethodId]) {
                shouldAdd = NO;
                break;
            }
        }
        if (shouldAdd) {
            [self.receiveMethodItems addObject:info];
        }
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.receiveMethodItems.count];
        for (C2CPaymentMethodInfo*info in self.receiveMethodItems) {
            [array addObject:info.paymentMethodId];
        }
        self.publishAdvertRequest.payMethodIds = array;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        self.tableViewBgViewHeight.constant = self.tableView.contentSize.height;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)lastStepAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)nextAction{
    if ([self.publishAdvertRequest.count isEqualToNumber:NSDecimalNumber.notANumber]) {
        [QMUITipsTool showOnlyTextWithMessage:@"C2CPublishAdvertSecondStepViewControllerAdverCountTextField".icanlocalized inView:self.view];
        return;
    }
    if (self.receiveMethodItems.count==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"PleaseSelectPaymentMethod".icanlocalized inView:self.view];
        return;
    }
    self.thirdVc.publishAdvertRequest = self.publishAdvertRequest;
    [self.navigationController pushViewController:self.thirdVc animated:YES];
}
-(NSMutableArray<C2CPaymentMethodInfo *> *)receiveMethodItems{
    if (!_receiveMethodItems) {
        _receiveMethodItems = [NSMutableArray array];
    }
    return _receiveMethodItems;
}
-(C2CPublishAdvertThirdStepViewController *)thirdVc{
    if (!_thirdVc) {
        _thirdVc = [C2CPublishAdvertThirdStepViewController new];
    }
    return _thirdVc;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(SelectLimitTimePopView *)limitPopView{
    if (!_limitPopView) {
        _limitPopView = [[NSBundle mainBundle]loadNibNamed:@"SelectLimitTimePopView" owner:self options:nil].firstObject;
        _limitPopView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _limitPopView.selectBlock = ^(NSString * _Nonnull limitTime) {
            @strongify(self);
            self.payTimeLabel.text = limitTime;
            self.publishAdvertRequest.payCancelTime = [self getLimitTimeWith:limitTime];
        };
    }
    return _limitPopView;
}
-(NSInteger)getLimitTimeWith:(NSString*)title{
//    "15Minutes"="15分钟";
//    "30Minutes"="30分钟";
//    "45Minutes"="45分钟";
//    "60Minutes"="60分钟";
//    "120Minutes"="2小时";
    if ([title isEqualToString:@"15Minutes".icanlocalized]) {
        return 15;
    }else if ([title isEqualToString:@"30Minutes".icanlocalized]) {
        return 30;
    }else if ([title isEqualToString:@"60Minutes".icanlocalized]) {
        return 60;
    }else if ([title isEqualToString:@"720Minutes".icanlocalized]) {
        return 720;
    }else if ([title isEqualToString:@"1440Minutes".icanlocalized]) {
        return 1440;
    }
    return 120;
}
@end

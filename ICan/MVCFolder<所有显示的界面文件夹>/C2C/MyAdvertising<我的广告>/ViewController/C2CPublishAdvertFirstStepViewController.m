//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/11/2021
 - File name:  C2CPublishAdvertFirstStepViewController.m
 - Description:
 - Function List:
 */


#import "C2CPublishAdvertFirstStepViewController.h"
#import "C2CPublishAdvertSecondStepViewController.h"
#import "HJCActionSheet.h"
#import "DecimalKeyboard.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CPublishAdvertFirstStepViewController ()<UIScrollViewDelegate,HJCActionSheetDelegate>
//1/3.设置类型&价格
@property (weak, nonatomic) IBOutlet UILabel *stepTipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgCorView;
//头部的购买或者出售切换
@property (weak, nonatomic) IBOutlet UIView *buyOrSaleBgView;
@property (weak, nonatomic) IBOutlet UIControl *buyBgView;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIControl *saleView;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
//用法币
@property (weak, nonatomic) IBOutlet UILabel *legalTenderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalTenderLabel;

//币种
@property (weak, nonatomic) IBOutlet UILabel *virtualTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *virtualLabel;

@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;


//固定价格和浮动价格
@property (weak, nonatomic) IBOutlet UIView *priceTypeBgView;
@property (weak, nonatomic) IBOutlet UIControl *fixationPriceBgView;
@property (weak, nonatomic) IBOutlet UILabel *fixationPriceLabel;
@property (weak, nonatomic) IBOutlet UIControl *floatBgView;
@property (weak, nonatomic) IBOutlet UILabel *floatPriceLabel;
//固定价格
@property (weak, nonatomic) IBOutlet UILabel *floatOrFixationPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *percentBgView;
//错误提示
@property (weak, nonatomic) IBOutlet UIView *errorBgView;
@property (weak, nonatomic) IBOutlet UILabel *errorTipsLabel;

/** 百分号 */
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (weak, nonatomic) IBOutlet UIView *priceBgView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
//市场最高价
@property (weak, nonatomic) IBOutlet UILabel *highPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *highPriceImageView;
/** 显示市场最高价的价格 */
@property (weak, nonatomic) IBOutlet UILabel *highPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *highPriceSymbolLabel;


//市场最高价
@property (weak, nonatomic) IBOutlet UILabel *rightHighPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightHighPriceImageView;
/** 显示市场最高价的价格 */
@property (weak, nonatomic) IBOutlet UILabel *rightHighPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightHighPriceSymbolLabel;


@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property(nonatomic, strong) C2CPublishAdvertSecondStepViewController *secondVc;
/** 支持的法币的数组 */
@property(nonatomic, strong) NSArray<C2CExchangeRateInfo*> *legalTenderItmes;
/** 支持的法币的数组 */
@property(nonatomic, strong) NSArray<NSString*> *legalTenderTitleItmes;
@property(nonatomic, copy) NSString *selectLegalTenderCode;
/** 支持虚拟币数组 */
@property(nonatomic, strong) NSArray<C2CExchangeRateInfo*> *virtualCurrencyItmes;
/** 支持的法币的数组 */
@property(nonatomic, strong) NSArray<NSString*> *virtualTitleItmes;
@property(nonatomic, copy) NSString *selectVirtualCode;
/** 当前的汇率 */
@property(nonatomic, strong) C2CExchangeRateInfo *selectExchangeRateInfo;
@property(nonatomic, strong) NSMutableArray *virtualTitleItmesMutableArray;
//@property(nonatomic, strong) NSMutableArray *virtualTitleItmesMutableArray;
/** 当前是不是固定价格 */
@property(nonatomic, assign) BOOL isFixationPrice;
/** 当前是不是购买 */
@property(nonatomic, assign) BOOL isBuy;
/** 当前的固定价格 */
@property(nonatomic, copy) NSString *fixationText;
/** 当前的浮动价格 */
@property(nonatomic, copy) NSString *floatText;
/** 发布广告的请求 */
@property (nonatomic, strong) C2CPublishAdvertRequest *publishAdvertRequest;

@property(nonatomic, strong) HJCActionSheet *hjcActionSheet;
@end

@implementation C2CPublishAdvertFirstStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C2CPublishAdvertFirstStepViewControllerTitle".icanlocalized;
    self.stepTipLabel.text = @"C2CPublishAdvertFirstStepViewControllerstepTipLabel".icanlocalized;
    self.buyLabel.text = @"C2CPublishAdvertFirstStepViewControllerbuyLabel".icanlocalized;
    self.saleLabel.text = @"C2CPublishAdvertFirstStepViewControllersaleLabel".icanlocalized;
    self.virtualTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllercurrencyTitleLabel".icanlocalized;
    self.legalTenderTitleLabel.text = @"C2CPublishAdvertFirstStepViewControlleruseCurrencyTitleLabel".icanlocalized;
    self.legalTenderLabel.text = @"C2CPublishAdvertFirstStepViewControlleruseCurrencyTitleLabel".icanlocalized;
    self.settingLabel.text = @"C2CPublishAdvertFirstStepViewControllersettingLabel".icanlocalized;
    self.priceTypeLabel.text = @"C2CPublishAdvertFirstStepViewControllerpriceTypeLabel".icanlocalized;
    self.fixationPriceLabel.text = @"C2CPublishAdvertFirstStepViewControllerfixationPriceLabel".icanlocalized;
    self.floatPriceLabel.text = @"C2CPublishAdvertFirstStepViewControllerfloatPriceLabel".icanlocalized;
    self.highPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerhighPriceTitleLabel".icanlocalized;
    self.rightHighPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerhighPriceTitleLabel".icanlocalized;
    [self.nextButton setTitle:@"C2CPublishAdvertFirstStepViewControllerhighPricenextButton".icanlocalized forState:UIControlStateNormal];
    self.floatOrFixationPriceLabel.text = @"C2CPublishAdvertFirstStepViewControllerfixationPriceLabel".icanlocalized;
    
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.priceTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.priceTextField.inputView = decimalKeyboard;
    
    [self.buyBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    [self.saleView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    
    self.bgCorView.layer.cornerRadius = 5;
    self.bgCorView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.bgCorView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgCorView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgCorView.layer.shadowRadius = 5;
    
    [self.nextButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.percentBgView.hidden = YES;
    self.rightHighPriceTitleLabel.hidden = self.rightHighPriceLabel.hidden = self.rightHighPriceSymbolLabel.hidden = self.rightHighPriceImageView.hidden = YES;
    //设置默认的数据
    [self buyAction];
    [self fixationPriceAction];
    self.isFixationPrice = YES;
    self.isBuy = YES;
    [self setFirstData];
    [self getC2CAllExchangeListRequest];
    [self getCurrencyRequest];
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
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.priceTextField]subscribeNext:^(NSNotification * _Nullable x) {
        QMUITextField * textFiled = x.object;
        if (textFiled == self.priceTextField) {
            //当前是固定价格
            if (self.isFixationPrice) {
                self.fixationText = self.priceTextField.text;
            }else{
                //当前是浮动价格
                self.floatText = self.priceTextField.text;
            }
            [self setShowPrice];
        }
        
    }];
    
    
}
-(void)setFirstData{
    __block BOOL isExist = NO;
//    __block BOOL isExist = NO;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@" supportC2C == YES "];
    NSArray*fillterItems = [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
    self.virtualTitleItmes = [fillterItems valueForKeyPath:@"@distinctUnionOfObjects.virtualCurrency"];
    self.virtualTitleItmesMutableArray = [NSMutableArray arrayWithArray:self.virtualTitleItmes];
        for (NSString *val in self.virtualTitleItmesMutableArray) {
                if([val isEqualToString:@"USDT"]){
                    isExist = YES;
                    self.selectVirtualCode = val;
                    self.virtualLabel.text = val;
                }
            }
            if (isExist == YES){
                NSString *searchValue = @"USDT";
                NSUInteger index = [self.virtualTitleItmes indexOfObject:searchValue];
                if (index != NSNotFound) {
                    NSLog(@"Index of %@ is %lu", searchValue, (unsigned long)index);
                } else {
                    NSLog(@"%@ not found in array", searchValue);
                }
                [self.virtualTitleItmesMutableArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
            }else{
                self.selectVirtualCode = self.virtualTitleItmesMutableArray.firstObject;
                self.virtualLabel.text = self.virtualTitleItmesMutableArray.firstObject;
            }
    self.virtualTitleItmesMutableArray = [NSMutableArray arrayWithArray:self.virtualTitleItmes];
    for (NSString *val in self.virtualTitleItmesMutableArray) {
            if([val isEqualToString:@"USDT"]){
                isExist = YES;
                self.selectVirtualCode = val;
                self.virtualLabel.text = val;
            }
        }
        if (isExist == YES){
            NSString *searchValue = @"USDT";
            NSUInteger index = [self.virtualTitleItmes indexOfObject:searchValue];
            if (index != NSNotFound) {
                NSLog(@"Index of %@ is %lu", searchValue, (unsigned long)index);
            } else {
                NSLog(@"%@ not found in array", searchValue);
            }
            [self.virtualTitleItmesMutableArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
        }else{
            self.selectVirtualCode = self.virtualTitleItmesMutableArray.firstObject;
            self.virtualLabel.text = self.virtualTitleItmesMutableArray.firstObject;
        }
    self.fixationText = self.selectExchangeRateInfo.fixedPrice.stringValue;
    self.publishAdvertRequest = [C2CPublishAdvertRequest request];
    self.publishAdvertRequest.transactionType = @"Buy";
    self.publishAdvertRequest.priceType = @"Fixed";
    [self setLegalTenderCode];
    [self getAccordC2CExchangeRateInfo];
}
//根据已经选择的虚拟币 选择法定货币
-(void)setLegalTenderCode{
    __block bool isFound = false;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"virtualCurrency contains [cd]  %@ AND supportC2C == YES",self.selectVirtualCode];
    self.legalTenderItmes =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
    self.legalTenderTitleItmes = [self.legalTenderItmes valueForKeyPath:@"@distinctUnionOfObjects.legalTender"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *P2PAddSelectCurrencyInfo = [prefs stringForKey:@"P2PAddSelectCurrencyInfo"];
    for (NSString *itemVal in self.legalTenderTitleItmes) {
        if(itemVal == P2PAddSelectCurrencyInfo){
            isFound = YES;
        }
    }
    if(isFound == YES){
        self.selectLegalTenderCode = P2PAddSelectCurrencyInfo;
        self.legalTenderLabel.text = P2PAddSelectCurrencyInfo;
    }else{
        self.selectLegalTenderCode = self.legalTenderTitleItmes.firstObject;
        self.legalTenderLabel.text = self.legalTenderTitleItmes.firstObject;
    }
    self.virtualLabel.text = self.selectVirtualCode;
}
///获取当前的汇率
-(void)getAccordC2CExchangeRateInfo{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"virtualCurrency contains [cd] %@ AND legalTender contains [cd] %@ AND supportC2C== YES ",self.selectVirtualCode,self.selectLegalTenderCode];
    self.selectExchangeRateInfo =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate].firstObject;
    self.fixationText = self.selectExchangeRateInfo.fixedPrice.stringValue;
    self.publishAdvertRequest.legalTender = self.selectExchangeRateInfo.legalTender;
    self.publishAdvertRequest.virtualCurrency = self.selectExchangeRateInfo.virtualCurrency;

    [self setData];
    
}
//设置本地数据
-(void)setData{
    //设置单位
    self.highPriceSymbolLabel.text = self.selectExchangeRateInfo.legalTenderInfo.symbol;
    self.rightHighPriceSymbolLabel.text = self.selectExchangeRateInfo.legalTenderInfo.symbol;
    //当前是固定价格
    if (self.isFixationPrice) {
        self.rightHighPriceTitleLabel.hidden = self.rightHighPriceLabel.hidden = self.rightHighPriceSymbolLabel.hidden = self.rightHighPriceImageView.hidden = YES;
        self.highPriceImageView.hidden = NO;
        //市场最高价
        if (self.isBuy) {
            self.highPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerhighPriceTitleLabel".icanlocalized;
        }else{
            //市场最低价
            self.highPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerLowprice".icanlocalized;
        }
        self.highPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.selectExchangeRateInfo.maxPrice.floatValue];
        self.rightHighPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.selectExchangeRateInfo.maxPrice.floatValue];
        self.percentBgView.hidden = YES;
    }else{
        self.rightHighPriceTitleLabel.hidden = self.rightHighPriceLabel.hidden = self.rightHighPriceSymbolLabel.hidden = self.rightHighPriceImageView.hidden = NO;
        //设置价格
        if (self.isBuy) {
            self.highPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllersettingLabel".icanlocalized;
            self.rightHighPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerhighPriceTitleLabel".icanlocalized;
        }else{
            self.highPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllersettingLabel".icanlocalized;
            self.rightHighPriceTitleLabel.text = @"C2CPublishAdvertFirstStepViewControllerLowprice".icanlocalized;
        }
       
        self.highPriceImageView.hidden = YES;
        self.percentBgView.hidden = NO;
    }
    [self setShowPrice];
}
-(void)setShowPrice{
    //固定价格
    if (self.isFixationPrice) {
        //判断固定金额是否在区间之内
        //固定价格的最小值
        NSDecimalNumber* minFixationPrice = [[self.selectExchangeRateInfo.fixedPrice decimalNumberByMultiplyingBy:self.selectExchangeRateInfo.minPriceFluctuationIndex] calculateByNSRoundDownScale:2];
        NSDecimalNumber* maxFixationPrice = [[self.selectExchangeRateInfo.fixedPrice decimalNumberByMultiplyingBy:self.selectExchangeRateInfo.maxPriceFluctuationIndex] calculateByNSRoundDownScale:2];
        if ([[NSDecimalNumber decimalNumberWithString:self.fixationText] isEqualToNumber:NSDecimalNumber.notANumber]) {
            self.priceTextField.text = nil;
            self.priceTextField.placeholder = [self.selectExchangeRateInfo.fixedPrice calculateByNSRoundDownScale:2].currencyString;
        }else{
            self.priceTextField.text = self.fixationText;
        }
        if ([[NSDecimalNumber decimalNumberWithString:self.fixationText]compare:maxFixationPrice]==NSOrderedDescending||[[NSDecimalNumber decimalNumberWithString:self.fixationText]compare:minFixationPrice]==NSOrderedAscending) {
            if (BaseSettingManager.isChinaLanguages) {
                self.errorTipsLabel.text = [NSString stringWithFormat:@"当前固定价格必须在[%@,%@]范围内",minFixationPrice.currencyString,maxFixationPrice.currencyString];
            }else{
                self.errorTipsLabel.text = [NSString stringWithFormat:@"The current fixed price must be within the range of [%@,%@]",minFixationPrice.currencyString,maxFixationPrice.currencyString];
            }
            
            [self.priceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
            self.errorBgView.hidden = NO;
            self.nextButton.enabled = NO;
        }else{
            [self.priceBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
            self.errorBgView.hidden = YES;
            self.nextButton.enabled = YES;
        }
        //是否是购买
        if (self.isBuy) {
            self.highPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.selectExchangeRateInfo.maxPrice.doubleValue];
            self.rightHighPriceLabel.text = self.selectExchangeRateInfo.maxPrice.stringValue;
        }else{
            self.highPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.selectExchangeRateInfo.minPrice.doubleValue];
            self.rightHighPriceLabel.text = self.selectExchangeRateInfo.minPrice.stringValue;
        }
        //如果是固定价格 那么浮动指数传1 也就是100%
        self.publishAdvertRequest.priceFluctuationIndex = [NSDecimalNumber decimalNumberWithString:@"1"];
        NSDecimalNumber * number = [NSDecimalNumber decimalNumberWithString:self.fixationText];
        self.publishAdvertRequest.fixedPrice = number;
    }else{
        if ([[NSDecimalNumber decimalNumberWithString:self.floatText] isEqualToNumber:NSDecimalNumber.notANumber]) {
            self.priceTextField.text = nil;
            NSDecimalNumber* minFluctuationIndex =  [self.selectExchangeRateInfo.minPriceFluctuationIndex decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            NSDecimalNumber* maxFluctuationIndex =  [self.selectExchangeRateInfo.maxPriceFluctuationIndex decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            self.priceTextField.placeholder = [NSString stringWithFormat:@"%@%%-%@%%",[minFluctuationIndex calculateByNSRoundDownScale:2].currencyString,[maxFluctuationIndex calculateByNSRoundDownScale:2].currencyString];
        }else{
            self.priceTextField.text = self.floatText;
        }
        ///以100来计算
        NSDecimalNumber* minFluctuationIndex =  [self.selectExchangeRateInfo.minPriceFluctuationIndex decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        NSDecimalNumber* maxFluctuationIndex =  [self.selectExchangeRateInfo.maxPriceFluctuationIndex decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        NSDecimalNumber * currentFloatText = [NSDecimalNumber decimalNumberWithString:self.floatText];
        if ([currentFloatText compare:maxFluctuationIndex]==NSOrderedDescending||[currentFloatText compare:minFluctuationIndex]==NSOrderedAscending) {
            if (BaseSettingManager.isChinaLanguages) {
                self.errorTipsLabel.text = [NSString stringWithFormat:@"浮动指数必须在[%@%%,%@%%]范围内",minFluctuationIndex,maxFluctuationIndex];
            }else{
                self.errorTipsLabel.text = [NSString stringWithFormat:@"The floating index must be within the range of [%@%%,%@%%]",minFluctuationIndex,maxFluctuationIndex];
            }
           
            [self.priceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
            self.errorBgView.hidden = NO;
            self.nextButton.enabled = NO;
        }else{
            [self.priceBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
            self.errorBgView.hidden = YES;
            self.nextButton.enabled = YES;
        }
        if (self.floatText.doubleValue == 0.00) {
            self.highPriceLabel.text = @"0.00";
        }else{
            self.highPriceLabel.text = [[[self.floatText.decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]decimalNumberByMultiplyingBy:self.selectExchangeRateInfo.fixedPrice]calculateByNSRoundDownScale:2].currencyString;
        }
        //是否是购买
        if (self.isBuy) {
            self.rightHighPriceLabel.text = [self.selectExchangeRateInfo.maxPrice calculateByNSRoundDownScale:2].currencyString;
        }else{
            self.rightHighPriceLabel.text = [self.selectExchangeRateInfo.minPrice calculateByNSRoundDownScale:2].currencyString;
        }
        //如果是浮动价格 ，那么fixedPrice参数传递的就是selectExchangeRateInfo的推荐价格
        if (![currentFloatText isEqualToNumber:NSDecimalNumber.notANumber]) {
            self.publishAdvertRequest.priceFluctuationIndex = [currentFloatText decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            self.publishAdvertRequest.fixedPrice = self.selectExchangeRateInfo.fixedPrice;
        }
        
    }
    
}
-(IBAction)buyAction{
    self.isBuy = YES;
    self.buyLabel.textColor = UIColor252730Color;
    self.saleLabel.textColor = UIColor153Color;
    [self.buyBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    self.buyBgView.backgroundColor = UIColor.whiteColor;
    [self.saleView layerWithCornerRadius:5 borderWidth:0 borderColor:UIColorMake(217, 217, 217)];
    self.saleView.backgroundColor = UIColor.clearColor;
    self.publishAdvertRequest.transactionType = @"Buy";
    [self setData];
    
}
-(IBAction)saleAction{
    self.isBuy = NO;
    self.buyLabel.textColor = UIColor153Color;
    self.saleLabel.textColor = UIColor252730Color;
    [self.buyBgView layerWithCornerRadius:0 borderWidth:0 borderColor:UIColorMake(217, 217, 217)];
    self.buyBgView.backgroundColor = UIColor.clearColor;
    [self.saleView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    self.saleView.backgroundColor = UIColor.whiteColor;
    self.publishAdvertRequest.transactionType = @"Sell";
    [self setData];
    
}
//选择虚拟币种
-(IBAction)currencyAction{
    [self.view endEditing:YES];
    self.hjcActionSheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.virtualTitleItmesMutableArray];
    self.hjcActionSheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.virtualTitleItmesMutableArray];
    self.hjcActionSheet.tag = 0;
    [self.hjcActionSheet show];
}
//选择法币
-(IBAction)useCurrencyAction{
    [self.view endEditing:YES];
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.legalTenderTitleItmes];
    self.hjcActionSheet.tag = 1;
    [self.hjcActionSheet show];
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0) {
        NSString *title = [self.virtualTitleItmesMutableArray objectAtIndex:buttonIndex-1];
//        NSString *title = [self.virtualTitleItmesMutableArray objectAtIndex:buttonIndex-1];
        self.selectVirtualCode = title;
        [self setLegalTenderCode];
        [self getAccordC2CExchangeRateInfo];
    }else{
        self.selectLegalTenderCode = [self.legalTenderTitleItmes objectAtIndex:buttonIndex-1];
        self.legalTenderLabel.text = self.selectLegalTenderCode;
        [self getAccordC2CExchangeRateInfo];
    }
    
}
//固定价格
-(IBAction)fixationPriceAction{
    self.isFixationPrice = YES;
    self.publishAdvertRequest.priceType = @"Fixed";
    self.floatOrFixationPriceLabel.text = @"C2CPublishAdvertFirstStepViewControllerfixationPriceLabel".icanlocalized;
    self.fixationPriceLabel.textColor = UIColor252730Color;
    self.floatPriceLabel.textColor = UIColor153Color;
    [self.fixationPriceBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    self.fixationPriceBgView.backgroundColor = UIColor.whiteColor;
    [self.floatBgView layerWithCornerRadius:5 borderWidth:0 borderColor:UIColorMake(217, 217, 217)];
    self.floatBgView.backgroundColor = UIColor.clearColor;
    [self setData];
    
}
//浮动价格
-(IBAction)floatPriceAction{
    self.isFixationPrice = NO;
    self.publishAdvertRequest.priceType = @"Fluctuation";
    self.floatOrFixationPriceLabel.text = @"C2CPublishAdvertFirstStepViewControllerfloatPriceLabel".icanlocalized;
    self.fixationPriceLabel.textColor = UIColor153Color;
    self.floatPriceLabel.textColor = UIColor252730Color;
    [self.fixationPriceBgView layerWithCornerRadius:0 borderWidth:0 borderColor:UIColorMake(217, 217, 217)];
    self.fixationPriceBgView.backgroundColor = UIColor.clearColor;
    [self.floatBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(217, 217, 217)];
    self.floatBgView.backgroundColor = UIColor.whiteColor;
    
    [self setData];
}
-(IBAction)minusPriceAction{
    if (self.isFixationPrice) {
        self.fixationText = [NSString stringWithFormat:@"%.2f",self.fixationText.doubleValue-0.01];
    }else{
        self.floatText = [NSString stringWithFormat:@"%.2f",self.floatText.doubleValue-0.01];
    }
    [self setShowPrice];
}
-(IBAction)addPriceAction{
    if (self.isFixationPrice) {
        self.fixationText = [NSString stringWithFormat:@"%.2f",self.fixationText.doubleValue+0.01];
    }else{
        self.floatText = [NSString stringWithFormat:@"%.2f",self.floatText.doubleValue+0.01];
    }
    [self setShowPrice];
}
-(IBAction)nextAction{
    self.secondVc.selectExchangeRateInfo = self.selectExchangeRateInfo;
    self.secondVc.publishAdvertRequest = self.publishAdvertRequest;
    [self.navigationController pushViewController:self.secondVc animated:YES];
}
-(C2CPublishAdvertSecondStepViewController *)secondVc{
    if (!_secondVc) {
        _secondVc = [[C2CPublishAdvertSecondStepViewController alloc]init];
        _secondVc.selectExchangeRateInfo = self.selectExchangeRateInfo;
        _secondVc.publishAdvertRequest = self.publishAdvertRequest;
        
    }
    return _secondVc;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
/** 获取资产列表 */
-(void)getCurrencyRequest{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        [self setFirstData];
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        
    }];
    
}
/** 全部的汇率列表 */
-(void)getC2CAllExchangeListRequest{
    [C2CUserManager.shared getC2CAllExchangeListRequest:^(NSArray * _Nonnull response) {
        
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        
    }];
    
}
@end

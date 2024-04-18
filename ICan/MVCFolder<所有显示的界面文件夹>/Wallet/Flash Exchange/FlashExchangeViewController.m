//
//  FlashExchangeViewController.m
//  ICan
//
//  Created by mansa on 08/08/22.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "FlashExchangeViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "DZUITextField.h"
#import "FlashExchangeConfirmView.h"
#import "DecimalKeyboard.h"
#import <Foundation/Foundation.h>

@class CurrencyExchangeInfo;

@interface FlashExchangeViewController()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UIView *toView;
@property (weak, nonatomic) IBOutlet UIImageView *fromCurrencyIcon;
@property (weak, nonatomic) IBOutlet UILabel *fromCurrencyType;
@property (weak, nonatomic) IBOutlet DZUITextField *fromAmountTF;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *toErrorLabel;
@property (weak, nonatomic) IBOutlet UIButton *MaxBtn;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *toCurrencyIcon;
@property (weak, nonatomic) IBOutlet UILabel *toCurrencyType;
@property (weak, nonatomic) IBOutlet DZUITextField *toAmountTF;
@property (weak, nonatomic) IBOutlet UIButton *previewConverstionBtn;
@property (weak, nonatomic) IBOutlet UILabel *fromCurrencyLbl;
@property (weak, nonatomic) IBOutlet UILabel *toCurrencyLbl;
@property (nonatomic, strong) NSArray<CurrencyExchangeInfo *> *allCurrencyListResponse;
@property (nonatomic, strong) NSMutableArray<CurrencyExchangeInfo *> *allCurrencyList;
@property (nonatomic, strong) CurrencyExchangeInfo *currentCurrencyExchangeObject;
@property (nonatomic, strong) NSArray<C2CBalanceListInfo *> *userAvailableCurrencyLit;
@property (nonatomic, strong) NSMutableArray<CurrencyExchangeInfo *> *createdFromCurrencyList;
@property (nonatomic, strong) NSMutableArray<CurrencyInfo *> *createdAllFromCurrencyList;
@property (nonatomic, strong) NSMutableArray<CurrencyInfo *> *createdAllToCurrencyList;
@property (nonatomic, strong) FlashExchangeConfirmView *flashExchangeConfirmView;
@property (nonatomic, strong) CurrencyInfo *selectedFromData;
@property (nonatomic, strong) CurrencyInfo *selectedToData;
@end

@implementation FlashExchangeViewController

- (NSMutableArray<CurrencyExchangeInfo *> *)allCurrencyList {
    if (!_allCurrencyList) {
        _allCurrencyList = [NSMutableArray array];
    }
    return _allCurrencyList;
}

- (NSMutableArray<CurrencyExchangeInfo *> *)createdFromCurrencyList {
    if (!_createdFromCurrencyList) {
        _createdFromCurrencyList = [NSMutableArray array];
    }
    return _createdFromCurrencyList;
}

- (NSMutableArray<CurrencyInfo *> *)createdAllFromCurrencyList {
    if (!_createdAllFromCurrencyList) {
        _createdAllFromCurrencyList = [NSMutableArray array];
    }
    return _createdAllFromCurrencyList;
}

- (NSMutableArray<CurrencyInfo *> *)createdAllToCurrencyList {
    if (!_createdAllToCurrencyList) {
        _createdAllToCurrencyList = [NSMutableArray array];
    }
    return _createdAllToCurrencyList;
}

- (FlashExchangeConfirmView *)flashExchangeConfirmView {
    if (!_flashExchangeConfirmView) {
        _flashExchangeConfirmView = [[NSBundle mainBundle]loadNibNamed:@"FlashExchangeConfirmView" owner:self options:nil].firstObject;
        _flashExchangeConfirmView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _flashExchangeConfirmView.sureBlock = ^{
            @strongify(self);
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        };
    }
    return _flashExchangeConfirmView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self getAllCurrencyDetails];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.fromCurrencyLbl.text = @"From".icanlocalized;
    self.toCurrencyLbl.text = @"To".icanlocalized;
    self.titleView.title = @"CurrencyConvert".icanlocalized;
    [self.MaxBtn setTitle:@"Max".icanlocalized forState:UIControlStateNormal];
    self.availableLabel.text = @"AvailableBalance".icanlocalized;
    [self.previewConverstionBtn setTitle:@"PreviewConverstion".icanlocalized forState:UIControlStateNormal];
    self.availableAmountLabel.text = @"0.00";
    self.previewConverstionBtn.enabled = NO;
    self.fromView.layer.cornerRadius = 5;
    self.toView.layer.cornerRadius = 5;
    self.previewConverstionBtn.layer.cornerRadius = 20;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    DecimalKeyboard *decimalKeyboard2 = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.fromAmountTF];
    [decimalKeyboard2 setTargetTextField:self.toAmountTF];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    decimalKeyboard2.translatesAutoresizingMaskIntoConstraints = NO;
    self.fromAmountTF.inputView = decimalKeyboard;
    self.toAmountTF.inputView = decimalKeyboard2;
}

- (void)getAllCurrencyDetails {
    self.allCurrencyList = nil;
    GetC2CExchangeRequest *request = [GetC2CExchangeRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyExchangeInfo class] success:^(NSArray* response) {
        self.allCurrencyListResponse = response;
        if(self.allCurrencyListResponse.count > 0) {
            CurrencyExchangeInfo *item2 = [[CurrencyExchangeInfo alloc] init];
            for (CurrencyExchangeInfo *item in self.allCurrencyListResponse) {
                [self.allCurrencyList addObject:item];
                item2 = [item mutableCopy];
                item2.fromCode = item.toCode;
                item2.toCode = item.fromCode;
                item2.fromInfo = item.toInfo;
                NSDecimalNumber *decimalOne = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:NO];
                if (![item.buyPrice isEqualToNumber:[NSDecimalNumber zero]]) {
                    item2.sellPrice = [decimalOne decimalNumberByDividingBy:item.buyPrice];
                }else {
                    item2.sellPrice = [NSDecimalNumber zero];
                }
                item2.toInfo = item.fromInfo;
                item2.handlingFee = item.handlingFee;
                item2.max = item.max;
                item2.min = item.min;
                [self.allCurrencyList addObject:item2];
            }
            [self getUserAvailableAllCurrency];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (void)getUserAvailableAllCurrency {
    self.userAvailableCurrencyLit = nil;
    self.createdAllFromCurrencyList = nil;
    self.createdFromCurrencyList = nil;
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        self.userAvailableCurrencyLit = response;
        if([self.userAvailableCurrencyLit count] > 0 && [self.allCurrencyList count] > 0) {
            for (CurrencyExchangeInfo *currencyExchangeItem in self.allCurrencyList) {
                currencyExchangeItem.serviceCharge = [NSDecimalNumber zero];
                for(C2CBalanceListInfo *availableCurrency in self.userAvailableCurrencyLit) {
                    if(availableCurrency.code == currencyExchangeItem.fromCode) {
                        currencyExchangeItem.serviceCharge = availableCurrency.money;
                        break;
                    }
                }
                [self.createdFromCurrencyList addObject:currencyExchangeItem];
                if([self.createdFromCurrencyList count] == 1) {
                    [self setDefaultCurrencyTypes];
                }
                CurrencyInfo *currencyInfo = [[CurrencyInfo alloc]init];
                currencyInfo.symbol = currencyExchangeItem.fromInfo.symbol;
                currencyInfo.code = currencyExchangeItem.fromCode;
                currencyInfo.icon = currencyExchangeItem.fromInfo.icon;
                currencyInfo.type = [currencyExchangeItem.serviceCharge stringValue];
                if(self.createdAllFromCurrencyList.count < 1) {
                    [self.createdAllFromCurrencyList addObject:currencyInfo];
                }else {
                    BOOL isUnAvailable = NO;
                    for(CurrencyInfo *createdAllFromCurrency in self.createdAllFromCurrencyList) {
                        if(createdAllFromCurrency.code == currencyInfo.code) {
                            isUnAvailable = NO;
                            break;
                        }else {
                            isUnAvailable = YES;
                        }
                    }
                    if(isUnAvailable) {
                        [self.createdAllFromCurrencyList addObject:currencyInfo];
                    }
                }
            }
        }
    }failure:^(NetworkErrorInfo * _Nonnull info) {
        NSLog(@"Message of network error: %@", info);
    }];
}

- (void)setDefaultCurrencyTypes {
    if (self.hardC) {
        for (CurrencyExchangeInfo *currencyExchangeItem in self.allCurrencyList) {
            if([currencyExchangeItem.fromCode isEqualToString:@"USDT"] && [currencyExchangeItem.toCode isEqualToString:@"CNT"]) {
                self.currentCurrencyExchangeObject = currencyExchangeItem;
                break;
            }
        }
        if(self.currentCurrencyExchangeObject != nil) {
            self.fromCurrencyType.text = self.currentCurrencyExchangeObject.fromCode;
            self.selectedFromData = self.currentCurrencyExchangeObject.fromInfo;
            self.toCurrencyType.text = self.currentCurrencyExchangeObject.toCode;
            self.selectedToData = self.currentCurrencyExchangeObject.toInfo;
            NSData * fromImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.currentCurrencyExchangeObject.fromInfo.icon]];
            self.fromCurrencyIcon.image = [UIImage imageWithData: fromImageData];
            NSData * toImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.currentCurrencyExchangeObject.toInfo.icon]];
            self.toCurrencyIcon.image = [UIImage imageWithData: toImageData];
            self.fromAmountTF.placeholder = [NSString stringWithFormat:@"%@ - %@", self.currentCurrencyExchangeObject.min, self.currentCurrencyExchangeObject.max];
            self.toAmountTF.text = self.hAmount;
            [self changeFromAmount];
            for (int i = 0; i < [self.userAvailableCurrencyLit count]; i++) {
                if(self.fromCurrencyType.text == self.currentCurrencyExchangeObject.fromCode){
                    self.availableAmountLabel.text = [self.userAvailableCurrencyLit[i].money stringValue];
                    break;
                }
            }
            [self checkingFromAmount];
        }
    }else {
        self.fromCurrencyType.text = self.createdFromCurrencyList[0].fromCode;
        self.selectedFromData = self.createdFromCurrencyList[0].fromInfo;
        self.toCurrencyType.text = self.createdFromCurrencyList[0].toCode;
        self.selectedToData = self.createdFromCurrencyList[0].toInfo;
        NSData * fromImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.createdFromCurrencyList[0].fromInfo.icon]];
        self.fromCurrencyIcon.image = [UIImage imageWithData: fromImageData];
        NSData * toImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:  self.createdFromCurrencyList[0].toInfo.icon]];
        self.toCurrencyIcon.image = [UIImage imageWithData: toImageData];
        self.fromAmountTF.placeholder = [NSString stringWithFormat:@"%@ - %@", self.createdFromCurrencyList[0].min,  self.createdFromCurrencyList[0].max];
        self.currentCurrencyExchangeObject = self.createdFromCurrencyList[0];
        for (int i = 0; i < [self.userAvailableCurrencyLit count]; i++) {
            if(self.fromCurrencyType.text == self.userAvailableCurrencyLit[i].code){
                self.availableAmountLabel.text = [self.userAvailableCurrencyLit[i].money stringValue];
                break;
            }
        }
    }
}

- (IBAction)changeFromCurrencyType:(id)sender {
    if ([self.createdFromCurrencyList count] > 0) {
        IcanWalletSelectVirtualViewController * vc = [[IcanWalletSelectVirtualViewController alloc]init];
        vc.type = IcanWalletSelectVirtualTypeAvailabalCurrency;
        vc.fromOrToCurrencyList = self.createdAllFromCurrencyList;
        vc.selectBlock = ^(CurrencyInfo *_Nonnull info) {
            self.selectCurrencyInfo = info;
            self.fromCurrencyType.text = info.code;
            self.selectedFromData = info;
            [self.fromCurrencyIcon setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
            self.availableAmountLabel.text = self.selectCurrencyInfo.type;
            [self checkCurrentCurrencyObject];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.errorLabel.hidden = NO;
    }
}

- (IBAction)switchActionData:(id)sender {
    self.availableAmountLabel.text = @"0.00";
    CurrencyInfo *selectedFromDataVal = self.selectedFromData;
    self.selectedFromData = self.selectedToData;
    self.selectedToData = selectedFromDataVal;
    [self.fromCurrencyIcon setImageWithString:self.selectedFromData.icon placeholder:@"icon_c2c_currency_default"];
    self.fromCurrencyType.text = self.selectedFromData.code;
    self.toCurrencyType.text = self.selectedToData.code;
    self.availableAmountLabel.text = self.selectedFromData.type;
    [self.toCurrencyIcon setImageWithString:self.selectedToData.icon placeholder:@"icon_c2c_currency_default"];
    for (int i = 0; i < [self.userAvailableCurrencyLit count]; i++) {
        if(self.fromCurrencyType.text == self.userAvailableCurrencyLit[i].code){
            self.availableAmountLabel.text = [self.userAvailableCurrencyLit[i].money stringValue];
            break;
        }else{
            self.availableAmountLabel.text = @"0.00";
        }
    }
    [self checkCurrentCurrencyObject];
}

- (void)checkCurrentCurrencyObject {
    self.errorLabel.hidden = self.toErrorLabel.hidden = YES;
    [self emptyingAmount];
    if ([self.fromCurrencyType.text isEqualToString:self.toCurrencyType.text]) {
        for (CurrencyExchangeInfo *createdFromCurrency in self.createdFromCurrencyList) {
            if ([self.fromCurrencyType.text isEqual:createdFromCurrency.fromCode]) {
                self.toCurrencyType.text = createdFromCurrency.toCode;
                NSData *toImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:createdFromCurrency.toInfo.icon]];
                self.toCurrencyIcon.image = [UIImage imageWithData: toImageData];
                break;
            }
        }
    }
    for(CurrencyExchangeInfo *currencyExchangeInfo in self.allCurrencyList) {
        if(![self.fromCurrencyType.text isEqual:@""] && ![self.toCurrencyType.text isEqual:@""]) {
            if ([self.fromCurrencyType.text isEqualToString:currencyExchangeInfo.fromCode] && [self.toCurrencyType.text isEqualToString:currencyExchangeInfo.toCode]) {
                self.currentCurrencyExchangeObject = currencyExchangeInfo;
                break;
            }else{
                self.currentCurrencyExchangeObject = nil;
            }
        }
    }
    if(self.currentCurrencyExchangeObject == nil) {
        self.MaxBtn.enabled = false;
        [QMUITipsTool showOnlyTextWithMessage:@"PairNotSupported".icanlocalized inView:self.view];
        self.fromAmountTF.placeholder = @"";
    }else{
        self.MaxBtn.enabled = true;
        self.fromAmountTF.placeholder = [NSString stringWithFormat:@"%@ - %@", self.currentCurrencyExchangeObject.min,  self.currentCurrencyExchangeObject.max];
    }
}

- (IBAction)setMaxCurrencyAmount:(id)sender {
    self.fromAmountTF.text = self.availableAmountLabel.text;
    [self changeToAmount];
    [self checkingFromAmount];
}

- (void)changeToAmount {
    float toAmount = [self.fromAmountTF.text floatValue] * [self.currentCurrencyExchangeObject.sellPrice floatValue];
    self.toAmountTF.text =  [[NSNumber numberWithFloat:toAmount] stringValue];
}

- (void)removeFromAmountError {
    self.errorLabel.hidden = YES;
    [self.fromView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
}

- (void)emptyingAmount {
    self.fromAmountTF.text = @"";
    self.toAmountTF.text = @"";
}

- (void)removeToAmountError {
    self.toErrorLabel.hidden = YES;
}

- (IBAction)changeToCurrencyType:(id)sender {
    self.createdAllToCurrencyList = nil;
    if ([self.allCurrencyList count] > 0) {
        for (int i=0; i<[self.allCurrencyList count]; i++) {
            CurrencyInfo *currencyInfo = [[CurrencyInfo alloc]init];
            if(![self.allCurrencyList[i].fromCode isEqual:self.fromCurrencyType.text]){
                currencyInfo.symbol = self.allCurrencyList[i].fromInfo.symbol;
                currencyInfo.code = self.allCurrencyList[i].fromCode;
                currencyInfo.icon = self.allCurrencyList[i].fromInfo.icon;
                currencyInfo.type = [self.allCurrencyList[i].serviceCharge stringValue];
                if ([self.createdAllToCurrencyList count] > 0) {
                    int isHereCount = 0;
                    for (int j=0; j< [self.createdAllToCurrencyList count]; j++) {
                        if ([currencyInfo.code isEqual:self.createdAllToCurrencyList[j].code]) {
                            isHereCount = 1;
                        }
                    }
                    if (isHereCount == 0) {
                        [self.createdAllToCurrencyList addObject:currencyInfo];
                    }
                }else{
                    [self.createdAllToCurrencyList addObject:currencyInfo];
                }
            }
        }
    }
    if ([self.createdAllToCurrencyList count] > 0) {
        IcanWalletSelectVirtualViewController *vc = [[IcanWalletSelectVirtualViewController alloc]init];
        vc.type = IcanWalletSelectVirtualTypeAllCurrency;
        vc.fromOrToCurrencyList = self.createdAllToCurrencyList;
        vc.selectBlock = ^(CurrencyInfo *_Nonnull info) {
            self.selectCurrencyInfo = info;
            self.selectedToData = info;
            self.toCurrencyType.text = info.code;
            [self.toCurrencyIcon setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
            [self checkCurrentCurrencyObject];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.toErrorLabel.hidden = NO;
        self.toErrorLabel.text = @"Not Available other Currency";
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeToAmountError) userInfo:nil repeats:NO];
    }
}

- (IBAction)previewConverstion:(id)sender {
    [self.view endEditing:YES];
    self.flashExchangeConfirmView.currentCurrencyExchangeObject = self.currentCurrencyExchangeObject;
    self.flashExchangeConfirmView.fromAmount = self.fromAmountTF.text;
    self.flashExchangeConfirmView.toAmount = self.toAmountTF.text;
    [self.flashExchangeConfirmView showView];
}

- (IBAction)editingDidBeginFromAmount:(id)sender {
    [self removeFromAmountError];
}

- (IBAction)changingFromAmount:(id)sender {
    if(self.currentCurrencyExchangeObject == nil){
        self.MaxBtn.enabled = false;
        [QMUITipsTool showOnlyTextWithMessage:@"PairNotSupported".icanlocalized inView:self.view];
        self.fromAmountTF.text = @"";
    }else{
        self.MaxBtn.enabled = true;
    }
    [self checkingFromAmount];
    [self changeToAmount];
    if ([self.fromAmountTF.text isEqual:@""]) {
        self.toAmountTF.text = @"";
    }
}

- (void)checkingFromAmount {
    self.fromAmountTF.floatLenth = 8;
    if([self.fromAmountTF.text floatValue] > [self.availableAmountLabel.text floatValue]) {
        self.previewConverstionBtn.enabled = NO;
        self.errorLabel.hidden = NO;
        self.errorLabel.text = @"NotEnoughBalance".icanlocalized;
        [self.fromView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
        return;
    }else{
        self.previewConverstionBtn.enabled = YES;
        [self removeFromAmountError];
    }
    if([self.fromAmountTF.text floatValue] > [_currentCurrencyExchangeObject.max floatValue] && ![self.fromAmountTF.text isEqual: @""]) {
        self.previewConverstionBtn.enabled = NO;
        self.errorLabel.hidden = NO;
        self.errorLabel.text = [NSString stringWithFormat:@"%@ %@",@"MaximumAmount".icanlocalized ,_currentCurrencyExchangeObject.max];
        [self.fromView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
        return;
    }else if([self.fromAmountTF.text floatValue] < [_currentCurrencyExchangeObject.min floatValue] && ![self.fromAmountTF.text isEqual: @""]) {
        self.previewConverstionBtn.enabled = NO;
        self.errorLabel.hidden = NO;
        self.errorLabel.text = [NSString stringWithFormat:@"%@ %@",@"MinimumAmount".icanlocalized, _currentCurrencyExchangeObject.min];
        [self.fromView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(239, 51, 79)];
        return;
    }else if([self.fromAmountTF.text isEqual: @""]){
        self.previewConverstionBtn.enabled = NO;
        [self removeFromAmountError];
    }else{
        self.previewConverstionBtn.enabled = YES;
        [self removeFromAmountError];
    }
}

- (IBAction)editingDidBeginToAmount:(id)sender {
    [self removeFromAmountError];
}

- (IBAction)changingToAmount:(id)sender {
    [self changeFromAmount];
}

- (void)changeFromAmount {
    if(self.currentCurrencyExchangeObject == nil){
        self.MaxBtn.enabled = false;
        [QMUITipsTool showOnlyTextWithMessage:@"PairNotSupported".icanlocalized inView:self.view];
        self.toAmountTF.text = @"";
    }else{
        self.MaxBtn.enabled = true;
    }
    self.toAmountTF.floatLenth = 8;
    float fromAmount = [self.toAmountTF.text floatValue] / [self.currentCurrencyExchangeObject.sellPrice floatValue];
    self.fromAmountTF.text =  [[NSNumber numberWithFloat:fromAmount] stringValue];
    [self checkingFromAmount];
    if ([self.toAmountTF.text isEqual:@""]) {
        self.fromAmountTF.text = @"";
        [self removeFromAmountError];
    }
}
@end


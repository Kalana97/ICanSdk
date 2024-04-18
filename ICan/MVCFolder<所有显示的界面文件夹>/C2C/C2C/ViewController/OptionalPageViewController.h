//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyPageViewController.h
- Description:
- Function List:
*/
        

#import "WMPageController.h"
#import "C2COOptionalFilterAmountPopView.h"
#import "C2COOptionalFilterTradingPopView.h"
#import "C2COOptionalFilterPopView.h"
#import "SelectCurrencyDropDownView.h"
NS_ASSUME_NONNULL_BEGIN

@interface OptionalPageViewController : WMPageController
/** 是否是自选 我要买 */
@property(nonatomic, assign) BOOL isOptionBuy;
/** 当前已经选择的法币 */
@property (nonatomic, strong) CurrencyInfo *currencyInfo;
@property(nonatomic, strong) NSArray *titleItems;
@property(nonatomic, strong) C2COOptionalFilterAmountPopView *amountPopView;
@property(nonatomic, strong) C2COOptionalFilterTradingPopView *tradingPopView;
@property(nonatomic, strong) C2COOptionalFilterPopView *popView;
@property(nonatomic, strong) SelectCurrencyDropDownView *currencyView;
-(void)reloadPageView;
@end

NS_ASSUME_NONNULL_END

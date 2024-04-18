//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.h
- Description:自选列表的头部筛选View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2COOptionalFilterHeadView : UIView
/** 交易类型的title */
@property(nonatomic, copy) NSString *paymentMethodType;
/** 交易类型的title */
@property (weak, nonatomic) IBOutlet UIImageView *selectedCurrencyImg;
@property (weak, nonatomic) IBOutlet UILabel *selectedCurrency;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) void (^tapAmountBlock)(void);
@property(nonatomic, copy) void (^tapTradingBlock)(void);
@property(nonatomic, copy) void (^tapFilterBlock)(void);
@property(nonatomic, copy) void (^tapCurrencyBlock)(void);
@end

NS_ASSUME_NONNULL_END

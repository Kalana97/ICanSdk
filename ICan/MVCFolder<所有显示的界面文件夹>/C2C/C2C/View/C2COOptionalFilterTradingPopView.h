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

@interface C2COOptionalFilterTradingPopView : UIView
@property(nonatomic, copy) void (^selectBlock)(NSString*tradingTitle);
@property(nonatomic, copy) void (^hiddenBlock)(void);
/** 交易类型的title */
@property(nonatomic, copy) NSString *paymentMethodType;
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END

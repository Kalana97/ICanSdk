//
//  FlashExchangeConfirmView.h
//  ICan
//
//  Created by MAC on 2022-08-19.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlashExchangeConfirmView : UIView
@property(nonatomic, strong) CurrencyExchangeInfo *currentCurrencyExchangeObject;
@property(nonatomic, strong) NSString *fromAmount;
@property(nonatomic, strong) NSString *toAmount;
@property(nonatomic, copy) void (^sureBlock)(void);

-(void)hiddenView;
-(void)showView;

@end

NS_ASSUME_NONNULL_END

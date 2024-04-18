//
//  FlashExchangeViewController.h
//  ICan
//
//  Created by mansa on 08/08/22.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlashExchangeViewController : BaseViewController
@property(nonatomic, strong) C2CBalanceListInfo *balanceInfo;
@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property(nonatomic, assign) BOOL hardC;
@property(nonatomic, assign) NSString *hAmount;
@end

NS_ASSUME_NONNULL_END

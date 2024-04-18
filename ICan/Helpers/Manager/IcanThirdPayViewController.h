//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 29/3/2022
- File name:  IcanThirdPayViewController.h
- Description:第三方支付
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanThirdPayViewController : BaseViewController
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@property(nonatomic, strong) NSArray<C2CBalanceListInfo*> *assetItems;
@property(nonatomic, strong) C2CPreparePayOrderDetailInfo *prepareDetailInfo;
@property(nonatomic, copy)   NSString *appId;
@property(nonatomic, strong) NSArray<C2CExchangeRateInfo*> *allExchangeRateItems;
@end

NS_ASSUME_NONNULL_END

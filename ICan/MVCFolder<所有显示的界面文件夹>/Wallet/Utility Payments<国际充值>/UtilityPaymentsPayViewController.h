//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/4/2021
- File name:  UtilityPaymentsPayViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UtilityPaymentsPayViewController : BaseViewController
@property(nonatomic, assign) BOOL isFromFavorite;
@property(nonatomic, strong) DialogListInfo *dialogInfo;
@property(nonatomic, strong) NSString *currencyCodeVal;
@property(nonatomic, strong) NSString *countryCode;
@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property(nonatomic, strong) C2CBalanceListInfo *currentInfo;
@end

NS_ASSUME_NONNULL_END

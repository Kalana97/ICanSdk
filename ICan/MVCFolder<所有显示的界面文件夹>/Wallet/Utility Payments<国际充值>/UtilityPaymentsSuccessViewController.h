//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/4/2021
- File name:  UtilityPaymentsSuccessViewController.h
- Description:充值成功
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UtilityPaymentsSuccessViewController : BaseViewController
@property(nonatomic, strong) DialogPaymentInfo *dialogPaymentInfo;
@property(nonatomic, strong) DialogListInfo *dialogInfo;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, assign) BOOL isFromFavorite;
@property(nonatomic, assign) BOOL isStatusPending;
@property(nonatomic, strong)  RechargeChannelInfo *selectChannelInfo;
//是否需要判断在收藏夹里面
@property(nonatomic, assign) BOOL shouldCheck;
@end

NS_ASSUME_NONNULL_END

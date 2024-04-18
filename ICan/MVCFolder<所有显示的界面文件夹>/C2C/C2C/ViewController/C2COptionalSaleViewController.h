//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/11/2021
- File name:  C2CPublishAdvertFirstStepViewController.h
- Description:C2C自选 我要卖 的详情界面
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2COptionalSaleViewController : QDCommonViewController
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
@property(nonatomic, assign) BOOL isBuy;
@end

NS_ASSUME_NONNULL_END

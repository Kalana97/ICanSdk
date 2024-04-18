//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/11/2021
- File name:  C2CPublishAdvertFirstStepViewController.h
- Description:广告->发布广告第一步
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CPublishAdvertSecondStepViewController : QDCommonViewController
/** 当前的汇率 */
@property(nonatomic, strong) C2CExchangeRateInfo *selectExchangeRateInfo;
@property(nonatomic, strong) C2CPublishAdvertRequest *publishAdvertRequest;
@property(nonatomic, strong) C2CAdverInfo *adverInfo;
@end

NS_ASSUME_NONNULL_END

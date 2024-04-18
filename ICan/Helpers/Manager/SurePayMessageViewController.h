//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/3/2021
- File name:  SurePayMessageViewController.h
- Description:从商城跳转过来的请求支付的页面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SurePayMessageViewController : BaseViewController
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *payId;
@property(nonatomic, strong) PreparePayOrderDetailInfo *detailInfo;

@property(nonatomic, copy) void (^payBlock)(void);
@property(nonatomic, copy) void (^cancelBlock)(void);
@end

NS_ASSUME_NONNULL_END

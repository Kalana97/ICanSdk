//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  BuyPackageViewController.h
- Description:购买套餐的页面
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyPackageViewController : QDCommonViewController
@property(nonatomic, copy) void (^buySuccessBlock)(NSString*transactionId);
@end

NS_ASSUME_NONNULL_END

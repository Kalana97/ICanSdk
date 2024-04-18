//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/6/2021
- File name:  PayStatusViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayStatusViewController : QDCommonViewController
@property(nonatomic, strong) PreparePayOrderDetailInfo *detailInfo;
@property(nonatomic, copy)   NSString *backUrl;
@property(nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END

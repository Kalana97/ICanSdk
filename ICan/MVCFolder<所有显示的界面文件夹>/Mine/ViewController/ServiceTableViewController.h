//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  ServiceTableViewController.h
- Description: 客服列表
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceTableViewController : QDCommonTableViewController
@property(nonatomic, strong) CustomerServicesInfo *info;
@end

NS_ASSUME_NONNULL_END

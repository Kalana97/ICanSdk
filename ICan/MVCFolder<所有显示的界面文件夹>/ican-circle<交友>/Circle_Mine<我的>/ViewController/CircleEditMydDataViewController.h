//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleEditMydDataViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleEditMydDataViewController : QDCommonViewController
@property(nonatomic, assign) BOOL isEidt;
@property(nonatomic, assign) AddressViewType addressViewType;
@property(nonatomic, copy) void (^editSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END

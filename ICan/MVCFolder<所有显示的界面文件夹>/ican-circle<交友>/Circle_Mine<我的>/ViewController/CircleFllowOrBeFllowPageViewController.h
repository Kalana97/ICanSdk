//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 13/7/2021
- File name:  CircleFllowOrBeFllowPageViewController.h
- Description:
- Function List:
*/
        

#import "WMPageController.h"
#import "CircleFllowOrBeFllowListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CircleFllowOrBeFllowPageViewController : WMPageController
-(instancetype)initWithCircleListType:(CircleListType)type;
@property(nonatomic, assign) CircleListType type;
@end

NS_ASSUME_NONNULL_END

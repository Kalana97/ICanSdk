//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- File name:  EditFastMessageViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditFastMessageViewController : BaseViewController
@property(nonatomic, strong) QuickMessageInfo *info;
@property(nonatomic, assign) NSString *directionInt; //1:New 2:Edit
@end

NS_ASSUME_NONNULL_END

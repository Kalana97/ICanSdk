//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 21/12/2020
- File name:  LoginViewController1.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController
@property(nonatomic, assign) BOOL showOtherLoginTips;
@property(nonatomic, strong) AllCountryInfo *autoSelectedCountryInfo;
@property(nonatomic, copy) NSString *tips;
@end

NS_ASSUME_NONNULL_END

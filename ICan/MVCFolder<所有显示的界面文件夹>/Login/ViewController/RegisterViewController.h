//
/**
- Copyright © 2020 limao01. All rights reserved.
- Author: Created  by DZL on 26/11/2020
- File name:  RegisterViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : BaseViewController
@property(nonatomic, assign) BOOL isRegister;
@property(nonatomic, strong) AllCountryInfo * selectCountryInfo ;
@property(nonatomic, copy) void (^registerSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2019
- File name:  SelectMobileCodeViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectMobileCodeViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectCodeBlock)(NSString*mobileCode);
/** 注册界面进来选择地区 */
@property(nonatomic, assign) BOOL isSelectArea;
@property(nonatomic, assign) BOOL  isTopUp;
@property(nonatomic, assign) BOOL  shouldShowFlag;
@property(nonatomic, copy) void (^selectAreaBlock)(AllCountryInfo*info);
@property(nonatomic,strong) NSArray <AllCountryInfo*> * sentListOfCountries;
@property(nonatomic, assign) BOOL isRecharge;
@property(nonatomic, assign) NSString *dialogClass;
@end

NS_ASSUME_NONNULL_END

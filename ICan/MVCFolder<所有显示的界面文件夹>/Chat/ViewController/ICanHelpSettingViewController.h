//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/5/2020
- File name:  ICanHelpSettingViewController.h
- Description:  支付助手设置界面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ICanHelpSettingType){
    ICanHelpSettingTypePay,
    ICanHelpSettingTypeSystem,
    ICanHelpSettingTypeAnnouncement,
    ICanHelpSettingTypeC2C,
    ICanHelpSettingTypeNoticeOTP,
};
@interface ICanHelpSettingViewController : BaseViewController
@property (nonatomic,copy) void (^deleteMessageBlock)(void);
@property (nonatomic, assign) BOOL isSystemHelper;
@property (nonatomic, assign) ICanHelpSettingType type;
@end

NS_ASSUME_NONNULL_END

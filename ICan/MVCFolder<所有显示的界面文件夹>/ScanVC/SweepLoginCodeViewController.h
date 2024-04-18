//扫码登录
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 25/12/2019
- File name:  SweepLoginCodeViewController.h
- Description:扫码登录
- Function List:Login=41d7f0cecaa74a0790c899ed80f7e632”(Login=32为UUID)
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SweepLoginCodeViewController : BaseViewController
/** 是否登录客户端 */
@property(nonatomic, assign) BOOL isLoginClient;
@property(nonatomic, copy) NSString *uuId;
@property(nonatomic, copy) void (^dimssBlock)(void);
@end

NS_ASSUME_NONNULL_END

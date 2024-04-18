//
//  BusinessDetailsViewController.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-16.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "QDCommonViewController.h"
#import "BusinessUserResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessDetailsViewController : QDCommonViewController
@property(nonatomic, strong) BusinessCurrentUserInfo *userInfo;
@property(nonatomic, assign) NSInteger businessId;
@property(nonatomic, copy) void (^fllowBlock)(void);
@end

NS_ASSUME_NONNULL_END

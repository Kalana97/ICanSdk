//
//  UserProfileVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileVC : BaseViewController
@property(nonatomic, strong) MemebersResponseInfo *memberInfo;
@property (nonatomic, strong) OrganizationDetailsInfo *organizationInfoModel;
@end

NS_ASSUME_NONNULL_END

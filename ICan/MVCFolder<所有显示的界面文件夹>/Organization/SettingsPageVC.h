//
//  SettingsPageVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-22.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsPageVC : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) OrganizationDetailsInfo *organizationInfoModel;
@property (nonatomic,copy) void (^goBackData)(OrganizationDetailsInfo *modelData);
@property(nonatomic, strong) NSString *headImgUrl;
@end

NS_ASSUME_NONNULL_END

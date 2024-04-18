//
//  MainPageVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPageVC : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) OrganizationDetailsInfo *organizationInfoModel;
@property (nonatomic, assign) BOOL needBack;
@end

NS_ASSUME_NONNULL_END

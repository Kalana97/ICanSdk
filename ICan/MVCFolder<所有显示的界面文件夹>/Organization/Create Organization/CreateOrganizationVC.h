//
//  CreateOrganizationVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrganizationVC : BaseViewController <UITextFieldDelegate>
@property(nonatomic, strong) AllCountryInfo *selectCountryInfo;
@property(nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) OrganizationDetailsInfo *organizationInfoModel;
@end

NS_ASSUME_NONNULL_END

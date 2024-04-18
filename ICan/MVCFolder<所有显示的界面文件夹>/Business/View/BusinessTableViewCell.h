//
//  BusinessTableViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BaseCell.h"
#import "BusinessUserResponse.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const kBusinessTableViewCell = @"BusinessTableViewCell";
@interface BusinessTableViewCell : BaseCell
@property(nonatomic, strong) BusinessUserInfo *userInfo;
@end

NS_ASSUME_NONNULL_END

//
//  BusinessMineHeadView.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-20.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessUserResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessMineHeadView : UITableViewHeaderFooterView
@property (nonatomic, strong) BusinessCurrentUserInfo *userInfo;
@property (nonatomic, copy) void (^clickEditBlock)(void);
@property (nonatomic, copy) void (^showAllBlock)(void);
@property (nonatomic, copy) void (^buyBlock)(void);
@property (nonatomic, copy) void (^editIconBlock)(void);
@property (nonatomic, copy) void (^editBgImgBlock)(void);
@property (nonatomic, copy) void (^addImageBlock)(void);
@end
NS_ASSUME_NONNULL_END

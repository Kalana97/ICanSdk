//
//  BusinessMyImgViewController.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "QDCommonViewController.h"
#import "UploadImgModel.h"
#import "BusinessUserResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface BusinessMyImgViewController : QDCommonViewController
@property (nonatomic, strong) BusinessCurrentUserInfo *businessUserInfo;
@property (nonatomic, copy) void (^editSuccessBlock)(void);
@property (nonatomic, strong) NSMutableArray<UploadImgModel *> *selectPhotos;
@end

NS_ASSUME_NONNULL_END

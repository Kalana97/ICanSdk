//
//  BusinessAddPhotoViewController.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "QDCommonViewController.h"
#import "UploadImgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BusinessAddPhotoViewController : QDCommonViewController
@property (nonatomic, copy) void (^editSuccessBlock)(void);
@property (nonatomic, strong) NSMutableArray<UploadImgModel *> *selectPhotos;
@property (nonatomic, assign) BOOL isSinglePhoto;
@end

NS_ASSUME_NONNULL_END

//
//  BusinessListImageCollectionViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-08.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessUserResponse.h"
@class UploadImgModel;
NS_ASSUME_NONNULL_BEGIN
static NSString * const kBusinessListImageCollectionViewCell = @"BusinessListImageCollectionViewCell";
@interface BusinessListImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) UploadImgModel *model;
@property (weak, nonatomic) IBOutlet UIView *addBgView;
@property (nonatomic, copy) void (^deleteBlock)(UploadImgModel *model);
@property (nonatomic, copy) void (^selectBlock)(BusinessPhotoWallList *model);
@property (nonatomic, strong) BusinessPhotoWallList *wallInfo;
@property (nonatomic,assign) BOOL canSelect;
- (void)beginShake;
- (void)stopShake;
@end

NS_ASSUME_NONNULL_END

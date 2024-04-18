//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleUserDetailImgeCollectionViewCell.h
- Description:用户详情的imgcell
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class UploadImgModel;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kCircleUserDetailImgeCollectionViewCell = @"CircleUserDetailImgeCollectionViewCell";
@interface CircleUserDetailImgeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property(nonatomic, strong) UploadImgModel *model;
@property (weak, nonatomic) IBOutlet UIView *addBgView;
@property(nonatomic, copy) void (^deleteBlock)(UploadImgModel*model);
@property(nonatomic, copy) void (^selectBlock)(PhotoWallInfo*model);
@property(nonatomic, strong) PhotoWallInfo *wallInfo;
/** 当前是否可以选择图片 */
@property(nonatomic,assign) BOOL canSelect;
- (void)beginShake;
- (void)stopShake;
@end


NS_ASSUME_NONNULL_END

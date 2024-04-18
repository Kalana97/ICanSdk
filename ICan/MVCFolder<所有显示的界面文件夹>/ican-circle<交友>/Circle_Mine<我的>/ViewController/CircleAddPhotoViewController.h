//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/7/2021
- File name:  CircleMyImgViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"
#import "UploadImgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CircleAddPhotoViewController : QDCommonViewController
@property(nonatomic, copy) void (^editSuccessBlock)(void);
/** 当前从相册选择的照片数组 */
@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectPhotos;
@end

NS_ASSUME_NONNULL_END

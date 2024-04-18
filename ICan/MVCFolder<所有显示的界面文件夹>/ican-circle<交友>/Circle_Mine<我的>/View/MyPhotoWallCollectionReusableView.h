//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/10/2021
- File name:  MyPhotoWallCollectionReusableView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kMyPhotoWallCollectionReusableView = @"MyPhotoWallCollectionReusableView";
@interface MyPhotoWallCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END

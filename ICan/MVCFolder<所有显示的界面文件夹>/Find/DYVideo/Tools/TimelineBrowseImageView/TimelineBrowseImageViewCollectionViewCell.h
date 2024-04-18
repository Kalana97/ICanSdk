//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/8/2020
- File name:  TimelineBrowseImageViewCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const kTimelineBrowseImageViewCollectionViewCell = @"TimelineBrowseImageViewCollectionViewCell";
@interface TimelineBrowseImageViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageVIew;
@property(nonatomic, copy) NSString *imageUrl;
@end

NS_ASSUME_NONNULL_END

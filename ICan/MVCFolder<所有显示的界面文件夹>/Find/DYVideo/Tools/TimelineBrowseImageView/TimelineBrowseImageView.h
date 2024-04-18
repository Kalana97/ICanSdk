//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/8/2020
- File name:  TimelineBrowseImageView.h
- Description:显示图片的View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimelineBrowseImageView : UIView
@property(nonatomic, strong) NSArray *imageItems;
@property(nonatomic, strong) TimelinesListDetailInfo *timeLineInfo;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 21/4/2020
- File name:  TimeLineRecommendCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const kTimeLineRecommendCollectionViewCell = @"TimeLineRecommendCollectionViewCell";
@interface TimeLineRecommendCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UserLocationNearbyInfo *nearbyInfo;
@property(nonatomic, strong) UserRecommendListInfo *recommendInfo;
@property(nonatomic, copy) void (^buttonBlock)(id info ,NSInteger tag);
@end

NS_ASSUME_NONNULL_END

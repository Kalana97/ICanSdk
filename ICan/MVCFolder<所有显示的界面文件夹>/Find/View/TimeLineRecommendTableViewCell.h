//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 21/4/2020
- File name:  TimeLineRecommendTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kTimeLineRecommendTableViewCell = @"TimeLineRecommendTableViewCell";
static CGFloat const kHeightTimeLineRecommendTableViewCell = 330;
@interface TimeLineRecommendTableViewCell : BaseCell
@property(nonatomic, strong) NSArray *items;
@end

NS_ASSUME_NONNULL_END

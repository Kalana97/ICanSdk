//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/5/2021
- File name:  CircleHomeConditionCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class ConditionModel;
NS_ASSUME_NONNULL_BEGIN
static NSString * const kCircleHomeConditionCollectionViewCell = @"CircleHomeConditionCollectionViewCell";
@interface CircleHomeConditionCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) ConditionModel *conditionModel;
@end

NS_ASSUME_NONNULL_END

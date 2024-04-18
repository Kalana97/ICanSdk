//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleHobbyCollectionViewCell.h
- Description:显示爱好的cell
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kCircleHobbyCollectionViewCell = @"CircleHobbyCollectionViewCell";
@interface CircleHobbyCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) HobbyTagsInfo *tagsInfo;
@property(nonatomic, copy) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleSelectHobbyTbleViewCell.h
- Description:选择爱好的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kCircleSelectHobbyTbleViewCell = @"CircleSelectHobbyTbleViewCell";
@interface CircleSelectHobbyTbleViewCell : BaseCell
@property(nonatomic, strong) HobbyTagsInfo *hobbyInfo;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/10/2019
- File name:  LeftImageRightArrowTableViewCell.h
- Description: 左边是图片加文字右边是剪头
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kLeftImageRightArrowTableViewCell = @"LeftImageRightArrowTableViewCell";
static CGFloat const kHeightLeftImageRightArrowTableViewCell = 50;
@interface LeftImageRightArrowTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic,strong)RechargeChannelInfo *rechargeChannelInfo;

@end

NS_ASSUME_NONNULL_END

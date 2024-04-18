//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/10/2019
- File name:  RightArrowTableViewCell.h
- Description: 左边和右边都是文字
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kRightArrowTableViewCell = @"RightArrowTableViewCell";
static CGFloat const kHeightRightArrowTableViewCell = 50;
@interface RightArrowTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *rightIntervalView;
@property (weak, nonatomic) IBOutlet DZIconImageView *flagImg;
@end

NS_ASSUME_NONNULL_END

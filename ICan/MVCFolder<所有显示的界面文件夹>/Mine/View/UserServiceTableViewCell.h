//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  UserServiceTableViewCell.h
- Description: 客服列表的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kUserServiceTableViewCell = @"UserServiceTableViewCell";
static CGFloat const kHeightUserServiceTableViewCell = 55;
@interface UserServiceTableViewCell : BaseCell

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) ServicesInfo *servicesInfo;

@end

NS_ASSUME_NONNULL_END

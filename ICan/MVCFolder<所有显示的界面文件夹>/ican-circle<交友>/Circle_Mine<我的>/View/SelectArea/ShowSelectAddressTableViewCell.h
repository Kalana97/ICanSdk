//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  ShowSelectAddressTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kShowSelectAddressTableViewCell = @"ShowSelectAddressTableViewCell";
@interface ShowSelectAddressTableViewCell : BaseCell
@property(nonatomic, strong) AreaInfo *areaInfo;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 29/3/2022
- File name:  IcanThirdPayTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanThirdPayTableViewCell = @"IcanThirdPayTableViewCell";
@interface IcanThirdPayTableViewCell : BaseCell
@property(nonatomic, strong) C2CBalanceListInfo *assetInfo;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@end

NS_ASSUME_NONNULL_END

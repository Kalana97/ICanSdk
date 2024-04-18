//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2020
- File name:  UpDownLineFirstTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kUpDownLineFirstTableViewCell = @"UpDownLineFirstTableViewCell";
@interface UpDownLineFirstTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *xuhaoLa;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLa;
@property (weak, nonatomic) IBOutlet UILabel *IDLa;

@end

NS_ASSUME_NONNULL_END

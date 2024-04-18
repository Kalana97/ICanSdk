//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2020
- File name:  UpDownLineTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"
@class UserMessageInfo;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kUpDownLineTableViewCell = @"UpDownLineTableViewCell";
@interface UpDownLineTableViewCell : BaseCell
/** 序号 */
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic, strong) BeInvitedInfo *beInvitedInfo;

@end

NS_ASSUME_NONNULL_END

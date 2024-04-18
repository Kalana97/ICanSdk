//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 7/4/2020
- File name:  RedPacketDetailMemberTableViewCell.h
- Description: 领取详情的人数的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kRedPacketDetailMemberTableViewCell = @"RedPacketDetailMemberTableViewCell";
static CGFloat const KHeightRedPacketDetailMemberTableViewCell = 65.0f;
@interface RedPacketDetailMemberTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *goodLuckImageView;
@property (weak, nonatomic) IBOutlet DZIconImageView *receiveIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLucketLabel;
@property(nonatomic, strong) RedPacketDetailMemberInfo *redPacketDetailMemberInfo;

@end

NS_ASSUME_NONNULL_END

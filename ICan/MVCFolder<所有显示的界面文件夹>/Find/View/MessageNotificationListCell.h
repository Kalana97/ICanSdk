//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  MessageNotificationListCell.h
- Description:帖子消息通知页面的cell
- Function List:
*/
        

#import "BaseCell.h"
@class TimeLineNoticeInfo;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kMessageNotificationListCell = @"MessageNotificationListCell";
static CGFloat const KHeightMessageNotificationListCell = 80;
@interface MessageNotificationListCell : BaseCell
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) TimeLineNoticeInfo *timeline;
@property(nonatomic, copy) void (^moreButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END

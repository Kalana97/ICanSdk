//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 13/8/2020
- File name:  DYTimelineShowContentTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kDYTimelineShowContentTableViewCell = @"DYTimelineShowContentTableViewCell";
@interface DYTimelineShowContentTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) TimelinesListDetailInfo *timelinesListDetailInfo;
@end

NS_ASSUME_NONNULL_END

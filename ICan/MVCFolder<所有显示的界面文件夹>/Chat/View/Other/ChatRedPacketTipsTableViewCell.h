//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/4/2020
- File name:  ChatRedPacketTipsTableViewCell.h
- Description: 显示红包提示语的cell
- Function List:
*/
        

#import "BaseCell.h"
#import "WCDBManager+ChatModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString* const kChatRedPacketTipsTableViewCell = @"ChatRedPacketTipsTableViewCell";
@interface ChatRedPacketTipsTableViewCell : BaseCell
@property(nonatomic, assign) BOOL isShowSegmentationTime;
@property(nonatomic, copy) void (^tapBlock)(ChatModel*model);

- (void)setcurrentChatModel:(ChatModel *)currentChatModel isShowSegmentationTime:(BOOL)isShowSegmentationTime;
@end

NS_ASSUME_NONNULL_END

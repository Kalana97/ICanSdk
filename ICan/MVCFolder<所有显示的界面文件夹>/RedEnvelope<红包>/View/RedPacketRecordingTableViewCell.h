//
//  ReceiveRedRedcordingTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//  领取的红包记录listcell

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KReceiveRedRedcordingTableViewCell =@"RedPacketRecordingTableViewCell";
static CGFloat const KHeightReceiveRedRedcordingTableViewCell =55.0f;

@interface RedPacketRecordingTableViewCell : BaseCell


@property(nonatomic, strong) RedPacketRecordGrabInfo *redPacketRecordGrabInfo;
@property(nonatomic, strong) RedPacketRecordSendInfo *redPacketRecordSendInfo;
@end

NS_ASSUME_NONNULL_END

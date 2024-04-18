//
//  ReceiveRedRecordingHeaderView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//  收到的红包页面的头部视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceiveRedRecordingHeaderView : UIView
@property(nonatomic,copy) void(^showMoreTimeBlock)(void);
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic, strong) RedPacketSummaryInfo *redPacketSummaryInfo;

-(void)showGrabRedPacketTips;
-(void)showSendRedPacketTips;
@end

NS_ASSUME_NONNULL_END

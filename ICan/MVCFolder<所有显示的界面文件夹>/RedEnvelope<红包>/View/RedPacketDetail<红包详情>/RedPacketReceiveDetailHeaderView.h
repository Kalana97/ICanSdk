//
//  RedPacketReceiveDetailHeaderView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/3.
//  Copyright © 2020 dzl. All rights reserved.
//  领取的红包详情头部
//如果是已经领取的红包 那么显示高度为 350
//如果是没有领取到的红包高度为 260
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketReceiveDetailHeaderView : UIView
@property(nonatomic, strong) RedPacketDetailInfo *redPacketDetailInfo;
@property(nonatomic, strong) RedPacketDetailMemberListInfo *redPacketDetailMemberListInfo;
@end

NS_ASSUME_NONNULL_END

//
//  ReceivedRedRecordingViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//  ”收到的红包 和发送的红包“页面

#import "BaseTableListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketRecordingViewController : BaseTableListViewController
/** 当前是否是收到的红包 */
@property(nonatomic, assign) BOOL receive;
@end

NS_ASSUME_NONNULL_END

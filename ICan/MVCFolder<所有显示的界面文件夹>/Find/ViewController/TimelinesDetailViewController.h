//
//  TimelinesCommentViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimelinesDetailViewController : QDCommonTableViewController
@property(nonatomic, copy) NSString *messageId;
/** 是否是点击评论按钮进来详情的 */
@property(nonatomic, assign) BOOL tapCommentButton;

@property(nonatomic, strong) TimelinesListDetailInfo *timelinesListDetailInfo;
/** 做了点赞或者是评论的操作 */
@property(nonatomic, copy) void (^operateBlock)(TimelinesListDetailInfo*timelineDetailInfo);
/** 删除回调 */
@property(nonatomic, copy) void (^deleteMessageSuccessBlock)(TimelinesListDetailInfo*timelineDetailInfo);
/** 分享回调 */
@property(nonatomic, copy) void (^shareSuccessBlock)(TimelinesListDetailInfo*timelineDetailInfo);
@end

NS_ASSUME_NONNULL_END

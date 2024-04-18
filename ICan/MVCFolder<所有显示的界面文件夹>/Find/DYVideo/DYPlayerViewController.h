//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 11/8/2020
- File name:  DYPlayerViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"
#import "GKDYVideoView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DYPlayerViewControllerDelegate <NSObject>
@optional
-(void)operationTimeline:(TimelinesListDetailInfo*)timelinesListDetailInfo;
@end
@interface DYPlayerViewController : QDCommonViewController

@property(nonatomic, assign) TimelineType timelineType;
/** 分享回调 */
@property(nonatomic, copy)   void (^shareSuccessBlock)(TimelinesListDetailInfo*timelineDetailInfo);
@property(nonatomic, strong) GKDYVideoView *videoView;
@property(nonatomic, strong) TimelinesListDetailInfo *detailInfo;
@property(nonatomic, weak)   id <DYPlayerViewControllerDelegate>delegate;
@property(nonatomic, assign) NSInteger currentIndex;

// 播放一组视频，并指定播放位置
- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END

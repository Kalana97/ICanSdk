//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 10/5/2022
- File name:  DZAVPlayerViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,AVPlayerViewType) {
    AVPlayerViewTimelinesPostMessage = 0,//发朋友圈视频，只有删除按钮
    AVPlayerViewNormal,//正常类型 可以播放 更多
    AVPlayerViewReply,//点击了回复的视频，没有更多按钮
    
};
NS_ASSUME_NONNULL_BEGIN

@interface DZAVPlayerViewController : BaseViewController
@property(nonatomic, strong) AVPlayer * player;
@property(nonatomic, copy) void (^cancleBlock)(void);
@property(nonatomic, copy) void (^transpondBlock)(void);

@property(nonatomic, copy)  void(^delectBlock)(void);
@property(nonatomic, assign) AVPlayerViewType aVPlayerViewType;
-(void)setPlayUrl:(NSURL*)url aVPlayerViewType:(AVPlayerViewType)aVPlayerViewType;
-(void)hiddenDZAVPlayerView;
-(void)forwardingSendMessage;
@end

NS_ASSUME_NONNULL_END

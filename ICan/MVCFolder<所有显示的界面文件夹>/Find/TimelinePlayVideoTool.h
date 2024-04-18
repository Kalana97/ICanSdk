//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 7/5/2020
- File name:  TimelinePlayVideoTool.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimelinePlayVideoTool : NSObject
@property (nonatomic, strong) AVPlayer * player;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *originContentView;
/** 是否静音 */
@property(nonatomic, assign) BOOL mute;

+(instancetype)shareSingle;

-(void)showWithView:(UIView*)contentView videoUrl:(NSString*)videoUrl;

-(void)removeTimelinePlayVideo;

-(void)showTimelinePlayVideo;

///  恢复其他APP的播放
-(void)regainPlayer;
@end

NS_ASSUME_NONNULL_END

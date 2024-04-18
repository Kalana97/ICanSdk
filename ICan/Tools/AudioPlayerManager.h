//
//  DZAudioPlayerManager.h
//  CaiHongApp
// https://www.jianshu.com/p/3e0a399380df/
//  Created by lidazhi on 2018/12/13.
//  Copyright © 2018 DW. All rights reserved.
//  自定义语音播放

#import <Foundation/Foundation.h>


@protocol DZAudioPlayerManagerDelegate <NSObject>

/**
 播放状态改变回调

 @param audioPlayerState 当前的播放状态
 @param index 播放的index
 */
- (void)dzAudioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index;

@end
@interface AudioPlayerManager : NSObject
+ (instancetype)shareDZAudioPlayerManager;
@property (nonatomic, weak) id<DZAudioPlayerManagerDelegate> delegate;
/** 当前是否正在播放 */
@property(nonatomic, assign) BOOL isPlaying;
/**
 播放语音

 @param URLString 语音URL
 @param index 当前cell的位置
 */
- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index isSender:(BOOL)isSender;

-(void)playCollectionAudioWitUrl:(NSString*)url;
-(void)stopAudioPlayer;
@end



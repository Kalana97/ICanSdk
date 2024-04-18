//
//  VoicePlayerTool.h
//  OneChatAPP
//  播放器
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VoicePlayerTool : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;
+(instancetype)sharedManager;

/**
 播放收到的消息声音
 */
-(void)playMessageReceiverVoice;

/**
 播放抢红包成功的声音
 */
-(void)playerReceiveGrabRedPackey;
/**
 播放发送消息成功的声音
 */
-(void)playSendMessageSuccessVoice;

/// 停止播放云信推送本地音乐
-(void)stopPlayRCCallVoice;

/// 收到云信本地推送播放音乐和振动
-(void)playViedoOrAudioVoice;
/** 点击聊天页面输入框的时候 播放的声音 */
-(void)playChatFunctionViewVoice;
/**
 播放扫描二维码成功的声音
 */
-(void)playScanSuccessVoice;
@end

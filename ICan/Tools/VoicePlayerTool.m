//
//  VoicePlayerTool.m
//  OneChatAPP
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import "VoicePlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPlayerManager.h"
@interface VoicePlayerTool ()<AVAudioPlayerDelegate>{
    SystemSoundID callSound;
    SystemSoundID receiverVoiceID;
    SystemSoundID chatFuntionSoundID;//点击聊天界面底部功能按钮声音
    SystemSoundID messageSendSuccessSoundID;//发送消息成功
    SystemSoundID scanSuccessSoundID;//扫描二维码成功
}

// 播放状态标记
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
/** 保存当前的语音播放的时间 用来 判断一定时间内的语音不重复播放 */
@property(nonatomic, assign) NSInteger playTime;

@end

@implementation VoicePlayerTool
+ (instancetype)sharedManager {
    static VoicePlayerTool *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[VoicePlayerTool alloc] init];
        [api initPlayer];
        [[NSNotificationCenter defaultCenter]addObserver:api selector:@selector(stopPlayRCCallVoice) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    });
    return api;
}
- (void)initPlayer {
    
    [self.player prepareToPlay];
}

- (AVAudioPlayer *)player {
    
    if (!_player) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"SomethingJustLikeThis" withExtension:@"mp3"];
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        audioPlayer.numberOfLoops = NSUIntegerMax;
        _player = audioPlayer;
    }
    return _player;
}


-(void)playSendMessageSuccessVoice{
    //当前是否正在播放语音消息
    if (![AudioPlayerManager shareDZAudioPlayerManager].isPlaying) {
        UserConfigurationInfo*info=[BaseSettingManager sharedManager].userConfigurationInfo;
        if (info.isOpenSound) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"msgSound" withExtension:@"wav"];
            //      创建音效的ID，音效的播放和销毁都靠这个ID来执行
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &messageSendSuccessSoundID);
            AudioServicesPlaySystemSound(messageSendSuccessSoundID);
            
        }
    }
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}
-(void)stopPlayRCCallVoice{
    //销毁音效的播放
    AudioServicesDisposeSystemSoundID(callSound);
    AudioServicesRemoveSystemSoundCompletion(callSound);
}
-(void)playViedoOrAudioVoice{
    NSURL*url= [[NSBundle mainBundle] URLForResource:@"NIMCall" withExtension:@"mp3"];
    //创建音效的ID，音效的播放和销毁都靠这个ID来执行
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &callSound);
    AudioServicesPlayAlertSound(callSound);
    AudioServicesAddSystemSoundCompletion(callSound, NULL, NULL, soundCompleteCallback, NULL);
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
}
-(void)playChatFunctionViewVoice{
    UserConfigurationInfo*info=[BaseSettingManager sharedManager].userConfigurationInfo;
    if (![AudioPlayerManager shareDZAudioPlayerManager].isPlaying) {
        if (info.isOpenSound) {
            //属于铃声和类型 受到静音键的影响
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"bzc" withExtension:@"mp3"];
            //创建音效的ID，音效的播放和销毁都靠这个ID来执行
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &chatFuntionSoundID);
            AudioServicesPlaySystemSound(chatFuntionSoundID);
            //可以共同播放
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
            //恢复其他APP的播放
            [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        }
    }
    
    
}
void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlayAlertSound(sound);  //重复响铃震动
    
}

- (void)playMessageReceiverVoice {
    NSInteger nowTime=[[NSDate date]timeIntervalSince1970];
    BOOL isPlayMessageReceiverVoice=NO;
    if (self.playTime) {
        if (nowTime-self.playTime>=1) {
            isPlayMessageReceiverVoice=YES;
        }else{
            isPlayMessageReceiverVoice=NO;
        }
        self.playTime=nowTime;
    }else{
        isPlayMessageReceiverVoice=YES;
        self.playTime=nowTime;
    }
    if (isPlayMessageReceiverVoice) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"6005" withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &receiverVoiceID);
        AudioServicesPlaySystemSound(receiverVoiceID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //可以共同播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
        //恢复其他APP的播放
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    
}
-(void)playerReceiveGrabRedPackey{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"redPack" withExtension:@"mp3"];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _avAudioPlayer.volume = 0.5;
    _avAudioPlayer.numberOfLoops = 0;
    _avAudioPlayer.delegate=self;
    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer play];
    
}
#pragma mark - 播放扫码成功的声音
-(void)playScanSuccessVoice{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"icanPC" withExtension:@"wav"];
    // 创建音效的ID，音效的播放和销毁都靠这个ID来执行
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &scanSuccessSoundID);
    AudioServicesPlaySystemSound(scanSuccessSoundID);
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}
@end

//
//  DZAudioPlayerManager.m
//  CaiHongApp
//
//  Created by lidazhi on 2018/12/13.
//  Copyright © 2018 DW. All rights reserved.
//

#import "AudioPlayerManager.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XMNChatUntiles.h"
#import "VoiceConverter.h"
@interface AudioPlayerManager ()<AVAudioPlayerDelegate>
@property (nonatomic,strong)   AVAudioPlayer * aVAudioPlayer;
/**
 *  index -> 主要作用是提供记录,用来控制对应的tableViewCell的状态
 */
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy)   NSString * currentPalyUrlString;
@property (nonatomic, copy)   NSString * audioDataFilePath;
//arm临时缓存
@property (nonatomic,copy)    NSString * amrPath;

@end
@implementation AudioPlayerManager
+(instancetype)shareDZAudioPlayerManager{
    static dispatch_once_t onceToken;
    static AudioPlayerManager* dzAudioPlayerManager;
    dispatch_once(&onceToken, ^{
        dzAudioPlayerManager = [[AudioPlayerManager alloc] init];
        
        
    });
    return dzAudioPlayerManager;
}

-(instancetype)init{
    if ([super init]) {
        [self addnotifcation];
    }
    return self;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
-(void)addnotifcation{
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
}
//处理监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊） 这里是靠近屏幕
    if ([[UIDevice currentDevice] proximityState] == YES) {
        DDLogInfo(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    }
    else {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

-(void)applicationEnterBackground{
    [self stopAudioPlayer];
}
-(void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index isSender:(BOOL)isSender{
    if ([self.currentPalyUrlString isEqualToString:URLString] && self.index == index) {
        [self stopAudioPlayer];
        return;
    }
    
    [self stopAudioPlayer];
    self.currentPalyUrlString=URLString;
    self.index=index;
    NSData*audioData=[self audioDataFromURLString:URLString  isSender:isSender];
    if (audioData) {
        [self playAudioWithData:audioData];
    }
}
- (void)playAudioWithData:(NSData *)audioData {
    NSError *audioPlayerError;
    //设置语音播放不受静音键控制
    //这个是人耳检测
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //当前是否选择了扬声器播放
    if ([BaseSettingManager sharedManager].speaker) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    }
    self.aVAudioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&audioPlayerError];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    self.aVAudioPlayer.delegate=self;
    [self.aVAudioPlayer prepareToPlay];
    [self.aVAudioPlayer play];
    [self setXMNVoiceMessageState:XMNVoiceMessageStatePlaying];
    self.isPlaying=YES;
    
}
-(void)playCollectionAudioWitUrl:(NSString *)URLString{
    if ([self.currentPalyUrlString isEqualToString:URLString]) {
        [self stopAudioPlayer];
        return;
    }
    
    [self stopAudioPlayer];
    self.currentPalyUrlString=URLString;
    NSData*audioData=[self audioDataFromURLString:URLString  isSender:NO];
    if (audioData) {
        [self playAudioWithData:audioData];
    }
}
#pragma mark - Private Methods

- (NSData *)audioDataFromURLString:(NSString *)URLString  isSender:(BOOL)isSender{
    NSData *audioData;
    NSData*wavData;
    if (isSender) {
        audioData = [NSData dataWithContentsOfFile:[MessageAudioCache([WebSocketManager sharedManager].currentChatID)stringByAppendingPathComponent:URLString]];
        
    }else{
        NSString *audioCacheKey = [URLString MD5String];
        self.audioDataFilePath=[MessageAudioCache([WebSocketManager sharedManager].currentChatID)stringByAppendingPathComponent:audioCacheKey];
        //1.检查URLString是本地文件还是网络文件
        if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
            if ([URLString hasSuffix:@".mp3"]) {
                //3.本地缓存存在->直接读取本地缓存   不存在->从网络获取数据,并且缓存
                if ([DZFileManager fileIsExistOfPath:self.audioDataFilePath]) {//存在直接从本地读取
                    audioData = [NSData dataWithContentsOfFile:self.audioDataFilePath];
                }else {//不存在同步从网络获取 需要优化
                    audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
                    [DZFileManager saveFile:self.audioDataFilePath withData:audioData];
                }
            }
            else{
                if ([DZFileManager fileIsExistOfPath:self.audioDataFilePath]) {//存在直接从本地读取
                    audioData = [NSData dataWithContentsOfFile:self.audioDataFilePath];
                }else {//不存在同步从网络获取 需要优化
                    audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
                    self.amrPath = [MessageAudioCache([WebSocketManager sharedManager].currentChatID) stringByAppendingPathComponent:@"abcd"];
                    [DZFileManager saveFile:self.amrPath withData:audioData];
                    [VoiceConverter ConvertAmrToWav:self.amrPath wavSavePath:self.audioDataFilePath];
                    wavData=[DZFileManager getFileData:self.audioDataFilePath];
                    [DZFileManager removeFileOfPath:self.amrPath];
                    return wavData;
                }
            }
        }
    }
    
    return audioData;
}


-(void)setXMNVoiceMessageState:(XMNVoiceMessageState)XMNVoiceMessageState{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dzAudioPlayerStateDidChanged:forIndex:)]) {
        [self.delegate dzAudioPlayerStateDidChanged:XMNVoiceMessageState forIndex:self.index];
    }
}

-(void)stopAudioPlayer{
    self.currentPalyUrlString=nil;
    if (self.aVAudioPlayer) {
        [self setXMNVoiceMessageState:XMNVoiceMessageStateCancel];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [self.aVAudioPlayer stop];
        self.aVAudioPlayer.delegate=nil;
        self.aVAudioPlayer=nil;
    }
}
//播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    DDLogInfo(@"播放结束");
    self.isPlaying=NO;
    self.currentPalyUrlString=nil;
    if (self.aVAudioPlayer) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [self.aVAudioPlayer stop];
        self.aVAudioPlayer.delegate=nil;
        self.aVAudioPlayer=nil;
        [self setXMNVoiceMessageState:XMNVoiceMessageStateEnd];
        
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    DDLogInfo(@"播放失败");
}


@end

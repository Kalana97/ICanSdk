//
//  ChatRecordTool.m
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/18.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "ChatRecordTool.h"
#import "Mp3Recorder.h"
#import "AudioPlayerManager.h"

@interface ChatRecordTool ()<Mp3RecorderDelegate>
//定时器
@property (nonatomic, strong) dispatch_source_t recordTimer;
//蒙板
@property (nonatomic, strong) UIView *recordCoverView;
//展示
@property (nonatomic, strong) UIImageView *animationView;
//倒计时
@property (nonatomic, strong) UILabel *cutdownLabel;
//录音
@property (nonatomic, strong) Mp3Recorder *recorder;
//录制的秒数
@property (nonatomic, assign) NSUInteger recordSeconds;

@end

@implementation ChatRecordTool
//初始化录音蒙板
+ (instancetype)chatRecordTool{
    return [[self alloc]init];
}
//开始录音
- (void)beginRecord{
    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    //开始录制
    [self.recorder startRecord];
    self.beginRecoder=YES;
    //蒙板展示
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.recordCoverView];
    //展示GIF
//    voice_one_third voice_two_third voice_one
    if (BaseSettingManager.isChinaLanguages) {
        [self.animationView GIF_PrePlayWithImageNamesArray:@[@"recordVoice_1",@"recordVoice_2",@"recordVoice_3"] duration:0];
    }else{
        [self.animationView GIF_PrePlayWithImageNamesArray:@[@"voice_one_third",@"voice_two_third",@"voice_one"] duration:0];
    }
    
    //开启定时器
    @weakify(self);
    dispatch_source_set_event_handler(self.recordTimer, ^{
        @strongify(self);
        self.recordSeconds ++ ;
        //处理倒计时UI
        if (self.recordSeconds>=61) {
            if (self.recordTimer) {
                dispatch_source_cancel(self.recordTimer);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self clearRecord];
                [self.recorder stopRecord];
            });
        }else{
            if (self.recordSeconds>50) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cutdownLabel.text=[NSString stringWithFormat:@"%ld",61-self.recordSeconds];
                    self.cutdownLabel.hidden=NO;
                    self.animationView.hidden=YES;
                });
               
            }
        }
        
    });
    dispatch_resume(self.recordTimer);
}

//取消录音
- (void)cancelRecord{
    //取消录制
    [self clearRecord];
    [self.recorder cancelRecord];
   
}
//录音结束
- (void)stopRecord{
    if (self.recordSeconds>=61) {
        return;
    }
    [self.recorder stopRecord];
    [self clearRecord];
    
}
//手指移开录音按钮 但是不松开
- (void)moveOut{
    //大于50开始倒计时
    if (self.recordSeconds > 50) {
        self.cutdownLabel.text=[NSString stringWithFormat:@"%ld",61-self.recordSeconds];
        self.cutdownLabel.hidden=NO;
        self.animationView.hidden=YES;
    }else{
        //停止GIF
        [self.animationView GIF_Stop];
        //展示固定图
        if (BaseSettingManager.isChinaLanguages) {
            [self.animationView setImage:UIImageMake(@"chat_sendVoice_cancle")];
        }else{
            [self.animationView setImage:UIImageMake(@"chat_sendVoice_cancleEN")];
        }
        
    }
}

//继续录制
- (void)continueRecord{
    if (self.recordSeconds<50) {
        if (BaseSettingManager.isChinaLanguages) {
            [self.animationView GIF_PrePlayWithImageNamesArray:@[@"recordVoice_1",@"recordVoice_2",@"recordVoice_3"] duration:0];
        }else{
            [self.animationView GIF_PrePlayWithImageNamesArray:@[@"voice_one_third",@"voice_two_third",@"voice_one"] duration:0];
        }
    }
     
}


#pragma mark - delegate
-(void)endConvertWithData:(NSData *)voiceData seconds:(NSTimeInterval)time localPath:(NSString *)localPath{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(endConvertWithData:seconds:localPath:)]) {
        [self.delegate endConvertWithData:voiceData seconds:time localPath:localPath];
    }
}
#pragma mark - 录音相关清除
- (void)clearRecord{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordCoverView removeFromSuperview];
        //关闭定时器
        if (self.recordTimer) {
             dispatch_source_cancel(self.recordTimer);
        }
    });
    
}
- (dispatch_source_t)recordTimer{
    if (!_recordTimer) {
        _recordTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(_recordTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    }
    return _recordTimer;
}

- (Mp3Recorder *)recorder{
    if (!_recorder) {
        _recorder = [[Mp3Recorder alloc]initWithDelegate:self];
    }
    return _recorder;
}

- (UIImageView *)animationView{
    if (!_animationView) {
        _animationView = [[UIImageView alloc]init];
    }
    return _animationView;
}

- (UILabel *)cutdownLabel{
    if (!_cutdownLabel) {
        _cutdownLabel = [[UILabel alloc]init];
        _cutdownLabel.font = [UIFont fontWithLightSize:80];
        _cutdownLabel.textColor = [UIColor whiteColor];
        _cutdownLabel.textAlignment = NSTextAlignmentCenter;
        _cutdownLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        ViewRadius(_cutdownLabel, 10.f);
        _cutdownLabel.hidden = YES; //默认隐藏
    }
    return _cutdownLabel;
}

- (UIView *)recordCoverView{
    if (!_recordCoverView) {
        _recordCoverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _recordCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _recordCoverView.userInteractionEnabled = NO;
        [_recordCoverView addSubview:self.animationView];
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@120);
            make.centerX.equalTo(_recordCoverView.mas_centerX);
            make.centerY.equalTo(_recordCoverView.mas_centerY);
        }];
        [_recordCoverView addSubview:self.cutdownLabel];
        [self.cutdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@120);
            make.centerX.equalTo(_recordCoverView.mas_centerX);
            make.centerY.equalTo(_recordCoverView.mas_centerY);
        }];
    }
    return _recordCoverView;
}

- (void)dealloc{
    if (_recordTimer) {
        dispatch_source_cancel(_recordTimer);
    }
    
}

@end

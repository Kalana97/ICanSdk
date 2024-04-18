//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 16/4/2020
 - File name:  NTESNetChatViewController.m
 - Description:
 - Function List:
 */


#import "NTESNetChatViewController.h"
#import "NTESNetCallChatInfo.h"
#import "NTESTimerHolder.h"
#import "ChatUtil.h"
#import "WCDBManager.h"

//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
#define DelaySelfStartControlTime 10
//激活铃声后无人接听的超时时间
#define NoBodyResponseTimeOut 45

@interface NTESNetChatViewController ()<AVAudioPlayerDelegate>


@property (nonatomic, strong) NSMutableArray *chatRoom;

@property (nonatomic, assign) BOOL recordWillStopForLackSpace;
/**
 磁盘检查定时器
 */
//@property (nonatomic, strong) NTESTimerHolder *diskCheckTimer;

@property (nonatomic, assign) BOOL userHangup;
//被叫等待用户响应接听或者拒绝的时间
@property (nonatomic, strong) NTESTimerHolder *calleeResponseTimer;
@property (nonatomic, assign) BOOL calleeResponsed;

@property (nonatomic, assign) int successRecords;

//@property (nonatomic, strong) NTESRecordSelectView * recordView;
@end

@implementation NTESNetChatViewController
- (void)dealloc{
    DDLogDebug(@"vc dealloc info : %@",self);
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}
-(instancetype)init{
    if (self=[super init]) {
        if (!self.callInfo) {
            [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
            _callInfo = [[NTESNetCallChatInfo alloc] init];
        }
        _timer = [[NTESTimerHolder alloc] init];
        //        _diskCheckTimer = [[NTESTimerHolder alloc] init];
        //防止应用在后台状态，此时呼入，会走init但是不会走viewDidLoad,此时呼叫方挂断，导致被叫监听不到，界面无法消去的问题。
        id<NIMNetCallManager> manager = [NIMAVChatSDK sharedSDK].netCallManager;
        [manager addDelegate:self];
    }
    return self;
}
- (void)loadView {
    [super loadView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self afterCheckService];
    __weak typeof(self) wself = self;
    [self checkServiceEnable:^(BOOL result) {
        if (result) {
            [wself afterCheckService];
        }else{
            [wself hiddenALLView];
            //用户禁用服务，干掉界面
            if (wself.callInfo.callID) {
                //说明是被叫方
                [[NIMAVChatSDK sharedSDK].netCallManager response:wself.callInfo.callID accept:NO option:nil completion:nil];
            }
            [wself dismiss:nil];
        }
    }];
}
#pragma mark - Misc
- (void)checkServiceEnable:(void(^)(BOOL))result{
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    __weak __typeof(self)weakSelf = self;
    if (videoStatus == AVAuthorizationStatusRestricted
        || videoStatus == AVAuthorizationStatusDenied) {
        UIAlertController*vc=[UIAlertController alertCTWithTitle:nil message:@"相机权限受限,无法视频聊天".icanlocalized preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定".icanlocalized] handler:^(int index) {
            if (result) {
                result(NO);
            }
        }];
        DDLogDebug(@"hiddenALLView");
        [self presentViewController:vc animated:YES completion:nil];
        
        return;
    }
    
    if (audioStatus == AVAuthorizationStatusRestricted
        || audioStatus == AVAuthorizationStatusDenied ) {
        DDLogDebug(@"hiddenALLView");
        UIAlertController*vc=[UIAlertController alertCTWithTitle:nil message:@"麦克风权限受限,无法聊天".icanlocalized preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定".icanlocalized] handler:^(int index) {
            if (result) {
                result(NO);
            }
        }];
        [weakSelf presentViewController:vc animated:YES completion:nil];
        
        return;
    }
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async_main_safe(^{
                DDLogDebug(@"hiddenALLView");
                if (granted) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        UIAlertController*vc=[UIAlertController alertCTWithTitle:nil message:@"相机权限受限,无法视频聊天".icanlocalized preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定".icanlocalized] handler:^(int index) {
                            if (result) {
                                result(NO);
                            }
                        }];
                        [weakSelf presentViewController:vc animated:YES completion:nil];
                    }else{
                        if (result) {
                            result(YES);
                        }
                    }
                }
                else {
                    UIAlertController*vc=[UIAlertController alertCTWithTitle:nil message:@"麦克风权限受限,无法聊天".icanlocalized preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定".icanlocalized] handler:^(int index) {
                        if (result) {
                            result(NO);
                        }
                    }];
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                    
                }
                
            });
        }];
    } else {
        dispatch_async_main_safe(^{
            if (result) {
                result(NO);
            }
        });
    }
}
/// 创建会话界面
/// @param callee 被叫人的用户名 测试环境t_userid  正式环境p_userid
- (instancetype)initWithCallee:(NSString *)callee{
    self = [self init];;
    if (self) {
        
        self.peerUid = callee;
        self.callInfo.callee = callee;
#ifdef DEBUG
        self.callInfo.caller = [NSString stringWithFormat:@"t_%@",[UserInfoManager sharedManager].userId];
        
#else
        self.callInfo.caller = [NSString stringWithFormat:@"p_%@",[UserInfoManager sharedManager].userId];
#endif
        
    }
    return self;
}

/// 收到音频申请
/// @param caller caller description
/// @param callID callID description
- (instancetype)initWithCaller:(NSString *)caller callId:(uint64_t)callID{
    self = [self init];;
    if (self) {
        self.peerUid = caller;
        self.callInfo.caller = caller;
#ifdef DEBUG
        self.callInfo.callee = [NSString stringWithFormat:@"t_%@",[UserInfoManager sharedManager].userId];
#else
        self.callInfo.callee = [NSString stringWithFormat:@"p_%@",[UserInfoManager sharedManager].userId];
#endif
        
        self.callInfo.callID = callID;
    }
    return self;
}
#pragma mark - NIMNetCallManagerDelegate
- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    if (callID != self.callInfo.callID) {
        return;
    }
    
    switch (control) {
        case NIMNetCallControlTypeFeedabck:{
            NSMutableArray *room = self.chatRoom;
            if (room && !room.count && !_userHangup) {
                [self playNiMRing];
                [room addObject:self.callInfo.caller];
                //40秒之后查看一下房间状态，如果房间还在一个人的话，就播放铃声超时  因为如果对方接听了 那么在onResponse里面再次添加了一个字段
                __weak typeof(self) wself = self;
                uint64_t callId = self.callInfo.callID;
                NSTimeInterval delayTime = NoBodyResponseTimeOut;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSMutableArray *room = wself.chatRoom;
                    if (wself && room && room.count == 1) {
                        [[NIMAVChatSDK sharedSDK].netCallManager hangup:callId];
                        wself.chatRoom = nil;
                        //                        [wself playTimeoutRing];
                        //对方不接听 超时不接听
                        
                        [self creatChatModelWithCallStatus:@"NO_RESPONSE"  send:NO];
                        ////                        [wself.navigationController.view makeToast:@"无人接听"
                        //                                                          duration:2
                        //                                                          position:CSToastPositionCenter];
                        [wself dismiss:nil];
                    }
                });
            }
            break;
        }
        case NIMNetCallControlTypeBusyLine: {
            [self onCalleeBusy];
            //            [self playOnCallRing];
            _userHangup = YES;
            [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });
            //            HANGUP 发送方手动点击取消按钮
            //            REMOTE_BUSY_LINE 对方忙线中
            //REMOTE_NO_RESPONSE超时无接听
            
            [self creatChatModelWithCallStatus:@"REMOTE_BUSY_LINE"  send:YES];
            break;
        }
        case NIMNetCallControlTypeStartRecord:
            //            [self.view makeToast:@"对方开始了录制".ntes_localized
            //                        duration:1
            //                        position:CSToastPositionCenter];
            break;
        case NIMNetCallControlTypeStopRecord:
            //            [self.view makeToast:@"对方结束了录制".ntes_localized
            //                        duration:1
            //                        position:CSToastPositionCenter];
            break;
        default:
            break;
    }
}
/**
 *  主叫收到被叫响应
 *
 *  @param callID   call id
 *  @param callee 被叫帐号
 *  @param accepted 是否接听
 */
- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted{
    if (self.callInfo.callID == callID) {
        if (!accepted) {
            self.chatRoom = nil;
            //            [self.navigationController.view makeToast:@"对方拒绝接听".ntes_localized
            //                                             duration:2
            //                                             position:CSToastPositionCenter];
            //            [self playHangUpRing];
            //对方已经拒绝
            [self creatChatModelWithCallStatus:@"REJECT"  send:NO];
            [self dismiss:^{
                
            }];
        }else{
            [self.player stop];
            [self onCalling];
            [self.chatRoom addObject:callee];
        }
    }
}
/** 单人视频建立成功 */
-(void)onCallEstablished:(UInt64)callID{
    if (self.callInfo.callID == callID) {
        self.callInfo.isSuccessEstablished=YES;
        self.callInfo.startTime = [NSDate date].timeIntervalSince1970;
        [self.timer startTimer:0.5 delegate:self repeats:YES];
    }
}
/**
 通话异常断开
 
 @param callID call id
 @param error 断开的原因，如果是 nil 表示正常退出
 */
- (void)onCallDisconnected:(UInt64)callID withError:(NSError *)error{
    if (self.callInfo.callID == callID) {
        [self.timer stopTimer];
        [self dismiss:nil];
        self.chatRoom = nil;
        
    }
}


- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted{
    //    [self.view.window makeToast:@"已在其他端处理".ntes_localized
    //                       duration:2
    //                       position:CSToastPositionCenter];
    [self dismiss:nil];
}
/**
 *  对方挂断电话  接通成功和接通未成功都会触发
 *
 *  @param callID call id
 *  @param user   对方帐号
 */
- (void)onHangup:(UInt64)callID
              by:(NSString *)user{
    if (self.callInfo.callID == callID) {
        if (self.callInfo.isSuccessEstablished) {
            [self creatChatModelWithCallStatus:@"REMOTE_HANGUP"  send:NO];
        }
        [self.player stop];
        [self dismiss:nil];
    }
}
-(void)hiddenALLView{
    
}
- (void)afterCheckService{
    if (self.callInfo.isStart) {
        [self.timer startTimer:0.5 delegate:self repeats:YES];
        [self onCalling];
    }else if (self.callInfo.callID) {
        [self startByCallee];
    } else {
        [self startByCaller];
    }
}
#pragma mark - Subclass Impl
- (void)startByCaller{
    
    if (self.callInfo.callType == NIMNetCallMediaTypeVideo) {
        //视频呼叫马上发起
        [self doStartByCaller]; //这个是自己发起通话
    }
    else {
        //语音呼叫先播放一断提示音，然后再发起
        //        [self playConnnetRing];
        if (self.userHangup) {
            DDLogError(@"Netcall request was cancelled before, ignore it.");
            return;
        }
        
        [self doStartByCaller];
    }
}
/** 发起通话
 */
- (void)doStartByCaller{
    self.callInfo.isStart = YES;
    NSArray *callees = [NSArray arrayWithObjects:self.callInfo.callee, nil];
    //设置网络会话选项
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.extendMessage = @"音视频请求扩展信息";
    option.apnsContent = [NSString stringWithFormat:@"%@请求", self.callInfo.callType == NIMNetCallMediaTypeAudio ? @"网络通话" : @"视频聊天"];
    option.apnsSound = @"video_chat_tip_receiver.aac";
    [self fillUserSetting:option];
    option.videoCaptureParam.startWithCameraOn = (self.callInfo.callType == NIMNetCallMediaTypeVideo);
    
    __weak typeof(self) wself = self;
    [[NIMAVChatSDK sharedSDK].netCallManager start:callees type:wself.callInfo.callType option:option completion:^(NSError *error, UInt64 callID) {
        if (!error && wself) {
            wself.callInfo.callID = callID;
            wself.chatRoom = [[NSMutableArray alloc]init];
            //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
            NSTimeInterval delayTime = DelaySelfStartControlTime;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself onControl:callID from:wself.callInfo.callee type:NIMNetCallControlTypeFeedabck];
            });
        }else{
            if (error) {
                //                [wself.navigationController.view makeToast:@"连接失败".ntes_localized
                //                                                  duration:2
                //                                                  position:CSToastPositionCenter];
            }else{
                //说明在start的过程中把页面关了。。
                [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
            }
            [wself dismiss:nil];
        }
    }];
}
/** 接收方收到呼叫 */
- (void)startByCallee{
    self.callInfo.isStart = YES;
    self.chatRoom = [[NSMutableArray alloc] init];
    [ self.chatRoom addObject:self.callInfo.caller];
    //   NIMNetCallControlTypeFeedabck: 收到呼叫请求的反馈，通常用于被叫告诉主叫可以播放回铃音了
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeFeedabck];
    //    [self playReceiverRing];
    [self playNiMRing];
    _calleeResponseTimer = [[NTESTimerHolder alloc] init];
    [_calleeResponseTimer startTimer:NoBodyResponseTimeOut + 10 delegate:self repeats:NO];
}

//发送方用户主动点击了取消按钮  接通下点击了
- (void)hangup{
    _userHangup = YES;
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    if (self.callInfo.isSuccessEstablished) {
        [self creatChatModelWithCallStatus:@"REMOTE_HANGUP"  send:NO];
    }else{
        [self creatChatModelWithCallStatus:@"CANCEL" send:YES];
    }
    if (self.player) {
        [self.player stop];
    }
    self.chatRoom = nil;
    [self dismiss:nil];
    [[AVAudioSession sharedInstance]setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)response:(BOOL)accept{
    _calleeResponsed = YES;
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    [self fillUserSetting:option];
    __weak typeof(self) wself = self;
    [[NIMAVChatSDK sharedSDK].netCallManager response:self.callInfo.callID accept:accept option:option completion:^(NSError *error, UInt64 callID) {
        if (!error) {
            [wself onCalling];
            [wself.player stop];
            [wself.chatRoom addObject:wself.callInfo.callee];
            NSTimeInterval delay = 10.f; //10秒后判断下房间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wself.chatRoom.count == 1) {
                    //                        [wself.navigationController.view makeToast:@"通话失败".ntes_localized
                    //                                                          duration:2
                    //                                                          position:CSToastPositionCenter];
                    [wself hangup];
                }
            });
        }else{
            wself.chatRoom = nil;
            //            [wself.navigationController.view makeToast:@"连接失败".ntes_localized
            //                                              duration:2
            //                                              position:CSToastPositionCenter];
            [wself dismiss:nil];
        }
    }];
    //dismiss需要放在self后面，否在ios7下会有野指针
    if (accept) {
        [self waitForConnectiong];
    }else{
        //接收方拒绝接收通话
        [self creatChatModelWithCallStatus:@"REJECT"  send:NO];
        [self.player stop];
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        [self dismiss:nil];
    }
}

- (void)dismiss:(void (^)(void))completion{
    //    [self dismissViewControllerAnimated:NO completion:nil];
    //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
    //       CATransition *transition = [CATransition animation];
    //       transition.duration = 0.25;
    //       transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    //       transition.type = kCATransitionPush;
    //       transition.subtype  = kCATransitionFromBottom;
    //       [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //       self.navigationController.navigationBarHidden = NO;
    //       [self.navigationController popViewControllerAnimated:NO];
    ////       [self setUpStatusBar:UIStatusBarStyleDefault];
    //       if (completion) {
    //           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //               completion();
    //           });
    //       }
    [self.player stop];
    [[NSNotificationCenter defaultCenter]postNotificationName:KStartPlayVideoOrAudioNotification object:nil];
    //    self.player=nil;
    [[NTESNotificationCenter sharedCenter ]dismissCallViewController:self];
    
    
}
#pragma mark - M80TimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
    //    if (holder == self.diskCheckTimer) {
    //        [self checkFreeDiskSpace];
    //    }
    //    else
    if(holder == self.calleeResponseTimer) {
        if (!_calleeResponsed) {
            
            [self creatChatModelWithCallStatus:@"NO_RESPONSE"  send:NO];
            //            [self.navigationController.view makeToast:@"接听超时".ntes_localized
            //                                              duration:2
            //                                              position:CSToastPositionCenter];
            [self response:NO];
        }
    }
}
- (void)onCalling{
    //子类重写
}

- (void)waitForConnectiong{
    //子类重写
}

- (void)onCalleeBusy
{
    //子类重写
}
- (void)fillUserSetting:(NIMNetCallOption *)option
{
    option.autoRotateRemoteVideo = YES;
    option.remoteViewoShowType = NIMNetCallRemoteVideoShowTypeLocalView;
    //
    //        NIMNetCallServerRecord *serverRecord = [[NIMNetCallServerRecord alloc] init];
    //    serverRecord.enableServerAudioRecording     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    //    serverRecord.enableServerVideoRecording     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    //    serverRecord.enableServerHostRecording      = [[NTESBundleSetting sharedConfig] serverRecordHost];
    //    serverRecord.serverRecordingMode            = [[NTESBundleSetting sharedConfig] serverRecordMode];
    //    option.serverRecord = serverRecord;
    //
    //        NIMNetCallSocksParam *socks5Info =  [[NIMNetCallSocksParam alloc] init];
    //        socks5Info.useSocks5Proxy    =  NO;
    //        socks5Info.socks5Addr        =  [[NTESBundleSetting sharedConfig] socks5Addr];
    //        socks5Info.socks5Username    =  [[NTESBundleSetting sharedConfig] socksUsername];
    //        socks5Info.socks5Password    =  [[NTESBundleSetting sharedConfig] socksPassword];
    //        socks5Info.socks5Type        =  [[NTESBundleSetting sharedConfig] socks5Type];
    //        [[NIMAVChatSDK sharedSDK].netCallManager setUpNetCallSocksWithParam:socks5Info];
    //
    option.preferredVideoEncoder = NIMNetCallVideoCodecDefault;
    option.preferredVideoDecoder = NIMNetCallVideoCodecDefault;
    //        option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = YES;
    option.audioDenoise = YES;
    option.voiceDetect = YES;
    //        option.preferHDAudio =  [[NTESBundleSetting sharedConfig] preferHDAudio];
    option.scene = NIMAVChatSceneDefault;
    
    [[NIMAVChatSDK sharedSDK].netCallManager selectVideoAdaptiveStrategy:NIMAVChatVideoAdaptiveStrategyQuality];
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    [self fillVideoCaptureSetting:param];
    option.videoCaptureParam = param;
    
}
/** fillVideoCaptureSetting 视频质量  NIMNetCallVideoQuality720pLevel preferredVideoQuality*/
- (void)fillVideoCaptureSetting:(NIMNetCallVideoCaptureParam *)param
{
    param.preferredVideoQuality =NIMNetCallVideoQuality720pLevel;
    param.videoCrop  = NIMNetCallVideoCrop16x9;
    param.startWithBackCamera  = NO;
    
}
#pragma mark - Ring
//铃声 - 正在呼叫请稍后
- (void)playConnnetRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_connect_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate=self;
    [self.player play];
}

//铃声 - 对方暂时无法接听
- (void)playHangUpRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_HangUp" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate=self;
    [self.player play];
}

//铃声 - 对方正在通话中
- (void)playOnCallRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_OnCall" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate=self;
    [self.player play];
}

//铃声 - 对方无人接听
- (void)playTimeoutRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_onTimer" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate=self;
    [self.player play];
}

//铃声 - 接收方铃声
- (void)playReceiverRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    self.player.delegate=self;
    [self.player play];
}

//铃声 - 拨打方铃声
- (void)playSenderRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    self.player.delegate=self;
    [self.player play];
}
-(void)playNiMRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMCall" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 1000;
    self.player.delegate=self;
    [self.player stop];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)creatChatModelWithCallStatus:(NSString *)callStatus  send:(BOOL)send{
    NSString*chatId=[[self.callInfo.caller componentsSeparatedByString:@"_"].lastObject isEqualToString:[UserInfoManager sharedManager].userId]?self.callInfo.callee:self.callInfo.caller;
    ChatModel*model=[ChatUtil creatChatMessageModelWithChatId:[chatId componentsSeparatedByString:@"_"].lastObject chatType:UserChat isSecret:NO];
    model.messageType=ChatCallMessageType;
    model.isOutGoing=[[self.callInfo.caller componentsSeparatedByString:@"_"].lastObject isEqualToString:[UserInfoManager sharedManager].userId];
    ChatCallMessageInfo*info=[[ChatCallMessageInfo alloc]init];
    info.callStatus=callStatus;
    
    info.callType=self.callInfo.callType==NIMNetCallMediaTypeAudio?@"VOICE":@"VIDEO";
    
    if (!send) {
        model.sendState=1;
        model.receiptStatus=@"READ";
        if ([callStatus isEqualToString:@"REMOTE_HANGUP"]) {//成功通话挂断
            NSTimeInterval time = [NSDate date].timeIntervalSince1970;
            NSTimeInterval duration = time - self.callInfo.startTime;
            info.callTime=duration;
        }
    }
    model.messageContent=[info mj_JSONString];
    [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:send];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showNiMMessageNotification" object:model];
}

@end

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/4/2021
- File name:  NeCallBaseViewController.m
- Description:
- Function List:
*/
        

#import "NeCallBaseViewController.h"
#import "ChatUtil.h"
#import "WCDBManager+ChatModel.h"
#import "VoicePlayerTool.h"

#ifdef ICANTYPE
@interface NeCallBaseViewController ()<AVAudioPlayerDelegate,CXProviderDelegate>
#else
@interface NeCallBaseViewController ()<AVAudioPlayerDelegate>
#endif

@property(nonatomic, assign) NSTimeInterval startTime;
/** 通话时间的定时器 */
@property(nonatomic, strong) NSTimer *duraTimer;
@end

@implementation NeCallBaseViewController
- (instancetype)initWithOtherMember:(NSString *)member isCalled:(BOOL)isCalled type:(NERtcCallType)type uuid:(NSUUID *)uuid{
    self = [super init];
    if (self) {
//        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.isCalled = isCalled;
        if (isCalled) {
            self.status = NERtcCallStatusCalled;
        }else {
            self.status = NERtcCallStatusCalling;
        }
        self.type = type;
        self.otherUserID = member;
        self.myselfID = [NIMSDK sharedSDK].loginManager.currentAccount;
        self.uuid = uuid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    #ifdef ICANTYPE
        if(self.status == NERtcCallStatusCalling){
            self.isOutGoingCall = YES;
            CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:self.otherUserID];
            self.callUpdate = [[CXCallUpdate alloc]init];
            self.callUpdate.remoteHandle = callHandle;
            self.callUpdate.localizedCallerName = self.nickname;
            self.callUpdate.supportsHolding = NO;
            self.callUpdate.supportsGrouping = NO;
            self.callUpdate.supportsUngrouping = NO;
            CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"My App"];
            NSData *appIconData = UIImagePNGRepresentation([UIImage imageNamed:@"callIcon"]);
            config.iconTemplateImageData = appIconData;
            config.maximumCallsPerCallGroup = 1;
            config.maximumCallGroups = 1;
            config.supportsVideo = YES;
            config.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypeGeneric)];
            CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:self.uuid handle:callHandle];
            if (self.type == NERtcCallTypeVideo) {
                startCallAction.video = YES;
                self.callUpdate.hasVideo = YES;
            }else{
                startCallAction.video = NO;
                self.callUpdate.hasVideo = NO;
            }
            self.provider = [[CXProvider alloc] initWithConfiguration:config];
            [self.provider setDelegate:self queue:nil];
            self.callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
            [self.provider reportCallWithUUID:self.uuid updated:self.callUpdate];
            if (@available(iOS 11.0, *)) {
                [self.callController requestTransactionWithActions:@[startCallAction] completion:^(NSError * _Nullable error) {
                    if (error) {
                        // Handle error
                    } else {
                        // Call connected successfully
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
            [self.provider reportOutgoingCallWithUUID:self.uuid startedConnectingAtDate:[NSDate date]];
        } else{
            self.callUpdate = [AppDelegate shared].callUpdate;
            self.provider = [AppDelegate shared].provider;
            [self.provider setDelegate:self queue:nil];
            self.callController = [AppDelegate shared].callController;
        }
    #endif
    if((self.status == NERtcCallStatusCalling) && [CHANNELTYPE isEqualToString:ICANCNTYPETARGET]){
        ChatCallPushNotificationRequest *request = [ChatCallPushNotificationRequest request];
        request.toUserId = [self.otherUserID componentsSeparatedByString:@"_"].lastObject;
        request.isGroup = NO;
        request.groupId = NULL;
        request.parameters = [request mj_JSONObject];
        if (self.type == NERtcCallTypeVideo) {
            request.callType = @"VIDEO";
        }else{
            request.callType = @"VOICE";
        }
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            NSLog(@"Push notification success");
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            NSLog(@"Push notification failed");
        }];
    }
    if (self.type == NERtcCallTypeVideo) {
        [self setVideoupUI];
    }else{
        [self setupVoiceUI];
    }
    self.view.backgroundColor=UIColorMake(31, 33, 38);
    [self.headImgView setImageWithString:self.avtar placeholder:BoyDefault];
    self.nameLabel.text=self.nickname;
    [self setupSDK];
    [self updateUIStatus:self.status];
//    [self playNiMRing];
    if (self.type == NERtcCallTypeAudio) {
        [[NERtcCallKit sharedInstance] setLoudSpeakerMode:NO error:nil];
    }
}

-(void)playNiMRing{
    [self.player stop];
    if (self.status==NERtcCallStatusCalling) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMCall" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 1000;
    self.player.delegate = self;
    [self.player play];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //恢复其他APP的播放
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}
-(void)stopPlayRCCallVoice{
    [[VoicePlayerTool sharedManager] stopPlayRCCallVoice];
    [self.player stop];
    if ([NERtcCallKit sharedInstance].callStatus==NERtcCallStatusCalled) {
        [self playNiMRing];
    }
}
#pragma mark - SDK
- (void)setupSDK {
    [[NERtcCallKit sharedInstance] addDelegate:self];
    [NERtcCallKit sharedInstance].timeOutSeconds = 30;
    if (self.status == NERtcCallStatusCalling) {
        @weakify(self);
        NSLog(@"CallVC: Start call: %@", self.otherUserID);
        [[NERtcCallKit sharedInstance] call:self.otherUserID type:self.type completion:^(NSError * _Nullable error) {
            @strongify(self);
            [self setupLocalView];
            if (error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self destroy];
                });
            }
        }];
    }else{
        if (self.isCalled) {
            [self setupLocalView];
        }
    }
}
- (void)updateUIStatus:(NERtcCallStatus)status {
    switch (status) {
        case NERtcCallStatusCalling:
        {
            [self startInterface];
        }
            break;
            //正在被呼叫
        case NERtcCallStatusCalled:
        {
            [self waitToCallInterface];
        }
            break;
            //通话中
        case NERtcCallStatusInCall:
        {
            [self callingInterface];
        }
            break;
        default:
            break;
    }
}
-(void)startInterface{
    if (self.type==NERtcCallTypeVideo) {
        self.hangUpBtn.hidden  = self.hangUpLab.hidden = YES;
        self.muteBtn.hidden    = self.muteLab.hidden=YES;
        self.speakerBtn.hidden =self.speakerLab.hidden = YES;
        self.refuseBtn.hidden =self.refuseLab.hidden= YES;
        self.acceptBtn.hidden =self.acceptLab.hidden= YES;
        self.durationLabel.hidden   = YES;
        self.connectingLabel.hidden = NO;
        self.connectingLabel.text   = @"Awaiting Response".icanlocalized;
        self.smallVideoView.hidden=YES;
        self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
        self.cancelLab.hidden=self.cancelBtn.hidden=NO;
        self.switchBgView.hidden=YES;
    }else{
        self.hangUpBtn.hidden  =self.hangUpLab.hidden = YES;
        self.muteBtn.hidden    = self.muteLab.hidden=YES;

        self.speakerBtn.hidden =self.speakerLab.hidden = YES;
        self.refuseBtn.hidden = self.refuseLab.hidden= YES;
        self.acceptBtn.hidden = self.acceptLab.hidden=YES;
        self.durationLabel.hidden   = YES;

        self.connectingLabel.hidden = NO;
        self.connectingLabel.text   = @"Awaiting Response".icanlocalized;
        self.cancelBtn.hidden=self.cancelLab.hidden=NO;
    }
}
-(void)waitToCallInterface{
    if (self.type==NERtcCallTypeVideo) {
        self.cancelLab.hidden=self.cancelBtn.hidden=YES;
        self.hangUpBtn.hidden  = self.hangUpLab.hidden = YES;
        self.muteBtn.hidden    =self.muteLab.hidden= YES;
        self.speakerBtn.hidden =self.speakerLab.hidden = YES;
        self.refuseBtn.hidden =self.refuseLab.hidden= NO;
        self.acceptBtn.hidden =self.acceptLab.hidden= NO;
        self.durationLabel.hidden   = YES;
        self.connectingLabel.hidden = NO;
        self.connectingLabel.text   = @"InviteYouVideoCall".icanlocalized;
        self.smallVideoView.hidden=YES;
        self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
        self.switchBgView.hidden=YES;
    }else{
        self.hangUpBtn.hidden  =self.hangUpLab.hidden = YES;
        self.muteBtn.hidden    =self.muteBtn.hidden= YES;
        self.speakerBtn.hidden =self.speakerLab.hidden= YES;
        self.refuseBtn.hidden =self.refuseLab.hidden= NO;
        self.acceptBtn.hidden = self.acceptLab.hidden= NO;
        self.cancelBtn.hidden=self.cancelLab.hidden=YES;
        self.durationLabel.hidden   = YES;
        self.connectingLabel.hidden = NO;
        self.connectingLabel.text   = @"InviteYouVoiceCall".icanlocalized;
    }
}
-(void)callingInterface{
    if (self.type==NERtcCallTypeVideo) {
        self.acceptBtn.hidden =self.acceptLab.hidden= YES;
        self.refuseBtn.hidden   =self.refuseLab.hidden= YES;
        self.muteBtn.hidden =self.muteLab.hidden= NO;
        self.hangUpBtn.hidden   =self.hangUpLab.hidden=  NO;
        self.cancelLab.hidden=self.cancelBtn.hidden=YES;
        self.connectingLabel.hidden = YES;
        self.switchCameraBtn.hidden=self.switchCameraLab.hidden=NO;
        self.nameLabel.hidden=self.connectingLabel.hidden=self.headImgView.hidden= YES;
        self.smallVideoView.hidden=NO;
        self.switchBgView.hidden=NO;
    }else{
        self.hangUpBtn.hidden  = self.hangUpLab.hidden = NO;
        self.muteBtn.hidden    =self.muteLab.hidden= NO;
        self.speakerBtn.hidden = self.speakerLab.hidden = NO;
        self.refuseBtn.hidden =self.refuseLab.hidden= YES;
        self.acceptBtn.hidden =self.acceptLab.hidden= YES;
        self.durationLabel.hidden   = NO;
        self.connectingLabel.hidden = YES;
        self.cancelBtn.hidden=self.cancelLab.hidden=YES;
    }
}
#pragma mark - destroy
- (void)destroy {
    [self stopPlayRCCallVoice];
    if (_duraTimer) {
        [_duraTimer invalidate];
        _duraTimer=nil;
    }
    if (self && [self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [[NERtcCallKit sharedInstance] setupLocalView:nil];
    [[NERtcCallKit sharedInstance] removeDelegate:self];
    #ifdef ICANTYPE
    if(self.uuid != nil){
        CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:self.uuid];
        CXTransaction *transaction = [[CXTransaction alloc] initWithAction:endCallAction];
        [self.callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
            if (error) {
                // Handle any errors
            } else{

            }
        }];
        [self.provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
    }
    [self.provider invalidate];
    [[AppDelegate shared].provider invalidate];
    #endif
}
#pragma mark - event
-(void)cancelBtnAction{
    [self creatChatModelWithCallStatus:@"CANCEL"  send:YES isOutGoing:YES];
    @weakify(self);
    [[NERtcCallKit sharedInstance] cancel:^(NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            [QMUITipsTool showErrorWihtMessage:error.localizedDescription inView:self.view];
            // 邀请已接受 取消失败 不销毁VC
        }
    }];
    #ifdef ICANTYPE
    if(self.uuid != nil){
        [self.provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
    }
    #endif
    [self destroy];
}
//拒绝接听
-(void)refuseBtnAction{
    self.acceptBtn.enabled = NO;
    [self creatChatModelWithCallStatus:@"REJECT" send:NO isOutGoing:YES];
    @weakify(self);
    [[NERtcCallKit sharedInstance] reject:^(NSError * _Nullable error) {
        @strongify(self);
        self.acceptBtn.enabled = YES;
        #ifdef ICANTYPE
        if(self.uuid != nil){
            [self.provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
        }
        #endif
        [self destroy];
    }];
}
//挂断按钮
-(void)hangUpBtnAction{
    [self creatChatModelWithCallStatus:@"SUCCESS"  send:YES isOutGoing:YES];
    [[NERtcCallKit sharedInstance] hangup:^(NSError * _Nullable error) {
        #ifdef ICANTYPE
        if(self.uuid != nil){
            [self.provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonDeclinedElsewhere];
        }
        #endif
       [self destroy];
    }];
}

-(void)acceptBtnAction{
    self.refuseBtn.enabled = NO;
    self.acceptBtn.enabled = NO;
    self.connectingLabel.hidden = NO;
    @weakify(self);
    [[NERtcCallKit sharedInstance] accept:^(NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            self.connectingLabel.hidden = YES;
            self.refuseBtn.enabled = YES;
            self.acceptBtn.enabled = YES;
            NSString *errorToast = [NSString stringWithFormat:@"Call failed%@",error.localizedDescription];
            [QMUITipsTool showErrorWihtMessage:errorToast inView:nil];
            [self destroy];
        } else {
            self.durationLabel.hidden=NO;
            self.startTime=[[NSDate date]timeIntervalSince1970];
            self->_duraTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            [self stopPlayRCCallVoice];
        }
    }];
}

//点击了静音按钮
-(void)muteBtnAction:(UIButton*)button{
    button.selected = !button.selected;
    [[NERtcCallKit sharedInstance] muteLocalAudio:button.selected];
    #ifdef ICANTYPE
    if(self.uuid != nil){
        // Create a transaction to update the call's muted state
        CXTransaction *transaction = [[CXTransaction alloc] init];
        // Create a set muted call action
        CXSetMutedCallAction *setMutedAction = [[CXSetMutedCallAction alloc] initWithCallUUID:self.uuid muted:button.selected];
        // Add the set muted call action to the transaction
        [transaction addAction:setMutedAction];
        // Request the transaction to update the call's muted state
        [self.callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
            if (error) {
                // Handle error
            } else {
                // Muted state updated successfully
            }
        }];
    }
    #endif
}
//点击了扬声器
-(void)speakerBtnAction{
    self.speakerBtn.selected=!self.speakerBtn.selected;
    //https://www.cnblogs.com/xuan52rock/p/9400436.html 这里有详细的讲解对于播放模式的选择
    if (self.speakerBtn.selected) {
        if (self.type==NERtcCallTypeVideo) {
            [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVideoChat options:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        }else{
            [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        }

    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}
- (void)switchCameraBtn:(UIButton *)button {
    [[NERtcCallKit sharedInstance] switchCamera];
}
- (void)microPhoneClick:(UIButton *)button {
    button.selected = !button.selected;
    [[NERtcCallKit sharedInstance] muteLocalAudio:button.selected];
}
//- (void)switchCallTypeEvent:(UIButton *)button {
//}
//切换到语音通话
- (void)switchCallingModel{
    NERtcCallType newType = self.type == NERtcCallTypeVideo ? NERtcCallTypeAudio : NERtcCallTypeVideo;
    __weak typeof(self) wself = self;
    [NERtcCallKit.sharedInstance switchCallType:newType completion:^(NSError * _Nullable error) {
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        if (error) {
            [QMUITipsTool showErrorWihtMessage:error.localizedDescription inView:nil];
            return;
        }
        [sself handleCallTypeChange:newType];
    }];
    ////    [self updaAudioUI];
}
//定时器
-(void)onTimer{
    self.durationLabel.text=[self durationDesc];
}
#pragma mark - 创建消息类型
- (void)creatChatModelWithCallStatus:(NSString *)callStatus  send:(BOOL)send isOutGoing:(BOOL)isOutGoing{
    NSString*chatId=[self.otherUserID componentsSeparatedByString:@"_"].lastObject;
    ChatModel*model=[ChatUtil creatChatMessageModelWithChatId:chatId chatType:UserChat authorityType:[NERtcCallKit sharedInstance].authorityType circleUserId:[NERtcCallKit sharedInstance].circleUserId];
    model.messageType=ChatCallMessageType;
    model.isOutGoing=isOutGoing;
    model.authorityType=[NERtcCallKit sharedInstance].authorityType;
    ChatCallMessageInfo*info=[[ChatCallMessageInfo alloc]init];
    info.callStatus=callStatus;
    info.callType=self.type==NERtcCallTypeAudio?@"VOICE":@"VIDEO";
    if (!send) {
        model.sendState=1;
        model.receiptStatus=@"READ";
    }else{
        if ([callStatus isEqualToString:@"SUCCESS"]) {//成功通话挂断
            NSTimeInterval time = [NSDate date].timeIntervalSince1970;
            NSTimeInterval duration = time - self.startTime;
            info.callTime=duration;
        }
    }
    model.messageContent=[info mj_JSONString];
    [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:send];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showNiMMessageNotification" object:model];
}
#pragma mark - NERtcCallKitDelegate
/// 接受邀请的回调
/// @param userID 接受者
- (void)onUserEnter:(NSString *)userID {
    self.otherUserID = userID;
    self.statsCount = 0;
    self.durationLabel.hidden=NO;
    self.startTime=[[NSDate date]timeIntervalSince1970];
    _duraTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    #ifdef ICANTYPE
    if((self.status == NERtcCallStatusCalling) && (self.uuid != nil) && [CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        [self.provider reportOutgoingCallWithUUID:self.uuid connectedAtDate:[NSDate date]];
    }
    if(self.uuid != nil){
        [self.provider reportCallWithUUID:self.uuid updated:self.callUpdate];
    } else{
        [self.provider invalidate];
    }
    #endif
    self.status = NERtcCallStatusInCall;
    if (self.type == NERtcCallTypeAudio) {
        self.connectingLabel.hidden = YES;
        [self updateUIStatus:NERtcCallStatusInCall];
    }
}

- (void)onFirstVideoFrameDecoded:(NSString *)userID width:(uint32_t)width height:(uint32_t)height {
    self.connectingLabel.hidden = YES;
    if (self.isCalled) {
        [self setupLocalView];
    }
    [self setupRemoteView];
    [self updateUIStatus:NERtcCallStatusInCall];
    //这里是把远端视频变大
    [self becomeBigVideoView:self.smallVideoView];
}
/// 用户接受邀请的回调
/// @param userID 用户userID
- (void)onUserAccept:(NSString *)userID {
    NSLog(@"CallVC: User %@ accept", userID);
    [self stopPlayRCCallVoice];
    self.connectingLabel.hidden = NO;
//    self.cancelBtn.enabled = NO;
}
/// 取消邀请的回调
/// @param userID 邀请方
- (void)onUserCancel:(NSString *)userID {
    [[NERtcCallKit sharedInstance] hangup:nil];
    [self destroy];
}
- (void)onCameraAvailable:(BOOL)available userID:(NSString *)userID {
    [self cameraAvailble:available userId:userID];
}
///有网络的情况下  呼叫超时  对方未接听 拨打方收到的回调
- (void)onCallingTimeOut {
    if (WebSocketManager.sharedManager.hasNewWork) {
        //超时不接听
        [self creatChatModelWithCallStatus:@"REMOTE_NO_RESPONSE"  send:YES isOutGoing:YES];
        [QMUITipsTool showOnlyTextWithMessage:@"The other party has no response".icanlocalized inView:nil];
        [self destroy];
    }else{
        [self destroy];
    }

}
/// 忙线
/// @param userID 忙线的用户ID
- (void)onUserBusy:(NSString *)userID {
    [QMUITipsTool showOnlyTextWithMessage:@"The other party is on a call".icanlocalized inView:nil];
    //对方忙线中
    [self creatChatModelWithCallStatus:@"REMOTE_BUSY_LINE"  send:YES isOutGoing:YES];
    [self destroy];

}
- (void)onCallEnd {
    #ifdef ICANTYPE
    if(self.uuid != nil) {
        [self.provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
    }
    #endif
    [self destroy];
}
/// 拒绝邀请的回调
/// @param userID 拒绝者
- (void)onUserReject:(NSString *)userID {
    [QMUITipsTool showOnlyTextWithMessage:@"TheOtherDeclinedYourInvitation".icanlocalized inView:nil];
    [self creatChatModelWithCallStatus:@"REJECT"  send:NO isOutGoing:NO];
    [self destroy];
}

- (void)onUserLeave:(NSString *)userID {
    [QMUITipsTool showOnlyTextWithMessage:@"The other party has left".icanlocalized inView:nil];
    [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
        [self destroy];
    }];
}

- (void)onUserDisconnect:(NSString *)userID {
    [QMUITipsTool showOnlyTextWithMessage:@"The other party has been disconnected".icanlocalized inView:nil];
    [NERtcCallKit.sharedInstance hangup:^(NSError * _Nullable error) {
        [self destroy];
    }];
}

- (void)onCallTypeChange:(NERtcCallType)callType {
    [self handleCallTypeChange:callType];
}

- (void)onUserNetworkQuality:(NSDictionary<NSString *,NERtcNetworkQualityStats *> *)stats {
    NERtcNetworkQualityStats *otherUserStat = stats[self.otherUserID?:@""];
    if (!otherUserStat) {
        return;
    }
    if (self.statsCount++ < 3) { // 忽略前3次统计
        return;
    }
    //    NSLog(@"%@", @(otherUserStat.txQuality));
    switch (otherUserStat.txQuality) {
        case kNERtcNetworkQualityUnknown: {
            self.statsLabel.text = @"The other party's network status may be poor".icanlocalized;
            self.statsLabel.hidden = NO;
            break;
        }
        case kNERtcNetworkQualityBad:
        case kNERtcNetworkQualityVeryBad: {
            self.statsLabel.text = @"The other party may be in poor network status".icanlocalized;
            self.statsLabel.hidden = NO;
            break;
        }
        case kNERtcNetworkQualityDown: {
            self.statsLabel.text = @"The other party may have very poor network status".icanlocalized;
            self.statsLabel.hidden = NO;
            break;
        }
        default:
            self.statsLabel.hidden = YES;
            break;
    }
}

- (void)onDisconnect:(NSError *)reason {
    [QMUITipsTool showOnlyTextWithMessage:@"You have been disconnected".icanlocalized inView:nil];
    [self destroy];
}

- (void)onOtherClientAccept {
    [QMUITipsTool showOnlyTextWithMessage:@"Answered on another device".icanlocalized inView:nil];
    [self destroy]; // 已被其他端处理
}

- (void)onOtherClientReject {
    [self destroy]; // 已被其他端处理
}

#pragma mark - NEVideoViewDelegate
- (void)didTapVideoView:(NEVideoView *)videoView {
    if (videoView.isSmall) {
        [self becomeBigVideoView:videoView];
    }
}
#pragma mark - private mothed 切换视频大小

- (void)becomeBigVideoView:(NEVideoView *)videoView {
    [videoView becomeBig];
    [videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
    }];

    NEVideoView *forwardView = [videoView isEqual:self.bigVideoView]?self.smallVideoView:self.bigVideoView;
    [forwardView becomeSmall];
    [forwardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.right.equalTo(@-10);
        make.width.equalTo(@100);
        make.height.equalTo(@200);
    }];
    NSInteger frontIndex = 0;
    NSInteger backIndex = 0;
    for (int i = 0; i < self.view.subviews.count; i ++) {
        UIView *view = self.view.subviews[i];
        if ([view isEqual:videoView]) {
            backIndex = i;
        }
        if ([view isEqual:forwardView]) {
            frontIndex = i;
        }
    }
    [self.view exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
}
- (void)cameraAvailble:(BOOL)available userId:(NSString *)userId {
    NSLog(@"CallVC: User %@ camera did %@", userId, available ? @"Start" : @"Stop");
    NSString *tips = [self.myselfID isEqualToString:userId]?@"The camera is turned off".icanlocalized:@"对方The camera is turned off".icanlocalized;
    BOOL tipForceHidden = self.type == NERtcCallTypeAudio;
    if ([self.bigVideoView.userID isEqualToString:userId]) {
        self.bigVideoView.titleLabel.hidden = available || tipForceHidden;
        self.bigVideoView.titleLabel.text = tips;
    }
    if ([self.smallVideoView.userID isEqualToString:userId]) {
        self.smallVideoView.titleLabel.hidden = available || tipForceHidden;
        self.smallVideoView.titleLabel.text = tips;
    }
}
#pragma mark -  Misc
- (NSString*)durationDesc{
    if (!self.startTime) {
        return @"";
    }
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    NSTimeInterval duration = time - self.startTime;
    return [NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
}
- (void)setupLocalView {
    if (self.type == NERtcCallTypeVideo) {
        [[NERtcCallKit sharedInstance] setupLocalView:self.bigVideoView.videoView];
        self.bigVideoView.userID = self.myselfID;
    }
}
- (void)setupRemoteView {
    if (self.type == NERtcCallTypeVideo) {
        [[NERtcCallKit sharedInstance] setupRemoteView:self.smallVideoView.videoView forUser:self.otherUserID];
        self.smallVideoView.userID = self.otherUserID;
    }
}
- (void)handleCallTypeChange:(NERtcCallType)type {
    self.type = type;
    BOOL isAudioType = type == NERtcCallTypeAudio; // 音频类型不提示关闭摄像头
    self.bigVideoView.titleLabel.hidden = isAudioType;
    self.smallVideoView.titleLabel.hidden = isAudioType;
    //    [self.callTypeBtn setImage:[UIImage imageNamed:isAudioType?@"call_switch_video":@"call_switch_audio"] forState:UIControlStateNormal];
    NSString *toast = [NSString stringWithFormat:@"%@%@",@"Switched to".icanlocalized, type==NERtcCallTypeAudio?@"Audio Call".icanlocalized:@"Video Call".icanlocalized];
    [QMUITipsTool showOnlyTextWithMessage:toast inView:nil];
    [self updateUIStatus:NERtcCallStatusInCall];
    if (isAudioType) {
        [self.smallVideoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.bigVideoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self updaAudioUI];
    } else {
        self.statsCount = 0;
        [NERtcCallKit.sharedInstance setupLocalView:self.smallVideoView];
        [NERtcCallKit.sharedInstance setupRemoteView:self.bigVideoView forUser:self.otherUserID];
    }
}
-(DZIconImageView *)headImgView{
    if (!_headImgView) {
        _headImgView=[[DZIconImageView alloc]init];

        [_headImgView layerWithCornerRadius:60 borderWidth:0 borderColor:nil];
    }
    return _headImgView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:@"" font:30 color:UIColor.whiteColor];
    }
    return _nameLabel;
}
-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel=[UILabel centerLabelWithTitle:@"" font:20 color:UIColor.whiteColor];
        _durationLabel.hidden=YES;
    }
    return _durationLabel;
}

-(UILabel *)connectingLabel{
    if (!_connectingLabel) {
        _connectingLabel=[UILabel rightLabelWithTitle:@"" font:16 color:UIColor.whiteColor];
        _connectingLabel.numberOfLines=0;
    }
    return _connectingLabel;
}
/** 扬声器
 */
-(UIButton *)speakerBtn{
    if (!_speakerBtn) {
        _speakerBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(speakerBtnAction)];
        //icon_NIM_speaker_select
        _speakerBtn.hidden=YES;
        [_speakerBtn setBackgroundImage:UIImageMake(@"icon_NIM_speaker_unselect") forState:UIControlStateNormal];
        [_speakerBtn setBackgroundImage:UIImageMake(@"icon_NIM_speaker_select") forState:UIControlStateSelected];
    }
    return _speakerBtn;
}
-(UILabel *)speakerLab{
    if (!_speakerLab) {
        _speakerLab=[UILabel centerLabelWithTitle:@"Speaker".icanlocalized font:15 color:UIColor.whiteColor];
        _speakerLab.hidden=YES;
    }
    return _speakerLab;;
}

-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:19 titleColor:UIColor.whiteColor target:self action:@selector(muteBtnAction:)];
        //icon_v_mute_white
        [_muteBtn setBackgroundImage:UIImageMake(@"icon_NIM_mute_unselect") forState:UIControlStateNormal];
        [_muteBtn setBackgroundImage:UIImageMake(@"icon_NIM_mute_select") forState:UIControlStateSelected];
    }
    return _muteBtn;
}

-(UILabel *)muteLab{
    if (!_muteLab) {
        _muteLab=[UILabel centerLabelWithTitle:@"Mute".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _muteLab;;
}
-(UIButton *)refuseBtn{
    if (!_refuseBtn) {
        _refuseBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_refuse" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(refuseBtnAction)];
    }
    return _refuseBtn;
}

-(UILabel *)refuseLab{
    if (!_refuseLab) {
        _refuseLab=[UILabel centerLabelWithTitle:@"End call".icanlocalized font:15 color:UIColor.whiteColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refuseBtnAction)];
        [_refuseLab addGestureRecognizer:tap];
        _refuseLab.userInteractionEnabled=YES;
    }
    return _refuseLab;;
}

-(UIButton *)acceptBtn{
    if (!_acceptBtn) {
        _acceptBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_accep" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(acceptBtnAction)];
    }
    return _acceptBtn;
}
-(UILabel *)acceptLab{
    if (!_acceptLab) {
        _acceptLab=[UILabel centerLabelWithTitle:@"Answer".icanlocalized font:15 color:UIColor.whiteColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(acceptBtnAction)];
        [_acceptLab addGestureRecognizer:tap];
        _acceptLab.userInteractionEnabled=YES;
    }
    return _acceptLab;;
}

-(UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_refuse" backgroundColor:nil titleFont:19 titleColor:UIColor.clearColor target:self action:@selector(hangUpBtnAction)];
    }
    return _hangUpBtn;
}
-(UILabel *)hangUpLab{
    if (!_hangUpLab) {
        _hangUpLab=[UILabel centerLabelWithTitle:@"End call".icanlocalized font:15 color:UIColor.whiteColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hangUpBtnAction)];
        [_hangUpLab addGestureRecognizer:tap];
        _hangUpLab.userInteractionEnabled=YES;
    }
    return _hangUpLab;;
}


-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_refuse" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(cancelBtnAction)];
    }
    return _cancelBtn;
}
-(UILabel *)cancelLab{
    if (!_cancelLab) {
        _cancelLab=[UILabel centerLabelWithTitle:@"End call".icanlocalized font:15 color:UIColor.whiteColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnAction)];
        [_cancelLab addGestureRecognizer:tap];
        _cancelLab.userInteractionEnabled=YES;
    }
    return _cancelLab;
}
- (NEVideoView *)bigVideoView {
    if (!_bigVideoView) {
        _bigVideoView = [[NEVideoView alloc] init];
        _bigVideoView.backgroundColor = [UIColor darkGrayColor];
        _bigVideoView.isSmall = NO;
        _bigVideoView.delegate = self;
    }
    return _bigVideoView;
}
- (NEVideoView *)smallVideoView {
    if (!_smallVideoView) {
        _smallVideoView = [[NEVideoView alloc] init];
        _smallVideoView.backgroundColor = [UIColor darkGrayColor];
        _smallVideoView.isSmall = YES;
        _smallVideoView.delegate = self;
    }
    return _smallVideoView;
}
- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [[UIButton alloc] init];
        [_switchCameraBtn setImage:[UIImage imageNamed:@"icon_v_switch_scene"] forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}
-(UILabel *)switchCameraLab{
    if (!_switchCameraLab) {
        _switchCameraLab=[UILabel centerLabelWithTitle:@"Switch camera".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _switchCameraLab;
}
- (void)dealloc {
    NSLog(@"%@ dealloc%@",[self class],self);
}

-(UIButton *)closeVideoBtn{
    if (!_closeVideoBtn) {
        _closeVideoBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_accep" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(closeVideoBtnAction:)];
    }
    return _closeVideoBtn;
}
-(UILabel *)closeVideoLab{
    if (!_closeVideoLab) {
        _closeVideoLab=[UILabel centerLabelWithTitle:@"关闭摄像头".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _closeVideoLab;
}
/** 切换语音
 */
-(UIView *)switchBgView{
    if (!_switchBgView) {
        _switchBgView=[[UIView alloc]init];
        [_switchBgView layerWithCornerRadius:5 borderWidth:0.5 borderColor:UIColorMakeWithRGBA(255, 255, 255,0.6)];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchCallingModel)];
        _switchBgView.userInteractionEnabled=YES;
        _switchBgView.hidden=YES;
        [_switchBgView addGestureRecognizer:tap];

    }
    return _switchBgView;
}
-(UILabel *)switchModelLab{
    if (!_switchModelLab) {
        _switchModelLab=[UILabel centerLabelWithTitle:@"Switch to voice call".icanlocalized font:13 color:UIColor.whiteColor];
        NSAttributedString*nullString= [[NSAttributedString alloc]initWithString:@" "];
        NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithAttributedString:nullString];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:@"icon_switch_video"];
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds = CGRectMake(0, -5, 20 , 20);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [att appendAttributedString:imageStr];
        [att appendAttributedString:nullString];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"Switch to voice call".icanlocalized]];
        _switchModelLab.attributedText=att;
    }
    return _switchModelLab;
}

- (UILabel *)statsLabel {
    if (!_statsLabel) {
        _statsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statsLabel.font = [UIFont systemFontOfSize:14];
        _statsLabel.textColor = [UIColor whiteColor];
        _statsLabel.textAlignment = NSTextAlignmentCenter;
        _statsLabel.numberOfLines=0;
        _statsLabel.hidden = YES;
    }
    return _statsLabel;
}
- (AVAudioPlayer *)player {
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMCall" withExtension:@"mp3"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = 30;
    }
    return _player;
}

#pragma mark - UI
- (void)setVideoupUI {
    [self.view addSubview:self.bigVideoView];
    [self.bigVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
    }];
    [self.view addSubview:self.smallVideoView];
    [self.smallVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.right.equalTo(@-10);
        make.width.equalTo(@100);
        make.height.equalTo(@200);
    }];
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.muteBtn];
    [self.view addSubview:self.muteLab];
    [self.view addSubview:self.acceptBtn];
    [self.view addSubview:self.acceptLab];
    [self.view addSubview:self.refuseBtn];
    [self.view addSubview:self.refuseLab];
    [self.view addSubview:self.hangUpBtn];
    [self.view addSubview:self.hangUpLab];
    [self.view addSubview:self.speakerBtn];
    [self.view addSubview:self.speakerLab];
    [self.view addSubview:self.connectingLabel];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.switchCameraLab];

    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.cancelLab];
    [self.view addSubview:self.switchBgView];
    [self.view addSubview:self.statsLabel];
    [self.switchBgView addSubview:self.switchModelLab];
    [self.switchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@64);
    }];

    [self.switchModelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchBgView.mas_left).offset(5);
        make.right.equalTo(self.switchBgView.mas_right).offset(-5);
        make.top.equalTo(self.switchBgView.mas_top).offset(5);
        make.bottom.equalTo(self.switchBgView.mas_bottom).offset(-5);
    }];

    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.right.equalTo(@-20);
        make.top.equalTo(self.view.mas_top).offset(50);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImgView.mas_left).offset(-20);
        make.left.equalTo(@20);
        make.top.equalTo(self.headImgView.mas_top).offset(5);
    }];
    [self.connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImgView.mas_left).offset(-20);
        make.left.equalTo(@20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];

    //静音 挂断 扬声
    NSArray*items=@[self.muteBtn,self.hangUpBtn,self.switchCameraBtn];
    [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:30 tailSpacing:30];
    [items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-80);
        make.height.equalTo(@70);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangUpBtn.mas_bottom);
        make.top.equalTo(self.hangUpBtn.mas_top);
        make.left.equalTo(self.hangUpBtn.mas_left);
        make.right.equalTo(self.hangUpBtn.mas_right);
    }];
    [self.cancelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.hangUpBtn.mas_centerX);
    }];
    [self.muteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.muteBtn.mas_centerX);
    }];
    [self.hangUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.hangUpBtn.mas_centerX);
    }];
    [self.switchCameraLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.switchCameraBtn.mas_centerX);
    }];

    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-20);
    }];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.durationLabel.mas_top).offset(-20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.refuseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refuseBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.refuseBtn.mas_centerX);

    }];
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.acceptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acceptBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.acceptBtn.mas_centerX);
    }];
    [self hiddenALLView];
}
-(void)hiddenALLView{
    self.muteBtn.hidden    = self.muteLab.hidden=YES;
    self.speakerBtn.hidden =self.speakerLab.hidden = YES;
    self.refuseBtn.hidden =self.refuseLab.hidden= YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.connectingLabel.hidden = YES;
    self.connectingLabel.text   = @"Awaiting Response".icanlocalized;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
    self.cancelBtn.hidden=self.cancelLab.hidden=YES;
}
- (void)setupVoiceUI {
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.muteBtn];
    [self.view addSubview:self.muteLab];
    [self.view addSubview:self.acceptBtn];
    [self.view addSubview:self.acceptLab];
    [self.view addSubview:self.refuseBtn];
    [self.view addSubview:self.refuseLab];
    [self.view addSubview:self.hangUpBtn];
    [self.view addSubview:self.hangUpLab];
    [self.view addSubview:self.speakerBtn];
    [self.view addSubview:self.speakerLab];

    [self.view addSubview:self.connectingLabel];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.cancelLab];
    [self.view addSubview:self.statsLabel];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-20);
    }];
    [self.connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    //静音 挂断 扬声
    NSArray*items=@[self.muteBtn,self.hangUpBtn,self.speakerBtn];
    [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:30 tailSpacing:30];
    [items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-80);
        make.height.equalTo(@70);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangUpBtn.mas_bottom);
        make.top.equalTo(self.hangUpBtn.mas_top);
        make.left.equalTo(self.hangUpBtn.mas_left);
        make.right.equalTo(self.hangUpBtn.mas_right);
    }];
    [self.cancelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.hangUpBtn.mas_centerX);
    }];
    [self.muteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.muteBtn.mas_centerX);
    }];
    [self.hangUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.hangUpBtn.mas_centerX);
    }];
    [self.speakerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.speakerBtn.mas_centerX);
    }];

    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-20);
    }];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.durationLabel.mas_top).offset(-20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.refuseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refuseBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.refuseBtn.mas_centerX);
    }];
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.acceptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acceptBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.acceptBtn.mas_centerX);
    }];
    [self hiddenALLView];
}
-(void)updaAudioUI{
    [self.view qmui_removeAllSubviews];
    self.switchBgView.hidden=YES;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
    self.speakerBtn.hidden=self.speakerLab.hidden=NO;
    self.headImgView.hidden=self.nameLabel.hidden=NO;
    self.view.backgroundColor=UIColorMake(31, 33, 38);
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.muteBtn];
    [self.view addSubview:self.muteLab];
    [self.view addSubview:self.acceptBtn];
    [self.view addSubview:self.acceptLab];
    [self.view addSubview:self.refuseBtn];
    [self.view addSubview:self.refuseLab];
    [self.view addSubview:self.hangUpBtn];
    [self.view addSubview:self.hangUpLab];
    [self.view addSubview:self.speakerBtn];
    [self.view addSubview:self.speakerLab];
    [self.view addSubview:self.connectingLabel];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.statsLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-20);

    }];
    [self.connectingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    //静音 挂断 扬声
    NSArray*items=@[self.muteBtn,self.hangUpBtn,self.speakerBtn];
    [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:70 leadSpacing:30 tailSpacing:30];
    [items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-80);
        make.height.equalTo(@70);
    }];

    [self.muteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.muteBtn.mas_centerX);
    }];
    [self.hangUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.hangUpBtn.mas_centerX);
    }];
    [self.speakerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.speakerBtn.mas_centerX);
    }];

    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.hangUpBtn.mas_top).offset(-20);
    }];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.durationLabel.mas_top).offset(-20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.refuseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refuseBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.refuseBtn.mas_centerX);

    }];
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-60);
        make.width.height.equalTo(@70);
        make.bottom.equalTo(@-80);
    }];
    [self.acceptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acceptBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.acceptBtn.mas_centerX);
    }];
}

#ifdef ICANTYPE
- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
    [self acceptBtnAction];
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
    if(self.status == NERtcCallStatusCalling){
        [self cancelBtnAction];
    } else if (self.status == NERtcCallStatusInCall){
        [self hangUpBtnAction];
    }else{
        [self refuseBtnAction];
    }
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action {
    BOOL isMuted = action.muted;
    if (isMuted) {
        self.muteBtn.selected = YES;
        [[NERtcCallKit sharedInstance] muteLocalAudio:YES];
    } else {
        self.muteBtn.selected = NO;
        [[NERtcCallKit sharedInstance] muteLocalAudio:NO];
    }
    [action fulfill];
}

- (void)providerDidReset:(nonnull CXProvider *)provider {
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
}

- (void)setNeedsFocusUpdate {
}

- (void)updateFocusIfNeeded {
}
#endif

@end

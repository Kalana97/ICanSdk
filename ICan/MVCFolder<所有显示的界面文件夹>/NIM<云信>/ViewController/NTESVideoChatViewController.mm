//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 16/4/2020
 - File name:  NTESVideoChatViewController.m
 - Description:
 - Function List:
 */


#import "NTESVideoChatViewController.h"
#import "NTESAudioChatViewController.h"
#import <NIMAVChat/NIMAVChat.h>

#import "WCDBManager+UserMessageInfo.h"
@interface NTESVideoChatViewController ()
@property (nonatomic,assign) NIMNetCallCamera cameraType;

@property (nonatomic,strong) CALayer *localVideoLayer;

@property (nonatomic,weak) UIView   *localView;

@property (nonatomic,weak) UIView   *localPreView;

@property (nonatomic,weak) UIView   *remoteView;

//@property (nonatomic, strong) NTESGLView *remoteGLView;

@property (nonatomic, assign) BOOL calleeBasy;

@property (nonatomic, copy) NSString *remoteUid;

@property (nonatomic, assign) BOOL oppositeCloseVideo;


@end

@implementation NTESVideoChatViewController
- (instancetype)initWithCallInfo:(NTESNetCallChatInfo *)callInfo{
    self=[super init];
    if (self) {
        self.callInfo = callInfo;
        self.callInfo.isMute = NO;
        self.callInfo.useSpeaker = NO;
        self.callInfo.disableCammera = NO;
        NSString *myUid = [NIMSDK sharedSDK].loginManager.currentAccount;
        if ([self.callInfo.caller isEqualToString:myUid]) {
            _remoteUid = self.callInfo.callee;
        } else {
            _remoteUid = self.callInfo.caller;
        }
        
    }
    return self;
}
- (void)loadView {
    [super loadView];
    [self initUI];
    self.callInfo.callType = NIMNetCallMediaTypeVideo;
    _cameraType =NIMNetCallCameraFront;
    
}

- (void)viewDidLoad {
    if (!self.localPreView) {
        //没有的话，尝试去取一把预览层（从视频切到语音再切回来的情况下是会有的）
        self.localPreView = [NIMAVChatSDK sharedSDK].netCallManager.localPreview;
    }
    [[NIMAVChatSDK sharedSDK].netCallManager switchType:NIMNetCallMediaTypeVideo];
    self.localView = self.smallVideoView;
    [super viewDidLoad];
    if (self.localPreView) {
        self.localPreView.frame = self.localView.bounds;
        [self.localView addSubview:self.localPreView];
    }
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self initRemoteGLView];
    }
    
    NSString*caller=[self.callInfo.caller componentsSeparatedByString:@"_"].lastObject;
    NSString*callee=[self.callInfo.callee componentsSeparatedByString:@"_"].lastObject;
    if ([caller isEqualToString:[UserInfoManager sharedManager].userId]) {
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:callee successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.headImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            self.nameLabel.text=info.remarkName?:info.nickname;
        }];
    }else{
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:caller successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.headImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            self.nameLabel.text=info.remarkName?:info.nickname;
        }];
    }
    
}
-(void)initRemoteGLView{
    
    if(!_remoteView) {
        _remoteView = [[NIMAVChatSDK sharedSDK].netCallManager remoteDisplayViewWithUid:_remoteUid];
    }
    if (self.remoteView) {
        self.remoteView.frame = self.bigVideoView.bounds;
        if (self.remoteView.superview != self.bigVideoView) {
            [self.remoteView removeFromSuperview];
            [self.bigVideoView addSubview:self.remoteView];
        }
    }
    
}

-(void)initUI{
    [self.view addSubview:self.bigVideoView];
    [self.bigVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
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
    //    [self.view addSubview:self.speakerBtn];
    //    [self.view addSubview:self.speakerLab];
    [self.view addSubview:self.connectingLabel];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.switchCameraLab];
    [self.view addSubview:self.switchModelLab];
    [self.view addSubview:self.smallVideoView];
    
    [self.view addSubview:self.switchBgView];
    [self.switchBgView addSubview:self.switchModelLab];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.right.equalTo(@-20);
        make.top.equalTo(self.view.mas_top).offset(50);
    }];
    [self.smallVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.right.equalTo(@-10);
        make.width.equalTo(@100);
        make.height.equalTo(@200);
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
    
}
-(void)hiddenALLView{
    self.muteBtn.hidden    = self.muteLab.hidden=YES;
    self.speakerBtn.hidden =self.speakerLab.hidden = YES;
    self.refuseBtn.hidden =self.refuseLab.hidden= YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.connectingLabel.hidden = YES;
    self.connectingLabel.text   = @"正在等待对方接受邀请".icanlocalized;
    self.localView = self.bigVideoView;
    self.switchModelLab.hidden=self.switchModelBtn.hidden=YES;
    self.switchBgView.hidden=YES;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
}
-(DZIconImageView *)headImgView{
    if (!_headImgView) {
        _headImgView=[[DZIconImageView alloc]init];
        
        [_headImgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    return _headImgView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel rightLabelWithTitle:@"李马凤" font:30 color:UIColor.whiteColor];
    }
    return _nameLabel;
}
-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel=[UILabel centerLabelWithTitle:@"通话时长" font:20 color:UIColor.whiteColor];
    }
    return _durationLabel;
}

-(UILabel *)connectingLabel{
    if (!_connectingLabel) {
        _connectingLabel=[UILabel rightLabelWithTitle:@"" font:16 color:UIColor.whiteColor];
    }
    return _connectingLabel;
}
/** 扬声器
 */
-(UIButton *)speakerBtn{
    if (!_speakerBtn) {
        _speakerBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(speakerBtnAction)];
        //icon_NIM_speaker_select
        [_speakerBtn setBackgroundImage:UIImageMake(@"icon_NIM_speaker_unselect") forState:UIControlStateNormal];
        [_speakerBtn setBackgroundImage:UqIImageMake(@"icon_NIM_speaker_select") forState:UIControlStateSelected];
    }
    return _speakerBtn;
}
-(UILabel *)speakerLab{
    if (!_speakerLab) {
        _speakerLab=[UILabel centerLabelWithTitle:@"扬声器".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _speakerLab;;
}
-(void)speakerBtnAction{
    self.callInfo.useSpeaker = !self.callInfo.useSpeaker;
    self.speakerBtn.selected = self.callInfo.useSpeaker;
    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:self.callInfo.useSpeaker];
}
-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:19 titleColor:UIColor.whiteColor target:self action:@selector(muteBtnAction)];
        //icon_v_mute_white
        [_muteBtn setBackgroundImage:UIImageMake(@"icon_NIM_mute_unselect") forState:UIControlStateNormal];
        [_muteBtn setBackgroundImage:UIImageMake(@"icon_NIM_mute_select") forState:UIControlStateSelected];
    }
    return _muteBtn;
}
-(void)muteBtnAction{
    self.callInfo.isMute  = !self.callInfo.isMute;
    self.muteBtn.selected = self.callInfo.isMute;
    [[NIMAVChatSDK sharedSDK].netCallManager setMute:self.callInfo.isMute];
}
-(UILabel *)muteLab{
    if (!_muteLab) {
        _muteLab=[UILabel centerLabelWithTitle:@"静音".icanlocalized font:15 color:UIColor.whiteColor];
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
        _refuseLab=[UILabel centerLabelWithTitle:@"拒绝".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _refuseLab;;
}
-(void)refuseBtnAction{
    [self response:NO];
}
-(UIButton *)acceptBtn{
    if (!_acceptBtn) {
        _acceptBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_accep" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(acceptBtnAction)];
    }
    return _acceptBtn;
}
-(UILabel *)acceptLab{
    if (!_acceptLab) {
        _acceptLab=[UILabel centerLabelWithTitle:@"接听".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _acceptLab;;
}
-(void)acceptBtnAction{
    
    [self response:YES];
}
-(UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_refuse" backgroundColor:nil titleFont:19 titleColor:UIColor.clearColor target:self action:@selector(hangUpBtnAction)];
    }
    return _hangUpBtn;
}
-(UILabel *)hangUpLab{
    if (!_hangUpLab) {
        _hangUpLab=[UILabel centerLabelWithTitle:@"挂断".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _hangUpLab;;
}
-(void)hangUpBtnAction{
    [self hangup];
}
-(UIImageView *)bigVideoView{
    if (!_bigVideoView) {
        _bigVideoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bigVideoView.backgroundColor=UIColorMake(10,30,6);
    }
    return _bigVideoView;
}
-(UIView *)smallVideoView{
    if (!_smallVideoView) {
        _smallVideoView=[[UIView alloc]initWithFrame:CGRectMake(30, 39, 100, 200)];
        _smallVideoView.backgroundColor=UIColor.clearColor;
        _smallVideoView.hidden=YES;
    }
    return _smallVideoView;
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
        _switchModelLab=[UILabel centerLabelWithTitle:@"切换到语音通话".icanlocalized font:13 color:UIColor.whiteColor];
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
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"切换到语音通话".icanlocalized]];
        _switchModelLab.attributedText=att;
    }
    return _switchModelLab;
}
- (void)switchCallingModel{
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeToAudio];
    [self switchToAudio];
}


- (void)switchToAudio{
    [self audioCallingInterface];
}
//切换接听中界面(语音)
- (void)audioCallingInterface{
    NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallInfo:self.callInfo];
    [[NTESNotificationCenter sharedCenter]presentCallViewController:vc];
    
}
-(UIButton *)switchCameraBtn{
    if (!_switchCameraBtn) {
        _switchCameraBtn=[UIButton dzButtonWithTitle:@"" image:@"icon_v_switch_scene" backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(switchCamera)];
    }
    return _switchCameraBtn;
}
-(UILabel *)switchCameraLab{
    if (!_switchCameraLab) {
        _switchCameraLab=[UILabel centerLabelWithTitle:@"切换摄像头".icanlocalized font:15 color:UIColor.whiteColor];
    }
    return _switchCameraLab;
}
- (void)switchCamera{
    if (self.cameraType == NIMNetCallCameraFront) {
        self.cameraType = NIMNetCallCameraBack;
    }else{
        self.cameraType = NIMNetCallCameraFront;
    }
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:self.cameraType];
    self.switchCameraBtn.selected = (self.cameraType == NIMNetCallCameraBack);
}
//-(UIButton *)disableCameraBtn{
//    if (!_disableCameraBtn) {
//        _disableCameraBtn=[UIButton dzButtonWithTitle:@"" image:@"" backgroundColor:UIColor.whiteColor titleFont:0 titleColor:nil target:self action:@selector(disableCammera)];
//    }
//    return _disableCameraBtn;
//}
//- (void)disableCammera{
//    self.callInfo.disableCammera = !self.callInfo.disableCammera;
//    [[NIMAVChatSDK sharedSDK].netCallManager setCameraDisable:self.callInfo.disableCammera];
//    self.disableCameraBtn.selected = self.callInfo.disableCammera;
//    if (self.callInfo.disableCammera) {
//        [self.localPreView removeFromSuperview];
//        [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeCloseVideo];
//    }else{
//        [self.localView addSubview:self.localPreView];
//
//        [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeOpenVideo];
//    }
//}
#pragma mark - Call Life
- (void)startByCaller{
    [super startByCaller];
    [self startInterface];
}

- (void)startByCallee{
    [super startByCallee];
    [self waitToCallInterface];
}

- (void)onCalling{
    [super onCalling];
    [self videoCallingInterface];
}

- (void)waitForConnectiong{
    [super onCalling];
    [self connectingInterface];
}
- (void)onCalleeBusy{
    _calleeBasy = YES;
    if (_localPreView){
        [_localPreView removeFromSuperview];
    }
}
#pragma mark - Interface
//开始呼叫界面
- (void)startInterface{
    self.hangUpBtn.hidden  = self.hangUpLab.hidden = NO;
    [self.hangUpLab setText:@"取消".icanlocalized];
    self.muteBtn.hidden    = self.muteLab.hidden=YES;
    self.speakerBtn.hidden =self.speakerLab.hidden = YES;
    self.refuseBtn.hidden =self.refuseLab.hidden= YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"正在等待对方接受邀请".icanlocalized;
    self.localView = self.bigVideoView;
    self.switchModelLab.hidden=self.switchModelBtn.hidden=NO;
    self.switchBgView.hidden=YES;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
}

//接收方选择是否接听界面
- (void)waitToCallInterface{
    self.hangUpBtn.hidden  = self.hangUpLab.hidden = YES;
    self.muteBtn.hidden    =self.muteLab.hidden= YES;
    self.speakerBtn.hidden =self.speakerLab.hidden = YES;
    self.refuseBtn.hidden =self.refuseLab.hidden= NO;
    self.acceptBtn.hidden =self.acceptLab.hidden= NO;
    self.durationLabel.hidden   = YES;
    
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"邀请你进行视频通话".icanlocalized;
    self.switchModelLab.hidden=self.switchModelBtn.hidden=NO;
    self.switchBgView.hidden=YES;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=YES;
    
}

//连接对方中的界面
- (void)connectingInterface{
    self.hangUpBtn.hidden  =self.hangUpLab.hidden= NO;
    self.muteBtn.hidden    =self.muteLab.hidden= YES;
    self.speakerBtn.hidden =self.speakerLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"正在连接对方...请稍后...".icanlocalized;
    self.refuseBtn.hidden = self.refuseLab.hidden=YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.switchModelLab.hidden=self.switchModelBtn.hidden=NO;
    self.switchBgView.hidden=YES;
    
}
//接听中界面(视频)
- (void)videoCallingInterface{
    NIMNetCallNetStatus status = [[NIMAVChatSDK sharedSDK].netCallManager netStatus:self.peerUid];
    //    [self.netStatusView refreshWithNetState:status];
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.refuseBtn.hidden   =self.refuseLab.hidden= YES;
    self.muteBtn.hidden =self.muteLab.hidden= NO;
    self.hangUpBtn.hidden   =self.hangUpLab.hidden=  NO;
    self.connectingLabel.hidden = YES;
    //    self.disableCameraBtn.hidden = NO;
    self.switchCameraBtn.hidden=self.switchCameraLab.hidden=NO;
    self.switchModelLab.hidden=self.switchModelBtn.hidden=NO;
    self.switchBgView.hidden=NO;
    [self.hangUpLab setText:@"挂断".icanlocalized];
    //    self.muteBtn.enabled = YES;
    //    self.disableCameraBtn.enabled = YES;
    //    self.muteBtn.selected = self.callInfo.isMute;
    //    self.disableCameraBtn.selected = self.callInfo.disableCammera;
    self.nameLabel.hidden=self.connectingLabel.hidden=self.headImgView.hidden= YES;
    [self.hangUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hangUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    self.localPreView.hidden = NO;
    self.smallVideoView.hidden=NO;
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onLocalDisplayviewReady:(UIView *)displayView{
    if (_calleeBasy) {
        return;
    }
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    
    self.localPreView = displayView;
    displayView.frame = self.localView.bounds;
    
    [self.localView addSubview:displayView];
}

- (void)onRemoteDisplayviewReady:(UIView *)displayView user:(NSString *)user {
    
    if (_remoteView != displayView) {
        if (displayView.superview) {
            [displayView removeFromSuperview];
        }
        [_remoteView removeFromSuperview];
        _remoteView = displayView;
        _remoteView.frame = _bigVideoView.bounds;
        _remoteView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_bigVideoView addSubview:displayView];
    }
}

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    [super onControl:callID from:user type:control];
    switch (control) {
        case NIMNetCallControlTypeToAudio:
            [self switchToAudio];
            break;
        case NIMNetCallControlTypeCloseVideo:
            //            [self resetRemoteImage];
            self.oppositeCloseVideo = YES;
            _remoteView.hidden = YES;
            //            [self.view makeToast:@"对方关闭了摄像头".ntes_localized
            //                        duration:2
            //                        position:CSToastPositionCenter];
            break;
        case NIMNetCallControlTypeOpenVideo:
            self.oppositeCloseVideo = NO;
            _remoteView.hidden = NO;
            //            [self.view makeToast:@"对方开启了摄像头".ntes_localized
            //                        duration:2
            //                        position:CSToastPositionCenter];
            break;
        default:
            break;
    }
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user{
    
    if ([[user componentsSeparatedByString:@"_"].lastObject isEqualToString:[UserInfoManager sharedManager].userId]) {//表示自己的通话质量
        switch (status) {
            case NIMNetCallNetStatusBad:
                self.connectingLabel.hidden=NO;
                self.connectingLabel.text=@"当前你的通话质量较差".icanlocalized;
                break;
            case NIMNetCallNetStatusPoor:
                self.connectingLabel.hidden=NO;
                self.connectingLabel.text=@"当前你的通话质量较差".icanlocalized;
                break;
            default:
                self.connectingLabel.hidden=YES;
                break;
        }
    }else{
        switch (status) {
            case NIMNetCallNetStatusBad:
                self.connectingLabel.hidden=NO;
                self.connectingLabel.text=@"当前对方的通话质量较差".icanlocalized;
                break;
            case NIMNetCallNetStatusPoor:
                self.connectingLabel.hidden=NO;
                self.connectingLabel.text=@"当前对方的通话质量较差".icanlocalized;
                break;
            default:
                self.connectingLabel.hidden=YES;
                break;
        }
    }
}

#pragma mark - M80TimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
    [super onNTESTimerFired:holder];
    self.durationLabel.text = self.durationDesc;
}

#pragma mark -  Misc
- (NSString*)durationDesc{
    if (!self.callInfo.startTime) {
        return @"";
    }
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    NSTimeInterval duration = time - self.callInfo.startTime;
    return [NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
}

-(void)onCallEstablished:(UInt64)callID{
    if (self.callInfo.callID == callID) {
        [super onCallEstablished:callID];
        
        self.durationLabel.hidden = NO;
        self.durationLabel.text = self.durationDesc;
        if (self.localView == self.bigVideoView) {
            self.localView = self.smallVideoView;
            if (self.localPreView) {
                [self onLocalDisplayviewReady:self.localPreView];
            }
        }
    }
}

@end

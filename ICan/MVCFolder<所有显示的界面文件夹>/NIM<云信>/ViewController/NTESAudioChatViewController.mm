//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 16/4/2020
 - File name:  NTESAudioChatViewController.m
 - Description:
 - Function List:
 */


#import "NTESAudioChatViewController.h"
#import "NTESVideoChatViewController.h"
#import "NTESNetCallChatInfo.h"

#import <NIMAVChat/NIMAVChat.h>

#import "WCDBManager+UserMessageInfo.h"
@interface NTESAudioChatViewController ()

@end

@implementation NTESAudioChatViewController
- (instancetype)initWithCallInfo:(NTESNetCallChatInfo *)callInfo{
    self = [self init];
    if (self) {
        self.callInfo = callInfo;
        self.callInfo.isMute = NO;
        self.callInfo.disableCammera = NO;
        self.callInfo.useSpeaker = NO;
        [[NIMAVChatSDK sharedSDK].netCallManager switchType:NIMNetCallMediaTypeAudio];
    }
    return self;
}
- (void)loadView {
    [super loadView];
    self.callInfo.callType = NIMNetCallMediaTypeAudio;
    [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorMake(31, 33, 38);
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
-(void)initUI{
    
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
    [self.view addSubview:self.switchBgView];
//    [self.switchBgView addSubview:self.switchVideoBtn];
    [self.switchBgView addSubview:self.switchVideoLab];
    
    
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
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    //    CGFloat top =isIPhoneX?:
    [self.switchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@64);
//        make.height.equalTo(@35);
//        make.width.equalTo(@150);
    }];
//    [self.switchVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@10);
//        make.width.height.equalTo(@23);
//        make.centerY.equalTo(self.switchBgView.mas_centerY);
//    }];
    
    [self.switchVideoLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.switchBgView.mas_centerY);
//        make.left.equalTo(self.switchVideoBtn.mas_right).offset(10);
        make.left.equalTo(self.switchBgView.mas_left);
        make.right.equalTo(self.switchBgView.mas_right);
        make.top.equalTo(self.switchBgView.mas_top);
        make.bottom.equalTo(self.switchBgView.mas_bottom);
    }];
    
}
-(void)hiddenALLView{
    self.hangUpBtn.hidden  = self.hangUpLab.hidden = YES;
    [self.hangUpLab setText:@"挂断".icanlocalized];
    self.muteBtn.hidden    =self.muteLab.hidden= YES;
    self.speakerBtn.hidden = self.speakerLab.hidden = YES;
    self.refuseBtn.hidden =self.refuseLab.hidden= YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.switchBgView.hidden  = YES;
    self.connectingLabel.hidden = YES;
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
        _nameLabel=[UILabel centerLabelWithTitle:@"李马凤" font:30 color:UIColor.whiteColor];
    }
    return _nameLabel;
}
-(UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel=[UILabel centerLabelWithTitle:@"通话时长" font:20 color:UIColor.whiteColor];
    }
    return _durationLabel;
}
/** 切换视频
 */
-(UIControl *)switchBgView{
    if (!_switchBgView) {
        _switchBgView=[[UIControl alloc]init];
        [_switchBgView layerWithCornerRadius:5 borderWidth:0.5 borderColor:UIColor.whiteColor];
        _switchBgView.hidden=YES;
        [_switchBgView addTarget:self action:@selector(switchVideoBtnAction) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _switchBgView;
}
-(UIButton *)switchVideoBtn{
    if (!_switchVideoBtn) {
        _switchVideoBtn=[UIButton dzButtonWithTitle:nil image:@"icon_switch_video" backgroundColor:UIColor.clearColor titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(switchVideoBtnAction)];
    }
    return _switchVideoBtn;
}
-(UILabel *)switchVideoLab{
    if (!_switchVideoLab) {
        _switchVideoLab=[UILabel centerLabelWithTitle:@"切换到视频通话".icanlocalized font:13 color:UIColor.whiteColor];
        NSAttributedString*nullString= [[NSAttributedString alloc]initWithString:@" "];
        NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithAttributedString:nullString];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:@"icon_switch_video"];
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds = CGRectMake(0, 0, 13 , 13);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [att appendAttributedString:imageStr];
        [att appendAttributedString:nullString];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"切换到视频通话".icanlocalized]];
        _switchVideoLab.attributedText=att;
    }
    return _switchVideoLab;
}
-(void)switchVideoBtnAction{
    //    [self.view makeToast:@"已发送转换请求，请等待对方应答...".ntes_localized
    //                duration:2
    //                position:CSToastPositionCenter];
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeToVideo];
}
-(UILabel *)connectingLabel{
    if (!_connectingLabel) {
        _connectingLabel=[UILabel centerLabelWithTitle:@"" font:16 color:UIColor.whiteColor];
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
        [_speakerBtn setBackgroundImage:UIImageMake(@"icon_NIM_speaker_select") forState:UIControlStateSelected];
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
        _hangUpBtn=[UIButton dzButtonWithTitle:nil image:@"icon_v_refuse" backgroundColor:nil titleFont:19 titleColor:UIColor.blackColor target:self action:@selector(hangUpBtnAction)];
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
    [self audioCallingInterface];
}

- (void)waitForConnectiong{
    [super onCalling];
    [self connectingInterface];
}

#pragma mark - Interface
//开始呼叫界面
- (void)startInterface{
    self.hangUpBtn.hidden  =self.hangUpLab.hidden = NO;
    [self.hangUpLab setText:@"取消".icanlocalized];
    self.muteBtn.hidden    = self.muteLab.hidden=YES;
    
    self.speakerBtn.hidden =self.speakerLab.hidden = YES;
    self.refuseBtn.hidden = self.refuseLab.hidden= YES;
    self.acceptBtn.hidden = self.acceptLab.hidden=YES;
    self.durationLabel.hidden   = YES;
    self.switchBgView.hidden  = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"正在等待对方接受邀请".icanlocalized;
    
}

//接收方选择是否接听界面
- (void)waitToCallInterface{
    self.hangUpBtn.hidden  = YES;
    self.hangUpLab.hidden =YES;
    self.muteBtn.hidden    = YES;
    self.muteLab.hidden=YES;
    self.speakerBtn.hidden = YES;
    self.speakerLab.hidden =YES;
    self.refuseBtn.hidden = NO;
    self.refuseLab.hidden=NO;
    self.acceptBtn.hidden = NO;
    self.acceptLab.hidden=NO;
    self.durationLabel.hidden   = YES;
    self.switchBgView.hidden  = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"邀请你进行语音通话".icanlocalized;
    
    
}

//连接对方中的界面
- (void)connectingInterface{
    self.hangUpBtn.hidden  =self.hangUpLab.hidden =NO;
    self.muteBtn.hidden    =self.muteLab.hidden =YES;
    self.speakerBtn.hidden = self.speakerLab.hidden= YES;
    self.durationLabel.hidden   = YES;
    self.switchBgView.hidden  = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text   = @"正在连接对方...请稍后...".icanlocalized;
    self.refuseBtn.hidden = YES;
    self.refuseLab.hidden=YES;
    self.acceptBtn.hidden = YES;
    self.acceptLab.hidden=YES;
}

//接听中界面(音频)
- (void)audioCallingInterface{
    NSString *peerUid = ([self.callInfo.caller isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) ? self.callInfo.callee : self.callInfo.caller;
    NIMNetCallNetStatus status = [[NIMAVChatSDK sharedSDK].netCallManager netStatus:peerUid];
    //    [self.netStatusView refreshWithNetState:status];
    self.hangUpBtn.hidden  = self.hangUpLab.hidden = NO;
    [self.hangUpLab setText:@"挂断".icanlocalized];
    self.muteBtn.hidden    =self.muteLab.hidden= NO;
    self.speakerBtn.hidden = self.speakerLab.hidden = NO;
    self.refuseBtn.hidden =self.refuseLab.hidden= YES;
    self.acceptBtn.hidden =self.acceptLab.hidden= YES;
    self.durationLabel.hidden   = NO;
    self.switchBgView.hidden  = YES;
    self.connectingLabel.hidden = YES;
}
#pragma mark - NIMNetCallManagerDelegate

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    [super onControl:callID from:user type:control];
    switch (control) {
        case NIMNetCallControlTypeToVideo:
            [self onResponseVideoMode];
            break;
        case NIMNetCallControlTypeAgreeToVideo:
            [self videoCallingInterface];
            break;
        case NIMNetCallControlTypeRejectToVideo:
            //            [self.view makeToast:@"对方拒绝切换到视频模式".ntes_localized
            //                        duration:2
            //                        position:CSToastPositionCenter];
            break;
        default:
            break;
    }
}
//切换接听中界面(视频)
- (void)videoCallingInterface{
    NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallInfo:self.callInfo];
    [[NTESNotificationCenter sharedCenter]presentCallViewController:vc];
}
/**
 对话建立成功 显示时间label
 */
-(void)onCallEstablished:(UInt64)callID{
    if (self.callInfo.callID == callID) {
        [super onCallEstablished:callID];
        self.durationLabel.hidden = NO;
        self.durationLabel.text = self.durationDesc;
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


- (void)onResponseVideoMode{
    UIAlertController*vc=[UIAlertController alertCTWithTitle:nil message:@"对方请求切换为视频模式".icanlocalized preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"拒绝".icanlocalized,@"同意".icanlocalized] handler:^(int index) {
        if (index==0) {
            [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeRejectToVideo];
        }else{
            
            [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeAgreeToVideo];
            [self videoCallingInterface];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end

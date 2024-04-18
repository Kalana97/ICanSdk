//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/4/2021
- File name:  NeCallBaseViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"
#import "NERtcCallKitConsts.h"
#import "NERtcCallKit.h"
#import "NEVideoView.h"
#ifdef ICANTYPE
#import <CallKit/CallKit.h>
#endif
NS_ASSUME_NONNULL_BEGIN



@interface NeCallBaseViewController : BaseViewController<NERtcCallKitDelegate,NEVideoViewDelegate>

/** 对方的头像 */
@property(nonatomic, strong) DZIconImageView *headImgView;
/** 对方的名字 */
@property(nonatomic, strong) UILabel *nameLabel;
/** 时间label
 */
@property (nonatomic,strong)  UILabel *durationLabel;
/** 是否开启网络静音
 */
@property (nonatomic,strong)  UIButton *muteBtn;
/** 挂断label
 */
@property(nonatomic, strong) UILabel *muteLab;
/** 开启扬声器
 */
@property (nonatomic,strong)  UIButton *speakerBtn;

/** 挂断label
 */
@property(nonatomic, strong) UILabel *speakerLab;
/** 挂断
 */
@property (nonatomic,strong)  UIButton *hangUpBtn;
/** 挂断label
 */
@property(nonatomic, strong) UILabel *hangUpLab;
/** 连接
 */
@property (nonatomic,strong)  UILabel  *connectingLabel;
/** 拒绝接听
 */
@property (nonatomic,strong)  UIButton *refuseBtn;
/** 拒绝label
 */
@property(nonatomic, strong) UILabel *refuseLab;
/** 接听
 */
@property (nonatomic,strong)  UIButton *acceptBtn;
/** 接听label
 */
@property(nonatomic, strong) UILabel *acceptLab;

/**
 取消
 */
@property (nonatomic,strong)  UIButton *cancelBtn;
/**
 取消label
 */
@property(nonatomic, strong) UILabel *cancelLab;

@property(assign,nonatomic)NERtcCallType type;
@property(assign,nonatomic)NERtcCallStatus status;
/// 对方账号
@property(strong,nonatomic)NSString *otherUserID;
/// 自己账号
@property(strong,nonatomic)NSString *myselfID;

@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音

@property (nonatomic,assign) NSInteger statsCount; // 计算网络统计次数，前3次产生误差，忽略
@property (nonatomic,strong) UILabel *statsLabel; // 显示网络异常状态

@property(strong,nonatomic)NEVideoView *smallVideoView;
@property(strong,nonatomic)NEVideoView *bigVideoView;

@property (nonatomic,assign) BOOL isCalled;

@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *avtar;

/**
 关闭摄像头
 */
@property (nonatomic,strong)  UIButton *closeVideoBtn;
/**
 打开摄像头
 */
@property(nonatomic, strong) UILabel *closeVideoLab;
/** 切换摄像头
 */
@property(strong,nonatomic)UIButton *switchCameraBtn;

@property(nonatomic, strong) UILabel *switchCameraLab;//

/** 切换模式的按钮
 */
@property(nonatomic, strong)  UIView *switchBgView;

/** 切到语音通话
 */
@property(nonatomic, strong) UILabel *switchModelLab;//
@property (nonatomic, strong) NSUUID *uuid;
#ifdef ICANTYPE
@property (nonatomic, strong) CXProvider *provider;
@property (nonatomic, strong) CXCallController *callController;
@property (nonatomic, strong) CXCallUpdate *callUpdate;
@property (nonatomic, assign) BOOL isOutGoingCall;
#endif
/** 设置本地视频 */
-(void)setupLocalView;
/// 初始化ViewController
/// @param member 对方IM账号
/// @param isCalled 是否是被呼叫
/// @param type 语音或视频
/// /** 扬声器 */speaker
-(void)speakerBtnAction;
-(void)cancelBtnAction;
-(void)muteBtnAction:(UIButton*)button;
-(void)refuseBtnAction;
-(void)acceptBtnAction;
-(void)hangUpBtnAction;
- (instancetype)initWithOtherMember:(NSString *)member isCalled:(BOOL)isCalled type:(NERtcCallType)type uuid:(NSUUID *)uuid;
@end

NS_ASSUME_NONNULL_END

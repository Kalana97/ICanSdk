//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 16/4/2020
- File name:  NTESVideoChatViewController.h
- Description:视频通话
- Function List:
*/
        

#import "NTESNetChatViewController.h"
#import "NTESNotificationCenter.h"
NS_ASSUME_NONNULL_BEGIN

@interface NTESVideoChatViewController : NTESNetChatViewController
- (instancetype)initWithCallInfo:(NTESNetCallChatInfo *)callInfo;
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
/** 网络静音label
 */
@property(nonatomic, strong) UILabel *muteLab;
/** 开启扬声器
 */
@property (nonatomic,strong)  UIButton *speakerBtn;

/** 开启扬声器label
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

@property (strong, nonatomic)  UIImageView *bigVideoView;
@property (strong, nonatomic)  UIView *smallVideoView;
/** 切换模式的按钮
 */
@property(nonatomic, strong)  UIView *switchBgView;
/** 模式转换按钮
 */
@property (nonatomic,strong)  UIButton *switchModelBtn; //
/** 切到语音通话
 */
@property(nonatomic, strong) UILabel *switchModelLab;//
/** 切换前后摄像头
 */
@property (nonatomic,strong)  UIButton *switchCameraBtn; //
/** 切换摄像头
 */
@property(nonatomic, strong) UILabel *switchCameraLab;//


@property (nonatomic,strong)  UIButton *disableCameraBtn; //禁用摄像头按钮
@end

NS_ASSUME_NONNULL_END

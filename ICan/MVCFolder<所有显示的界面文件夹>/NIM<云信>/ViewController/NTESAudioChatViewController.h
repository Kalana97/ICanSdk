//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 16/4/2020
- File name:  NTESAudioChatViewController.h
- Description:音频通话
- Function List:
*/
        

#import "NTESNetChatViewController.h"
#import "NTESNetCallChatInfo.h"
#import "NTESNotificationCenter.h"
NS_ASSUME_NONNULL_BEGIN

@interface NTESAudioChatViewController : NTESNetChatViewController

- (instancetype)initWithCallInfo:(NTESNetCallChatInfo *)callInfo;
/** 对方的头像 */
@property(nonatomic, strong) DZIconImageView *headImgView;
/** 对方的名字 */
@property(nonatomic, strong) UILabel *nameLabel;
/** 时间label
 */
@property (nonatomic,strong)  UILabel *durationLabel;
/** 切换模式的按钮
 */
@property(nonatomic, strong)  UIControl *switchBgView;
@property (nonatomic,strong)  UIButton *switchVideoBtn;
@property (nonatomic,strong)  UILabel *switchVideoLab;
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

//@property (nonatomic,strong) IBOutlet NTESVideoChatNetStatusView *netStatusView;

@property (weak, nonatomic)  UIButton *localRecordBtn;


@property (weak, nonatomic)  UIView *localRecordingView;

@property (weak, nonatomic)  UIView *localRecordingRedPoint;

@property (weak, nonatomic)  UIView *lowMemoryView;

@property (weak, nonatomic)  UIView *lowMemoryRedPoint;

@end

NS_ASSUME_NONNULL_END

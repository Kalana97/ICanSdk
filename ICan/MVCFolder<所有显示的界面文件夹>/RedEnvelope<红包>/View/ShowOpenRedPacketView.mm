//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 1/4/2020
 - File name:  ShowOpenRedPacketView.m
 - Description:
 - Function List:
 */


#import "ShowOpenRedPacketView.h"
#import "WCDBManager+UserMessageInfo.h"

@interface ShowOpenRedPacketView()
/**   开redPacket按钮 */
@property (strong, nonatomic)  UIButton *openButton;
/**  开红包的背景imageView*/
@property (strong, nonatomic)  UIImageView *backGroundImgView;
/**  查看详情按钮 */
@property (strong, nonatomic)  UIButton *showDetailbutton;
/** 红包未点击之前的图标 */
@property(nonatomic, strong) UIImageView *normalImageView;
/** 头像 */
@property (strong, nonatomic)  DZIconImageView *headerIconView;
/** 姓名 */
@property (strong, nonatomic)  UILabel *nameLabel;
/** 红包类型  是random */
@property (strong, nonatomic)  UILabel *redTypeLabel;
/**  红包留言信息  */
@property (strong, nonatomic)  UILabel *redCommentLabel;
/** 一个背景view */
@property (nonatomic,strong) UIView *coverView;

/** 关闭 */
@property (strong, nonatomic) UIButton * closeButton;

@end

@implementation ShowOpenRedPacketView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(void)setModel:(ChatModel *)model{
    _model=model;
    SingleRedPacketMessageInfo*info=[SingleRedPacketMessageInfo mj_objectWithKeyValues:model.messageContent];
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
        [self.headerIconView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        NSString*nameString;
        if (BaseSettingManager.isChinaLanguages) {
            nameString=[NSString stringWithFormat:@" %@的红包",info.nickname];
        }else{
            nameString=[NSString stringWithFormat:@"%@’s red packet",info.nickname];
        }
        NSMutableAttributedString*attri1 = [[NSMutableAttributedString alloc]initWithString:nameString];
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment*attch1 = [[NSTextAttachment alloc]init];
        //定义图片内容及位置和大小qmui_imageWithClippedCornerRadius
        attch1.image=[self.headerIconView.image qmui_imageWithClippedCornerRadius:10000];
        attch1.bounds=CGRectMake(0, -8,25,25);
        //创建带有图片的富文本
        NSAttributedString*string1 = [NSAttributedString attributedStringWithAttachment:attch1];
        //将图片放在第一位
        [attri1 insertAttributedString:string1 atIndex:0];
        self.nameLabel.attributedText=attri1;
    }];
    self.redCommentLabel.text=info.comment;
    if (model.redPacketState) {
        self.showDetailbutton.hidden=NO;
        self.normalImageView.hidden=YES;
        self.openButton.hidden=YES;
        if ([model.redPacketState isEqualToString:Kreceived]) {//已经抢过
            self.redCommentLabel.text=@"You have already grabbed the red packet".icanlocalized;
        }else if ([model.redPacketState isEqualToString:Kexpired]) {//已经过期
            if (!model.isOutGoing) {
                self.showDetailbutton.hidden=YES;
                self.normalImageView.hidden=YES;
                self.redCommentLabel.text=@"The red packet has expired".icanlocalized;
            }
        }else if ([model.redPacketState isEqualToString:KEmpty]){//已经抢完
            self.redCommentLabel.text=@"Too Slow， Red packet has finished".icanlocalized;
        }else{//成功抢到多少钱
            NSString*amount=[NSString stringWithFormat:@"%.2f元",[model.redPacketAmount doubleValue]];
            NSMutableAttributedString*amountStr=[[NSMutableAttributedString alloc]initWithString:amount];
            [amountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, amount.length)];
            [amountStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(amount.length-1, 1)];
            self.redCommentLabel.attributedText=amountStr;
        }
    }else{
        self.showDetailbutton.hidden=YES;
        self.normalImageView.hidden=NO;
    }

   
    
}
// 关闭页面
- (void)closeAction {
    [self.openButton.layer removeAllAnimations];
    self.showDetailbutton.hidden=YES;
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [self hidden];
}

// 打开redPacket
- (void)openRedEnvelopAction{
    CABasicAnimation* rotationAnimation;
    //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    //旋转角度
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    //每次旋转的时间（单位秒）
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.openButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    if (self.openButtonBlock) {
        self.openButtonBlock();
    }
}
-(void)setUpView{
    [self addSubview:self.backGroundImgView];
    [self.backGroundImgView addSubview:self.headerIconView];
    [self.backGroundImgView addSubview:self.nameLabel];
    [self.backGroundImgView addSubview:self.redCommentLabel];
    [self.backGroundImgView addSubview:self.openButton];
    [self.backGroundImgView addSubview:self.showDetailbutton];
    [self.backGroundImgView addSubview:self.normalImageView];
    [self addSubview:self.closeButton];
    if (ScreenWidth<=330) {//4s 5
        [self.backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(@35);
            make.right.equalTo(@-35);
            make.height.equalTo(@(400));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(@100);
        }];
        
        [self.redCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@90);
            make.width.equalTo(@(90*0.961));
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@(-40));
        }];
        [self.showDetailbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@-10);
        }];
        [self.normalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@-10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.backGroundImgView.mas_bottom).offset(25);
        }];
    }else{
        [self.backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(@35);
            make.right.equalTo(@-35);
            make.height.equalTo(@(500));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.top.equalTo(@120);
        }];
        
        [self.redCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
        }];
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@90);
            make.width.equalTo(@(90*0.961));
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@(-125/2.0));
        }];
        [self.showDetailbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@-10);
        }];
        [self.normalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backGroundImgView.mas_centerX);
            make.bottom.equalTo(@-10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.backGroundImgView.mas_bottom).offset(25);
        }];
    }
    
    
    [_backGroundImgView.superview sendSubviewToBack:_backGroundImgView];
}
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.coverView];
    [window addSubview:self];
    [UIView animateWithDuration:.15
                     animations:^{
        self.backGroundImgView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        self.coverView.alpha=0.2;
    }completion:^(BOOL finish){
        [UIView animateWithDuration:.15
                         animations:^{
            self.backGroundImgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.coverView.alpha=0.5;
        }completion:^(BOOL finish){
            [UIView animateWithDuration:.15
                             animations:^{
                self.backGroundImgView.transform = CGAffineTransformMakeScale(1, 1);
                self.coverView.alpha=1;
            }];
        }];
    }];
    self.center = CGPointMake(window.center.x, window.center.y);
}
- (void)hidden {
    [UIView animateWithDuration:.2 animations:^{
        self.backGroundImgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08  animations:^{
            self.backGroundImgView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        }completion:^(BOOL finish){
            [self removeFromSuperview];
            [self.coverView removeFromSuperview];
            self.coverView.alpha=0;
            
        }];
    }];
}

-(void)setIsSingleRed:(BOOL)isSingleRed{
    self.showDetailbutton.hidden=isSingleRed;
}
-(void)showOpenButton{
    self.openButton.selected=NO;
    self.openButton.userInteractionEnabled=YES;
    self.openButton.hidden=NO;
    self.redTypeLabel.hidden=NO;
    self.redCommentLabel.hidden=NO;
    
}
#pragma mark -- redPacket领完了--
- (void)noEnvelope {
    self.backGroundImgView.highlighted = NO;
    self.openButton.hidden = YES;
    self.showDetailbutton.hidden=NO;
    self.redCommentLabel.text = @"Too Slow， Red packet has finished".icanlocalized;
    self.normalImageView.hidden=YES;
}

#pragma mark -- 红包过期--
- (void)redEnvelopeOverTime:(ChatModel*)model {
    self.openButton.hidden = YES;
    self.redCommentLabel.text = @"The red packet has expired".icanlocalized;
    self.backGroundImgView.highlighted = NO;
    if (model.isOutGoing) {
        self.showDetailbutton.hidden=NO;
        self.normalImageView.hidden=NO;
    }else{
        self.showDetailbutton.hidden=YES;
        self.normalImageView.hidden=NO;
    }
   
}
//你已经领过该红包
-(void)redHasReceived{
    self.openButton.hidden = YES;
    self.redTypeLabel.hidden = YES;
    self.redCommentLabel.text = @"You have already grabbed the red packet".icanlocalized;
    self.backGroundImgView.highlighted = NO;
    self.normalImageView.hidden=YES;
    self.showDetailbutton.hidden=NO;
}
-(void)redBalanceLack{
    self.openButton.hidden = YES;
    self.redTypeLabel.hidden = YES;
    //    self.redCommentLabel.text = KbalanceLackDescription;
    self.backGroundImgView.highlighted = NO;
}
-(void)redNoInTheRoom{
    self.openButton.hidden = YES;
    self.redTypeLabel.hidden = YES;
    self.backGroundImgView.highlighted = NO;
}
-(void)otherError{
    self.openButton.hidden = NO;
    self.redTypeLabel.hidden = YES;
    self.redCommentLabel.text = nil;
    self.backGroundImgView.highlighted = NO;
    self.openButton.selected=NO;
    self.openButton.userInteractionEnabled=YES;
    [self.openButton.layer removeAllAnimations];
}
-(UIImageView *)backGroundImgView{
    if (!_backGroundImgView) {
        _backGroundImgView=[[UIImageView alloc]init];
        _backGroundImgView.image=[UIImage imageNamed:@"img_openredview_bg"];
        _backGroundImgView.userInteractionEnabled=YES;
    }
    return _backGroundImgView;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.tag=100;
        [_closeButton setBackgroundImage:[[UIImage imageNamed:@"icon_red_close"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
        
    }
    return _closeButton;
}

-(void)buttonAction:(UIButton*)button{
    
    switch (button.tag) {
        case 100:{
            [self closeAction];
        }
            break;
        case 101:{
            [self openRedEnvelopAction];
        }
            
            break;
        case 102:{
            if (self.showDetailBlock) {
                self.showDetailBlock(self.model);
            }
        }
            
            break;
        default:
            break;
    }
}
-(DZIconImageView *)headerIconView{
    if (!_headerIconView) {
        _headerIconView=[[DZIconImageView alloc]init];
        [_headerIconView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        _headerIconView.image=[UIImage imageNamed:@"avatar_boy"];
        _headerIconView.backgroundColor=UIColor.whiteColor;
    }
    return _headerIconView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        
        _nameLabel=[UILabel centerLabelWithTitle:nil font:16 color:UIColorMake(255, 217, 177)];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLabel;
}
-(UILabel *)redTypeLabel{
    if (!_redTypeLabel) {
        _redTypeLabel=[UILabel centerLabelWithTitle:@"Sent you a random red packet".icanlocalized font:12 color:UIColorMake(240, 214, 166)];
    }
    return _redTypeLabel;
}
-(UILabel *)redCommentLabel{
    if (!_redCommentLabel) {
        _redCommentLabel=[UILabel centerLabelWithTitle:@"Sent you a random red packet".icanlocalized font:24 color:UIColorMake(255, 217, 177)];
        _redCommentLabel.numberOfLines=0;
    }
    return _redCommentLabel;
}
-(UIButton *)openButton{
    if (!_openButton) {
        _openButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _openButton.userInteractionEnabled=YES;
        _openButton.tag=101;
        [_openButton setBackgroundImage:[UIImage imageNamed:@"icon_red_open"] forState:UIControlStateNormal];
    }
    return _openButton;
}
-(UIImageView *)normalImageView{
    if (!_normalImageView) {
        _normalImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_red_decorate")];
    }
    return _normalImageView;
}
-(UIButton *)showDetailbutton{
    if (!_showDetailbutton) {
        _showDetailbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_showDetailbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _showDetailbutton.tag=102;
        _showDetailbutton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_showDetailbutton setTitleColor:UIColorMake(255, 217, 177) forState:UIControlStateNormal];
        [_showDetailbutton setTitle:[NSString stringWithFormat:@"%@>",NSLocalizedString(@"ViewDetails", 查看领取详情)] forState:UIControlStateNormal];
        _showDetailbutton.hidden=YES;
        
    }
    return _showDetailbutton;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        _coverView = [[UIView alloc] initWithFrame:window.bounds];
        CGFloat rgb = 83 / 255.0;
        _coverView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
        _coverView.alpha = 0;
        _coverView.userInteractionEnabled=YES;
    }
    return _coverView;
}

@end

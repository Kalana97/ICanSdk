//
//  ChatLeftVoiceTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightVoiceTableViewCell.h"
#import "ReactionBar.h"

@interface ChatRightVoiceTableViewCell()
///外层背景view
@property(nonatomic, strong) UIView *voiceBgView;
@property(nonatomic, strong) UIStackView *voiceBodyHorizontalStackView;
@property(nonatomic, strong) UIView *voiceContentBgView;
@property(nonatomic, strong) UIStackView *voiceContentHorizontalStackView;
@property(nonatomic, strong) UIImageView *voicePlayImgView;
@property(nonatomic, strong)  UILabel *timeLabelDown;
@property(nonatomic, strong) UILabel *voiceSecondsLab;
@property(nonatomic, strong) ReactionBar *reactionBar;
@property(nonatomic, strong) UIView *reactionView;
@end
@implementation ChatRightVoiceTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    self.voiceSecondsLab.text = [NSString stringWithFormat:@"%ld\"",(long)self.currentChatModel.mediaSeconds];
    [self.voiceBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.currentChatModel.layoutWidth));
        
    }];
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.voiceContentHorizontalStackView addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceContentHorizontalStackView.mas_right).offset(25);
        make.top.equalTo(self.voiceContentHorizontalStackView.mas_top).offset(34);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.bodyContentView addSubview:self.voiceBgView];
    [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.left.equalTo(@30);
        make.top.bottom.right.equalTo(@0);
        make.width.equalTo(@100);
    }];
    [self.bodyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
    }];
    [self.voiceBgView addSubview:self.voiceContentHorizontalStackView];
    [self.voiceContentHorizontalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@-5);
        make.right.equalTo(@-30);
        make.left.equalTo(@10);
        
    }];
    [self.voiceContentHorizontalStackView addArrangedSubview:self.voiceSecondsLab];
    [self.voiceContentHorizontalStackView addArrangedSubview:self.voicePlayImgView];
    [self.voicePlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
    }];
    
    //语音
    UITapGestureRecognizer*voiceTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *voiceLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.voiceBgView addGestureRecognizer:voiceTap];
    [self.voiceBgView addGestureRecognizer:voiceLongGesture];
    [self.voiceBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-5);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(24);
    }];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus) {
        self.convertRectView =  self.voiceBgView;
        [super longPress:longPressGes];
    }
}
-(void)setVoiceMessageState:(XMNVoiceMessageState)voiceMessageState{
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    if (_voiceMessageState == XMNVoiceMessageStatePlaying) {
        [self.voicePlayImgView aimationWithNomalImgName:@"message_voice_sender_normal"
                                          animationImages:@[@"message_voice_sender_playing_1",
                                                            @"message_voice_sender_playing_2",
                                                            @"message_voice_sender_playing_3"]
                                        animationDuration:1.5f];
        
        [self.voicePlayImgView startAnimating];
    }else {
        [self.voicePlayImgView stopAnimating];
    }
}
-(UIView *)voiceBgView{
    if (!_voiceBgView) {
        _voiceBgView = [[UIView alloc]init];
        _voiceBgView.backgroundColor = [UIColor qmui_colorWithHexString:@"#DDEBFF"];
        _voiceBgView.layer.cornerRadius = 10;
    }
    return _voiceBgView;
}
-(UIStackView *)voiceBodyHorizontalStackView{
    if (!_voiceBodyHorizontalStackView) {
        _voiceBodyHorizontalStackView = [[UIStackView alloc]init];
        _voiceBodyHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _voiceBodyHorizontalStackView.alignment = UIStackViewAlignmentCenter;
        _voiceBodyHorizontalStackView.spacing = 5;
        
    }
    return _voiceBodyHorizontalStackView;
}
-(UIView *)voiceContentBgView{
    if (!_voiceContentBgView) {
        _voiceContentBgView = [[UIView alloc]init];
        _voiceContentBgView.backgroundColor = UIColor.clearColor;
        
    }
    return _voiceContentBgView;
}

-(UIStackView *)voiceContentHorizontalStackView{
    if (!_voiceContentHorizontalStackView) {
        _voiceContentHorizontalStackView = [[UIStackView alloc]init];
        _voiceContentHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _voiceContentHorizontalStackView.alignment = UIStackViewAlignmentCenter;
        _voiceContentHorizontalStackView.spacing = 10;
        
    }
    return _voiceContentHorizontalStackView;
}
-(UIImageView *)voicePlayImgView{
    if (!_voicePlayImgView) {
        _voicePlayImgView = [[UIImageView alloc]init];
        _voicePlayImgView.image = UIImageMake(@"message_voice_sender_normal");
        _voicePlayImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _voicePlayImgView;
}
-(UILabel *)voiceSecondsLab{
    if (!_voiceSecondsLab) {
        _voiceSecondsLab = [UILabel rightLabelWithTitle:nil font:14 color:UIColor.darkGrayColor];
    }
    return _voiceSecondsLab;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}

- (UIView *)reactionView{
    if (!_reactionView) {
        _reactionView = [[UIView alloc]init];
    }
    return _reactionView;
}

-(ReactionBar *)reactionBar{
    if(!_reactionBar){
        _reactionBar = [[ReactionBar alloc] init];
        _reactionBar.backgroundColor = UIColorMake(243, 243, 243);
    }
    return _reactionBar;
}
@end

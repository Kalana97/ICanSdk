//
//  ChatLeftVoiceTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftVoiceTableViewCell.h"
#import "ReactionBar.h"
@interface ChatLeftVoiceTableViewCell()
///外层背景view
@property(nonatomic, strong) UIView *voiceBgView;
@property(nonatomic, strong) UIStackView *voiceBodyHorizontalStackView;
@property(nonatomic, strong) UIView *voiceContentBgView;
@property(nonatomic, strong) UIStackView *voiceContentHorizontalStackView;
@property(nonatomic, strong) UIImageView *voicePlayImgView;
@property(nonatomic,strong)  UILabel *timeLabelDown;

@property(nonatomic, strong) UILabel *voiceSecondsLab;
@property(nonatomic, strong) UIView *redTipsView;
@property(nonatomic, strong) ReactionBar *reactionBar;
@property(nonatomic, strong) UIView *reactionView;
@property(nonatomic, strong) UIView *reactMarginView;
@end
@implementation ChatLeftVoiceTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    self.voiceSecondsLab.text = [NSString stringWithFormat:@"%ld\"",(long)self.currentChatModel.mediaSeconds];
    [self.voiceBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.currentChatModel.layoutWidth));
    }];
    self.redTipsView.hidden = self.currentChatModel.voiceHasRead;
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.contentVerticalStackView addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceBgView.mas_right).offset(-18);
        make.top.equalTo(self.voiceBgView.mas_top).offset(28);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
        self.reactMarginView.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        self.reactMarginView.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView =  self.voiceBgView;
        [super longPress:longPressGes];
    }
}
-(void)clickMessageCell{
    if (!self.currentChatModel.voiceHasRead) {
        self.redTipsView.hidden = YES;
    }
    [super clickMessageCell];
}
-(void)setVoiceMessageState:(XMNVoiceMessageState)voiceMessageState{
    self.redTipsView.hidden=YES;
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    if (_voiceMessageState == XMNVoiceMessageStatePlaying) {
        [self.voicePlayImgView aimationWithNomalImgName:@"message_voice_receiver_normal"
                                          animationImages:@[@"message_voice_receiver_playing_1",
                                                            @"message_voice_receiver_playing_2",
                                                            @"message_voice_receiver_playing_3"]
                                        animationDuration:1.5f];
        [self.voicePlayImgView startAnimating];
    }else {
        [self.voicePlayImgView stopAnimating];
    }
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVerticalStackView addArrangedSubview:self.voiceBgView];
    
    [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
    }];
//    [self.bodyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@45);
//    }];
    [self.voiceBgView addSubview:self.voiceBodyHorizontalStackView];
    [self.voiceBodyHorizontalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        
    }];
    [self.voiceBodyHorizontalStackView addArrangedSubview:self.voiceContentBgView];
    [self.voiceContentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
    }];
    [self.voiceContentBgView addSubview:self.voiceContentHorizontalStackView];
    [self.voiceContentHorizontalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@-5);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
    [self.voiceContentHorizontalStackView addArrangedSubview:self.voicePlayImgView];
    [self.voicePlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
    }];
    [self.voiceContentHorizontalStackView addArrangedSubview:self.voiceSecondsLab];
    //语音
    UITapGestureRecognizer*voiceTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *voiceLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.voiceBgView addGestureRecognizer:voiceTap];
    [self.voiceBgView addGestureRecognizer:voiceLongGesture];
    [self.voiceBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@24);
    }];
    [self.contentVerticalStackView addArrangedSubview:self.reactMarginView];
    [self.reactMarginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
    [self.voiceBgView addSubview:self.redTipsView];
    [self.redTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@8);
        make.right.equalTo(@12);
        make.centerY.equalTo(self.voiceBgView.mas_centerY);
    }];
}
-(UIView *)voiceBgView{
    if (!_voiceBgView) {
        _voiceBgView = [[UIView alloc]init];
        _voiceBgView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
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
        _voicePlayImgView.image = UIImageMake(@"message_voice_receiver_normal");
        _voicePlayImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _voicePlayImgView;
}
-(UILabel *)voiceSecondsLab{
    if (!_voiceSecondsLab) {
        _voiceSecondsLab = [UILabel leftLabelWithTitle:nil font:14 color:UIColorMake(102, 102, 102)];
    }
    return _voiceSecondsLab;
}
-(UIView *)redTipsView{
    if (!_redTipsView) {
        _redTipsView = [[UIView alloc]init];
        [_redTipsView layerWithCornerRadius:4 borderWidth:0 borderColor:nil];
        _redTipsView.backgroundColor = UIColorMake(244, 81, 105);
    }
    return _redTipsView;
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

-(UIView *)reactMarginView{
    if (!_reactMarginView) {
        _reactMarginView = [[UIView alloc]init];
    }
    return _reactMarginView;
}

@end

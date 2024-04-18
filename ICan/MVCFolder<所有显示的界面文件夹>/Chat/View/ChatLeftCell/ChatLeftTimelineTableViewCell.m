//
//  ChatLeftTimelineTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftTimelineTableViewCell.h"
#import "ReactionBar.h"
@interface ChatLeftTimelineTableViewCell()
@property(nonatomic, strong) UIView *timelineBgView;

@property(nonatomic, strong) UIStackView *timelineVerticalStackView;
///昵称和头像
@property(nonatomic, strong) UIView *topContentView;
@property(nonatomic, strong) DZIconImageView *timelineIconImgView;
@property(nonatomic, strong) UILabel *nicknameLab;
///放置朋友圈的文本
@property(nonatomic, strong) UIView *timelineTextContentView;
@property(nonatomic, strong) UILabel *timelineTextLab;

@property(nonatomic, strong) UIView *timelineImgContentView;
@property(nonatomic, strong) UIImageView *timelineImgView;
@property(nonatomic, strong) UIImageView *timelinePlayImgView;

@property(nonatomic, strong) UIView *lineView1;

@property(nonatomic, strong) UIView *timelineTipsContentView;
@property(nonatomic, strong) UILabel *timelineTipsLab;
@property(nonatomic,strong)  UILabel *timeLabelDown;
@property(nonatomic, strong) UIView *reactionView;
@property(nonatomic, strong) ReactionBar *reactionBar;
@end
@implementation ChatLeftTimelineTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setTimelineMessageType];
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.timelineTipsContentView addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timelineTipsContentView.mas_right).offset(-5);
        make.top.equalTo(self.timelineTipsContentView.mas_top).offset(15);
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

-(void)setTimelineMessageType{
    ChatPostShareMessageInfo*goodsInfo = [ChatPostShareMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    [self.timelineIconImgView setImageWithString:goodsInfo.avatarUrl placeholder:BoyDefault];
    self.nicknameLab.text = goodsInfo.nickName;
    self.timelineTextLab.text = goodsInfo.content;
    if (goodsInfo.content.length>0) {
        self.timelineTextContentView.hidden = NO;
        if (goodsInfo.imageUrls.count>0) {
            self.timelineImgContentView.hidden=NO;
            [self.timelineImgView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.imageUrls.firstObject] placeholderImage:nil];
        }else{
            self.timelineImgContentView.hidden=YES;
        }
    }else{
        self.timelineImgContentView.hidden=NO;
        self.timelineTextContentView.hidden = YES;
        [self.timelineImgView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.imageUrls.firstObject] placeholderImage:nil];
    }
    self.timelinePlayImgView.hidden = goodsInfo.videoUrl?NO:YES;
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVerticalStackView addArrangedSubview:self.timelineBgView];
    [self.timelineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@170);
    }];
    [self.timelineBgView addSubview:self.timelineVerticalStackView];
    [self.timelineVerticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.timelineVerticalStackView addArrangedSubview:self.topContentView];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
    }];
    [self.topContentView addSubview:self.timelineIconImgView];
    [self.timelineIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@5);
        make.width.height.equalTo(@20);
    }];
    [self.topContentView addSubview:self.nicknameLab];
    [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timelineIconImgView.mas_right).offset(5);
        make.centerY.equalTo(self.topContentView.mas_centerY);
    }];
    [self.timelineVerticalStackView addArrangedSubview:self.timelineTextContentView];
    [self.timelineTextContentView addSubview:self.timelineTextLab];
    [self.timelineTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@5);
        make.right.bottom.equalTo(@-5);
       
    }];
    [self.timelineVerticalStackView addArrangedSubview:self.timelineImgContentView];
    [self.timelineImgContentView addSubview:self.timelineImgView];
    [self.timelineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@5);
        make.right.bottom.equalTo(@-5);
        make.width.equalTo(@160);
        make.height.equalTo(@100);
    }];
    [self.timelineImgContentView addSubview:self.timelinePlayImgView];
    [self.timelinePlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.centerX.equalTo(self.timelineImgContentView.mas_centerX);
        make.centerY.equalTo(self.timelineImgContentView.mas_centerY);
       
    }];
    [self.timelineVerticalStackView addArrangedSubview:self.lineView1];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
    }];
    
    [self.timelineVerticalStackView addArrangedSubview:self.timelineTipsContentView];
    [self.timelineTipsContentView addSubview:self.timelineTipsLab];
    [self.timelineTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.bottom.equalTo(@-10);
       
    }];
    //朋友圈
    self.timelineBgView.backgroundColor = UIColorChatLeftBgColor;
    UITapGestureRecognizer*timelineTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    [self.timelineBgView addGestureRecognizer:timelineTap];
    UILongPressGestureRecognizer*timelineLongPres=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.timelineBgView addGestureRecognizer:timelineLongPres];
    [self.timelineBgView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    [self.timelineImgView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    [self.timelineBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(self.contentVerticalStackView.mas_bottom).offset(17);
    }];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView = self.timelineBgView;
        [super longPress:longPressGes];
    }
}
-(UIView *)timelineBgView{
    if (!_timelineBgView) {//170
        _timelineBgView = [[UIView alloc]init];
        _timelineBgView.backgroundColor = UIColorBg243Color;
    }
    return _timelineBgView;
}
-(UIStackView *)timelineVerticalStackView{
    if (!_timelineVerticalStackView) {
        _timelineVerticalStackView = [[UIStackView alloc]init];
        _timelineVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _timelineVerticalStackView.alignment = UIStackViewAlignmentFill;
    }
    return _timelineVerticalStackView;
}
-(UIView *)topContentView{
    if (!_topContentView) {
        _topContentView = [[UIView alloc]init];
        _topContentView.backgroundColor = UIColor.clearColor;
    }
    return _topContentView;
}
-(DZIconImageView *)timelineIconImgView{
    if (!_timelineIconImgView) {
        _timelineIconImgView  = [[DZIconImageView alloc]init];
        _timelineIconImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_timelineIconImgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    }
    return _timelineIconImgView;
}
-(UILabel *)nicknameLab{
    if (!_nicknameLab) {
        _nicknameLab = [UILabel leftLabelWithTitle:nil font:14 color:UIColor252730Color];
    }
    return _nicknameLab;
}
-(UIView *)timelineTextContentView{
    if (!_timelineTextContentView) {
        _timelineTextContentView = [[UIView alloc]init];
        _timelineTextContentView.backgroundColor = UIColor.clearColor;
    }
    return _timelineTextContentView;
}
-(UILabel *)timelineTextLab{
    if (!_timelineTextLab) {
        _timelineTextLab = [UILabel leftLabelWithTitle:nil font:15 color:UIColor252730Color];
        _timelineTextLab.numberOfLines = 2;
    }
    return _timelineTextLab;
}
-(UIView *)timelineImgContentView{
    if (!_timelineImgContentView) {
        _timelineImgContentView = [[UIView alloc]init];
        _timelineImgContentView.backgroundColor = UIColor.clearColor;
    }
    return _timelineImgContentView;
}
-(UIImageView *)timelineImgView{
    if (!_timelineImgView) {
        _timelineImgView = [[UIImageView alloc]init];
        _timelineImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _timelineImgView;
}
-(UIImageView *)timelinePlayImgView{
    if (!_timelinePlayImgView) {
        _timelinePlayImgView = [[UIImageView alloc]initWithImage:UIImageMake(@"icon_video_play")];
        _timelinePlayImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _timelinePlayImgView;
}
-(UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = UIColorMake(209, 209,209);
    }
    return _lineView1;
}
-(UIView *)timelineTipsContentView{
    if (!_timelineTipsContentView) {
        _timelineTipsContentView = [[UIView alloc]init];
        _timelineTipsContentView.backgroundColor = UIColor.clearColor;
    }
    return _timelineTipsContentView;
}
-(UILabel *)timelineTipsLab{
    if (!_timelineTipsLab) {
        _timelineTipsLab = [UILabel leftLabelWithTitle:@"tabbar.discover".icanlocalized font:12 color:UIColor153Color];
    }
    return _timelineTipsLab;
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

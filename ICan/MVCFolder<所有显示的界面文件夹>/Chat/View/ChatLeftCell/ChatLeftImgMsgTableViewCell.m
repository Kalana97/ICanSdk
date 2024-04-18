//
//  ChatLeftImgMsgTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftImgMsgTableViewCell.h"
#import "FLAnimatedImageView.h"
#import "ReactionBar.h"
@interface ChatLeftImgMsgTableViewCell()
//显示图片
@property (strong, nonatomic)  UIView *imageBgView;
@property (strong, nonatomic)  FLAnimatedImageView *imageMessageView;
@property (strong, nonatomic) UILabel *timeDownLabel;
@property(nonatomic, strong) ReactionBar *reactionBar;
@property(nonatomic, strong) UIView *reactionView;
@end
@implementation ChatLeftImgMsgTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    ImageMessageInfo *info=[ImageMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    [self.imageMessageView setImageWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_%.f,w_%.f,limit_1",info.imageUrl,self.currentChatModel.layoutHeight,self.currentChatModel.layoutWidth] placeholder:nil];
    NSDate *date=[GetTime dateConvertFromTimeStamp:self.currentChatModel.messageTime];
    self.timeDownLabel.text = [GetTime getTime:date];
    if (self.currentChatModel.layoutWidth > 100 && self.currentChatModel.layoutHeight > 200) {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
        }];
    }else {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(200));
            make.width.equalTo(@(100));
        }];
    }
    
    
    if (self.currentChatModel.layoutWidth > 100 && self.currentChatModel.layoutHeight > 200) {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
        }];
    }else if(self.currentChatModel.layoutWidth > 100 && self.currentChatModel.layoutHeight < 200){
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(200));
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
        }];
    }else if(self.currentChatModel.layoutWidth < 100 && self.currentChatModel.layoutHeight > 200){
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
            make.width.equalTo(@(100));
        }];
    }else {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(200));
            make.width.equalTo(@(100));
        }];
    }
    [self.contentVerticalStackView addArrangedSubview:self.imageBgView];
    [self.imageBgView addSubview:self.imageMessageView];
    [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageBgView.mas_bottom).offset(-20);
        make.top.equalTo(self.imageBgView.mas_top).offset(5);
        make.left.equalTo(self.imageBgView.mas_left).offset(5);
        make.right.equalTo(self.imageBgView.mas_right).offset(-5);
    }];
    [self.imageBgView addSubview:self.timeDownLabel];
    [self.timeDownLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageBgView.mas_right).offset(-10);
        make.top.equalTo(self.imageMessageView.mas_bottom).offset(5);
    }];
    [self.imageBgView setBackgroundColor: UIColorMakeHEXCOLOR(0xF6F6F6)];
    self.imageMessageView.layer.cornerRadius = 10;
    self.imageBgView.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self.imageBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@25);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-25);
        }];
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)setUpUI{
    [super setUpUI];
    //给图片添加事件
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer*imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *imageLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageMessageView addGestureRecognizer:imageLongGesture];
    [self.imageMessageView addGestureRecognizer:imageTap];
    imageLongGesture.minimumPressDuration = 0.3;
    [self.imageMessageView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorSeparatorColor];
}

- (UIView *)imageBgView {
    if(!_imageBgView) {
        _imageBgView = [[UIView alloc]init];
    }
    return _imageBgView;
}

- (UILabel *)timeDownLabel {
    if(!_timeDownLabel) {
        _timeDownLabel = [[UILabel alloc]init];
        _timeDownLabel.font = [UIFont systemFontOfSize:12];
        _timeDownLabel.textColor = UIColorMakeHEXCOLOR(0x898A8D);
    }
    return _timeDownLabel;
}

- (FLAnimatedImageView *)imageMessageView{
    if (!_imageMessageView) {
        _imageMessageView = [[FLAnimatedImageView alloc]init];
        _imageMessageView.userInteractionEnabled = YES;
    }
    return _imageMessageView;
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView =  self.imageMessageView;
        [super longPress:longPressGes];
    }
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

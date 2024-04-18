//
//  ChatLeftVideoTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftVideoTableViewCell.h"
#import "DZUploadVideoProgressCircleView.h"
#import "ChatViewHandleTool.h"
#import "ReactionBar.h"
@interface ChatLeftVideoTableViewCell ()
@property(nonatomic, strong) UIView *videoBgView;
@property(nonatomic, strong) UIImageView *videoImgView;
@property(nonatomic, strong) UIImageView *videoPlayImgView;
@property(nonatomic, strong) UILabel *durationLab;
@property(nonatomic, strong) DZUploadVideoProgressCircleView *videoProgressView;
@property(nonatomic, strong) UIView *reactionView;
@property(nonatomic, strong) ReactionBar *reactionBar;
@property(nonatomic, strong) UIView *reactMarginView;
@end
@implementation ChatLeftVideoTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setVideoMessageType];
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

-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVerticalStackView addArrangedSubview:self.videoBgView];
    [self.videoBgView addSubview:self.videoImgView];
    [self.videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@200);
    }];
    [self.videoBgView addSubview:self.videoPlayImgView];
    [self.videoPlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@50);
        make.centerY.equalTo(self.videoBgView.mas_centerY);
        make.centerX.equalTo(self.videoBgView.mas_centerX);
    }];
    [self.videoBgView addSubview:self.durationLab];
    [self.durationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-2);
        make.bottom.equalTo(@-5);
    }];
    [self.videoBgView addSubview:self.videoProgressView];
    [self.videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@52);
        make.centerY.equalTo(self.videoBgView.mas_centerY);
        make.centerX.equalTo(self.videoBgView.mas_centerX);
    }];
    //视频
    UITapGestureRecognizer*videoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *videoLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.videoImgView addGestureRecognizer:videoLongGesture];
    [self.videoImgView addGestureRecognizer:videoTap];
    [self.videoImgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.videoBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@2);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@24);
    }];
    [self.contentVerticalStackView addArrangedSubview:self.reactMarginView];
    [self.reactMarginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
}
-(void)clickMessageCell{
    ChatViewHandleTool*tool=[ChatViewHandleTool shareManager];
    [tool chatViewHandleToolDownloadVideoWithChatModel:self.currentChatModel downloadProgress:^(ChatModel * _Nonnull) {
        [self updateVideoProgress];
    } success:^(ChatModel * _Nonnull) {
        [self updateVideoProgress];
    } failure:^(NSError * _Nonnull) {
        
    }];
}
-(void)setVideoMessageType{
    VideoMessageInfo*info=[VideoMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    [self.videoImgView sd_setImageWithURL: [NSURL URLWithString:info.content]];
    if (info.duration>60) {
        NSInteger shang=info.duration/60;
        NSInteger yu=info.duration%60;
        self.durationLab.text=[NSString stringWithFormat:@"%02ld:%02ld",(long)shang,yu];
    }else if (info.duration>3600){
        NSInteger fen=info.duration/60;
        NSInteger time=fen/60;
        NSInteger minutes=fen%60;
        NSInteger seconds=info.duration%3600;
        self.durationLab.text=[NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)time,minutes,seconds];
    }else{
        self.durationLab.text=[NSString stringWithFormat:@"00:%02ld",(long)info.duration];
    }
    if (self.currentChatModel.layoutHeight>10) {
        [self.videoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
        }];
    }else{
        [self.videoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.width.equalTo(@(KVideoWidth));
            make.height.equalTo(@(KVideoHeight));
        }];
       
    }
    [self updateVideoProgress];
}
-(void)updateVideoProgress{
    if (self.currentChatModel.downloadState==0) {
        self.videoProgressView.hidden = YES;
        self.videoPlayImgView.image=UIImageMake(@"icon_video_download");
        self.videoPlayImgView.hidden=NO;
    }else if(self.currentChatModel.downloadState==1){
        self.videoProgressView.hidden=YES;
        self.videoPlayImgView.image=UIImageMake(@"icon_video_play");
        self.videoPlayImgView.hidden=NO;
    }else if (self.currentChatModel.downloadState==2){
        self.videoProgressView.hidden=NO;
        self.videoPlayImgView.image=UIImageMake(@"icon_video_download");
        float progressLoad = 1.f * self.currentChatModel.completedUnitCount / self.currentChatModel.totalUnitCount;
        self.videoProgressView.progress=progressLoad;
        self.videoPlayImgView.hidden=YES;
    }else{
        self.videoProgressView.hidden=YES;
        self.videoPlayImgView.image=UIImageMake(@"icon_video_download");
        self.videoPlayImgView.hidden=NO;
    }
}
-(UIView *)videoBgView{
    if (!_videoBgView) {
        _videoBgView = [[UIView alloc]init];
        _videoBgView.backgroundColor = UIColor.clearColor;
    }
    return _videoBgView;
}
-(UIImageView *)videoImgView{
    if (!_videoImgView) {
        _videoImgView = [[UIImageView alloc]init];
        _videoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImgView.userInteractionEnabled = YES;
    }
    return _videoImgView;
}
-(UIImageView *)videoPlayImgView{
    if (!_videoPlayImgView) {
        _videoPlayImgView = [[UIImageView alloc]initWithImage:UIImageMake(@"icon_video_download")];
    }
    return _videoPlayImgView;
}
-(UILabel *)durationLab{
    if (!_durationLab) {
        _durationLab = [UILabel leftLabelWithTitle:nil font:12 color:UIColorWhite];
    }
    return _durationLab;
}
-(DZUploadVideoProgressCircleView *)videoProgressView{
    if (!_videoProgressView) {
        _videoProgressView = [[DZUploadVideoProgressCircleView alloc]init];
    }
    return _videoProgressView;
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

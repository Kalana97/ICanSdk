//
//  ChatLeftVideoTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightVideoTableViewCell.h"
#import "DZUploadVideoProgressCircleView.h"
#import "ChatViewHandleTool.h"
#import "DZExportVideoProgressCircleView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "ReactionBar.h"
@interface ChatRightVideoTableViewCell ()
@property(nonatomic, strong) UIView *videoBgView;
@property(nonatomic, strong) UIImageView *videoImgView;
@property(nonatomic, strong) UIImageView *videoPlayImgView;
@property(nonatomic, strong) UILabel *durationLab;
@property(nonatomic, strong) DZUploadVideoProgressCircleView *videoProgressView;
@property(nonatomic, strong) DZExportVideoProgressCircleView *exportProgressView;
@property(nonatomic, strong) UIView *reactionView;
@property(nonatomic, strong) ReactionBar *reactionBar;
@end
@implementation ChatRightVideoTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setVideoMessageType];
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

-(void)setVideoModel:(ChatModel *)videoModel{
    _videoModel = videoModel;
    self.currentChatModel = videoModel;
    [self setChatModel:videoModel isDownload:NO];
}

-(void)clickMessageCell{
    ChatViewHandleTool*tool=[ChatViewHandleTool shareManager];
    [tool chatViewHandleToolDownloadVideoWithChatModel:self.currentChatModel downloadProgress:^(ChatModel * _Nonnull) {
        [self updateDownLoadProgress];
    } success:^(ChatModel * _Nonnull) {
        [self updateDownLoadProgress];
    } failure:^(NSError * _Nonnull) {
        
    }];
}
-(void)updateDownLoadProgress{
    if (self.currentChatModel.downloadState==0) {
        self.videoProgressView.hidden=YES;
        self.videoPlayImgView.image = UIImageMake(@"icon_video_download");
        self.videoPlayImgView.hidden = NO;
    }else if(self.currentChatModel.downloadState==1){
        self.videoProgressView.hidden = YES;
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
-(void)setVideoMessageType{
    if (self.currentChatModel.mediaSeconds>60) {
        NSInteger shang=self.currentChatModel.mediaSeconds/60;
        NSInteger yu=self.currentChatModel.mediaSeconds%60;
        self.durationLab.text=[NSString stringWithFormat:@"%02ld:%02ld",shang,yu];
    }else if (self.currentChatModel.mediaSeconds>3600){
        NSInteger fen=self.currentChatModel.mediaSeconds/60;
        NSInteger time=fen/60;
        NSInteger minutes=fen%60;
        NSInteger seconds=self.currentChatModel.mediaSeconds%3600;
        self.durationLab.text=[NSString stringWithFormat:@"%02ld:%02ld:%02ld",time,minutes,seconds];
    }else{
        self.durationLab.text=[NSString stringWithFormat:@"00:%02ld",self.currentChatModel.mediaSeconds];
    }
    
    //获取本地资源缓存路径
    NSString *imgCachePath = [ MessageVideoCache(self.currentChatModel.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[self.currentChatModel.fileCacheName componentsSeparatedByString:@"."].firstObject]];
    NSData *imageData = [NSData dataWithContentsOfFile:imgCachePath];
    if (imageData.length ) {
        [self.videoImgView sd_setImageWithURL:nil placeholderImage:[UIImage sd_imageWithGIFData:imageData]];
    }else{
        VideoMessageInfo*videoInfo=[VideoMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
        [self.videoImgView setImageWithString:videoInfo.content placeholder:nil];
    }
    if (self.currentChatModel.layoutHeight>10) {
        [self.videoBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(@0);
            make.left.equalTo(@30);
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
        }];
    }else{
        [self.videoBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(@0);
            make.left.equalTo(@30);
            make.width.equalTo(@(KVideoWidth));
            make.height.equalTo(@(KVideoHeight));
        }];
       
    }
    [self setChatModel:self.currentChatModel isDownload:NO];
}
-(void)setChatModel:(ChatModel *)chatModel isDownload:(BOOL)isDownload{
    if (isDownload) {
        if (self.currentChatModel.downloadState == 0) {
            self.videoProgressView.hidden=YES;
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
    }else{
        [self updateProgress];
    }
}
-(void)updateProgress{
    if (self.currentChatModel.exportState==2) {
        self.videoProgressView.hidden = YES;
        self.exportProgressView.hidden=NO;
        self.exportProgressView.progress=self.currentChatModel.exportProgress;
    }else{
        self.exportProgressView.hidden=YES;
        //视频上传分为上传中的展示 和视频上传完成之后的消息的发送 要分开处理
        if (self.currentChatModel.uploadState==1) {
            self.videoProgressView.hidden=YES;
            self.videoPlayImgView.hidden=NO;
            if (self.currentChatModel.sendState==0) {
                [self.sendActivityView stopAnimating];
                self.failBtn.hidden = NO;
                self.failBtn.userInteractionEnabled = YES;
            }else if (self.currentChatModel.sendState==1){
                [self.sendActivityView stopAnimating];
                self.failBtn.hidden=YES;
                self.failBtn.userInteractionEnabled=YES;
            }else if (self.currentChatModel.sendState==2){
                self.failBtn.hidden = YES;
                self.failBtn.userInteractionEnabled = YES;
                [self.sendActivityView stopAnimating];
            }
        }else if (self.currentChatModel.uploadState==0){
            self.videoPlayImgView.hidden=NO;
            self.videoProgressView.hidden=YES;
            self.failBtn.hidden=NO;
            self.failBtn.userInteractionEnabled=YES;
            [self.sendActivityView stopAnimating];
        }else if (self.currentChatModel.uploadState==2){
            self.videoPlayImgView.hidden=YES;
            self.videoProgressView.hidden=NO;
            float progressLoad = 1.f * self.currentChatModel.completedUnitCount / self.currentChatModel.totalUnitCount;
            self.videoProgressView.progress=progressLoad;
            self.failBtn.hidden=YES;
            self.failBtn.userInteractionEnabled=NO;
            [self.sendActivityView stopAnimating];
        }
    }
    
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.bodyContentView addSubview:self.videoBgView];
    [self.videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(@0);
        make.left.equalTo(@30);
        make.width.equalTo(@(KVideoWidth));
        make.height.equalTo(@(KVideoHeight));
    }];
    [self.videoBgView addSubview:self.videoImgView];
    [self.videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        
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
    [self.videoBgView addSubview:self.exportProgressView];
    [self.exportProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.right.equalTo(@-5);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(22);
    }];
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
        _videoPlayImgView = [[UIImageView alloc]initWithImage:UIImageMake(@"icon_video_play")];
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
-(DZExportVideoProgressCircleView *)exportProgressView{
    if (!_exportProgressView) {
        _exportProgressView = [[DZExportVideoProgressCircleView alloc]init];
    }
    return _exportProgressView;
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

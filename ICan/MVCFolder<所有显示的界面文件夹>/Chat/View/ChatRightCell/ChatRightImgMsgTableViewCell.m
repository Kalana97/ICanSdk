//
//  ChatLeftImgMsgTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightImgMsgTableViewCell.h"
#import "FLAnimatedImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "ReactionBar.h"
@interface ChatRightImgMsgTableViewCell()
//显示图片
@property (strong, nonatomic)  UIView *imageBgView;
@property (strong, nonatomic)  FLAnimatedImageView *imageMessageView;
@property (strong, nonatomic)  UIView * upLoadImageMaskView;
// 加载指示图
@property (strong, nonatomic)  UIActivityIndicatorView *loadProgressView;
// 加载百分比
@property (strong, nonatomic)  UILabel *loadPercentLB;
@property (strong, nonatomic) UILabel *timeDownLabel;
@property(nonatomic, strong) ReactionBar *reactionBar;
@property(nonatomic, strong) UIView *reactionView;
@end
@implementation ChatRightImgMsgTableViewCell

-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setImageMessageType];
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

-(void)setImageMessageType{
    //获取本地资源缓存路径
    NSString *imgCachePath = [ MessageImageCache(self.currentChatModel.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",self.currentChatModel.fileCacheName]];
    NSData *imageData = [NSData dataWithContentsOfFile:imgCachePath];
    NSDate *date=[GetTime dateConvertFromTimeStamp:self.currentChatModel.messageTime];
    self.timeDownLabel.text = [GetTime getTime:date];
    if (imageData.length ) {
        [self.imageMessageView sd_setImageWithURL:nil placeholderImage:[UIImage sd_imageWithGIFData:imageData]];
    }else{
        ImageMessageInfo*imageInfo=[ImageMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
        [self.imageMessageView setImageWithString:imageInfo.imageUrl placeholder:nil];
    }
    if (self.currentChatModel.layoutWidth > 100 && self.currentChatModel.layoutHeight > 200) {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
            make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(-20);
            make.top.equalTo(self.bodyContentView.mas_top).offset(5);
            make.right.equalTo(self.bodyContentView.mas_right).offset(-5);
            make.left.equalTo(self.bodyContentView.mas_left).offset(5);
        }];
    }else if(self.currentChatModel.layoutWidth > 100 && self.currentChatModel.layoutHeight < 200){
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.currentChatModel.layoutWidth));
            make.height.equalTo(@(200));
            make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(-20);
            make.top.equalTo(self.bodyContentView.mas_top).offset(5);
            make.right.equalTo(self.bodyContentView.mas_right).offset(-5);
            make.left.equalTo(self.bodyContentView.mas_left).offset(5);
        }];
    }else if(self.currentChatModel.layoutWidth < 100 && self.currentChatModel.layoutHeight > 200){
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(100));
            make.height.equalTo(@(self.currentChatModel.layoutHeight));
            make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(-20);
            make.top.equalTo(self.bodyContentView.mas_top).offset(5);
            make.right.equalTo(self.bodyContentView.mas_right).offset(-5);
            make.left.equalTo(self.bodyContentView.mas_left).offset(5);
        }];
    }else {
        [self.imageMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(100));
            make.height.equalTo(@(200));
            make.bottom.equalTo(self.bodyContentView.mas_bottom).offset(-20);
            make.top.equalTo(self.bodyContentView.mas_top).offset(5);
            make.right.equalTo(self.bodyContentView.mas_right).offset(-5);
            make.left.equalTo(self.bodyContentView.mas_left).offset(5);
        }];
    }
    
    //set boder radious
    self.imageMessageView.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    [self updateImageViewProgress];
}

-(void)setImageModel:(ChatModel *)imageModel{
    _imageModel = imageModel;
    self.currentChatModel = imageModel;
    [self updateImageViewProgress];
}
-(void)updateImageViewProgress{
    //图片上传分为上传中的展示 和图片上传完成之后的消息的发送 要分开处理
    if (self.currentChatModel.uploadState==1) {
        self.upLoadImageMaskView.hidden=YES;
        self.loadPercentLB.hidden=YES;
        self.loadProgressView.hidden=YES;
        if (self.currentChatModel.sendState==0) {
            self.loadProgressView.hidden = YES;
            self.upLoadImageMaskView.hidden=YES;
            self.loadPercentLB.hidden=YES;
            [self.loadProgressView stopAnimating];
            [self.sendActivityView stopAnimating];
            self.failBtn.hidden=NO;
            self.failBtn.userInteractionEnabled=YES;
        }else if (self.currentChatModel.sendState==1){
            self.loadProgressView.hidden = YES;
            self.upLoadImageMaskView.hidden=YES;
            self.loadPercentLB.hidden=YES;
            [self.loadProgressView stopAnimating];
            [self.sendActivityView stopAnimating];
            self.failBtn.hidden=YES;
            self.failBtn.userInteractionEnabled=YES;
        }else if (self.currentChatModel.sendState==2){
            self.loadProgressView.hidden = YES;
            self.upLoadImageMaskView.hidden=YES;
            self.loadPercentLB.hidden=YES;
            [self.loadProgressView stopAnimating];
            [self.sendActivityView startAnimating];
            self.failBtn.hidden=YES;
            self.failBtn.userInteractionEnabled = YES;
        }
    }else if (self.currentChatModel.uploadState==0){
        self.loadProgressView.hidden = YES;
        self.upLoadImageMaskView.hidden=YES;
        self.loadPercentLB.hidden=YES;
        [self.loadProgressView stopAnimating];
        self.failBtn.hidden=NO;
        self.failBtn.userInteractionEnabled=YES;
        [self.sendActivityView stopAnimating];
    }else if (self.currentChatModel.uploadState==2){
        self.loadProgressView.hidden = NO;
        self.upLoadImageMaskView.hidden=NO;
        self.loadPercentLB.hidden=NO;
        [self.loadProgressView startAnimating];
        self.loadPercentLB.text=self.currentChatModel.uploadProgress;
        self.failBtn.hidden=YES;
        self.failBtn.userInteractionEnabled=NO;
        [self.sendActivityView stopAnimating];
    }
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.bodyContentView setBackgroundColor:UIColorMakeHEXCOLOR(0xDDEBFF)];
    self.bodyContentView.layer.cornerRadius = 10;
    [self.bodyContentView addSubview:self.imageMessageView];
    [self.imageMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@200);
        make.top.bottom.right.equalTo(@0);
        make.left.equalTo(@30);
    }];
    [self.bodyContentView addSubview:self.timeDownLabel];
    [self.timeDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bodyContentView.mas_right).offset(-10);
        make.top.equalTo(self.imageMessageView.mas_bottom).offset(5);
    }];
    [self.bodyContentView addSubview:self.upLoadImageMaskView];
    [self.upLoadImageMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(@0);
        make.left.equalTo(@0);
    }];
    [self.upLoadImageMaskView addSubview:self.loadProgressView];
    [self.loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerX.equalTo(self.upLoadImageMaskView.mas_centerX);
        make.centerY.equalTo(self.upLoadImageMaskView.mas_centerY).offset(10);
    }];
    [self.upLoadImageMaskView addSubview:self.loadPercentLB];
    [self.loadPercentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.upLoadImageMaskView.mas_centerX);
        make.top.equalTo(self.upLoadImageMaskView.mas_bottom).offset(5);
    }];
    //给图片添加事件
    UITapGestureRecognizer*imageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    UILongPressGestureRecognizer *imageLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageMessageView addGestureRecognizer:imageLongGesture];
    [self.imageMessageView addGestureRecognizer:imageTap];
    imageLongGesture.minimumPressDuration = 0.3;
    [self.imageMessageView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorSeparatorColor];
    [self.bodyContentView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@25);
    }];
}
- (FLAnimatedImageView *)imageMessageView{
    if (!_imageMessageView) {
        _imageMessageView = [[FLAnimatedImageView alloc]init];
        _imageMessageView.userInteractionEnabled = YES;
    }
    return _imageMessageView;
}

-(UIView *)upLoadImageMaskView{
    if (!_upLoadImageMaskView) {
        _upLoadImageMaskView = [[UIView alloc]init];
        _upLoadImageMaskView.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.1);
        _upLoadImageMaskView.layer.cornerRadius = 10;
    }
    return _upLoadImageMaskView;
}
-(UILabel *)loadPercentLB{
    if (!_loadPercentLB) {
        _loadPercentLB = [UILabel centerLabelWithTitle:nil font:14 color:UIColorWhite];
    }
    return _loadPercentLB;
}

- (UILabel *)timeDownLabel {
    if(!_timeDownLabel) {
        _timeDownLabel = [[UILabel alloc]init];
        _timeDownLabel.font = [UIFont systemFontOfSize:12];
        _timeDownLabel.textColor = UIColorMakeHEXCOLOR(0x898A8D);
    }
    return _timeDownLabel;
}

-(UIActivityIndicatorView *)loadProgressView{
    if (!_loadProgressView) {
        if (@available(iOS 13.0, *)) {
            _loadProgressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            _loadProgressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }
    }
    return _loadProgressView;
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

//
//  GKDYVideoControlView.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoControlView.h"
#import "GKLikeView.h"
#import "WCDBManager+UserMessageInfo.h"
#import "XMFaceManager.h"
#import "GKSlidePopupView.h"
#import "DYTimelineShowContentView.h"

#import "GKPlayerProgressSlider.h"
@interface GKDYVideoItemButton : UIButton

@end

@implementation GKDYVideoItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, 0, imgW, imgH);
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, height - titleH, titleW, titleH);
}

@end

@interface GKDYVideoControlView()

@property(nonatomic, strong) UIImageView           *iconView;
@property(nonatomic, strong) GKLikeView            *likeView;

@property(nonatomic, strong) UIButton *loveButton;
@property(nonatomic, strong) UILabel *loveCountLabel;
@property(nonatomic, strong) UIButton *commentBtn;
@property(nonatomic, strong) UILabel *  conmentCountLabel;

@property(nonatomic, strong) UIButton *shareBtn;
@property(nonatomic, strong) UILabel *shareCountLabel;

@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) UILabel * contentLabel;


@property(nonatomic, strong) UIButton *addButton;

@property(nonatomic, strong) UIImageView *blurImageView;

@property(nonatomic, strong) GKPlayerProgressSlider *gkSlider;

@property(nonatomic, strong) UIView *coverBgView;
@property(nonatomic, strong) UIView *timeBgView;
@property(nonatomic, strong) UILabel *totalTimeLab;
@property(nonatomic, strong) UILabel *currentTimeLab;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation GKDYVideoControlView
//转换时间成字符串
- (NSString *)convertTimeToString:(NSTimeInterval)time {
    if (time <= 0) {
        return @"00:00";
    }
    int minute = time / 60;
    int second = (int)time % 60;
    NSString * timeStr;
    if (minute >= 100) {
        timeStr = [NSString stringWithFormat:@"%d:%02d", minute, second];
    }else {
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    return timeStr;
}
-(void)dealloc{
    DDLogInfo(@"%s",__func__);
}
-(void)hiddenTimeBgView{
    self.timeBgView.hidden=YES;
    self.coverBgView.hidden=YES;
    self.iconView.hidden=self.nameLabel.hidden=self.contentLabel.hidden=self.shareBtn.hidden=self.shareCountLabel.hidden=self.commentBtn.hidden=self.conmentCountLabel.hidden=self.loveButton.hidden=self.loveCountLabel.hidden=NO;
    
    if ([self.timeLineInfo.visibleRange isEqualToString:@"Open"]) {
        self.shareBtn.hidden=self.shareCountLabel.hidden=NO;
    }else{
        self.shareBtn.hidden=self.shareCountLabel.hidden=YES;
    }
}
-(void)showCurrentTimeLabelWithTotalTime:(float)totalTime currentTime:(float)currentTime{
    self.timeBgView.hidden=NO;
    self.coverBgView.hidden=NO;
    self.iconView.hidden=self.nameLabel.hidden=self.contentLabel.hidden=self.shareBtn.hidden=self.shareCountLabel.hidden=self.commentBtn.hidden=self.conmentCountLabel.hidden=self.loveButton.hidden=self.loveCountLabel.hidden=YES;
    self.currentTimeLab.text=[self convertTimeToString:currentTime];
    self.totalTimeLab.text=[self convertTimeToString:totalTime];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUpTimeLabel];
        [self addSubview:self.blurImageView];
        [self addSubview:self.timelineBrowseView];
        
        [self addSubview:self.coverImgView];
        [self addSubview:self.coverBgView];
        
        [self addSubview:self.timeBgView];
        [self addSubview:self.iconView];
        [self addSubview:self.addButton];
        // [self addSubview:self.likeView];
        [self addSubview:self.loveButton];
        [self addSubview:self.loveCountLabel];
        [self addSubview:self.commentBtn];
        [self addSubview:self.conmentCountLabel];
        [self addSubview:self.shareBtn];
        [self addSubview:self.shareCountLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.sliderView];
        
        [self addSubview:self.playBtn];
        
        
        [self.timelineBrowseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.blurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.coverBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        CGFloat bottomM =isIPhoneX?57: 20;
        [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(-(bottomM+70)));
        }];
        [self addSubview:self.gkSlider];
        [self.gkSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(@0);
            make.bottom.equalTo(@(-bottomM));
            make.height.equalTo(@20);
        }];
        
        [self.shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(@(-( bottomM+20)));
        }];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20.0f);
            make.bottom.equalTo(self.shareCountLabel.mas_top).offset(-8);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 35.0f);
        }];
        
        [self.conmentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-20.0f);
        }];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.conmentCountLabel.mas_top).offset(-8);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 35.0f);
        }];
        [self.loveCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-20.0f);
        }];
        [self.loveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.loveCountLabel.mas_top).offset(-8);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 35.0f);
        }];
        //        [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.equalTo(self.shareBtn);
        //            make.bottom.equalTo(self.commentBtn.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
        //            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        //        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.loveButton.mas_top).offset(-33.0f);
            make.width.height.equalTo(@(55.0f*ADAPTATIONRATIO));
        }];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(55/2*ADAPTATIONRATIO));
            make.bottom.equalTo(self.iconView.mas_bottom).offset(55/4*ADAPTATIONRATIO);
            make.centerX.equalTo(self.iconView.mas_centerX);
        }];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10.0f);
            make.bottom.equalTo(self).offset(-( bottomM+20));
            make.right.equalTo(self.shareCountLabel.mas_left).offset(-20);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.bottom.equalTo(self.contentLabel.mas_top).offset(- 15.0f);
        }];
    }
    return self;
}
-(void)setUpTimeLabel{
    [self.timeBgView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeBgView.mas_centerX);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(@25);
    }];
    [self.timeBgView addSubview:self.totalTimeLab];
    [self.totalTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
    [self.timeBgView addSubview:self.currentTimeLab];
    [self.currentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView.mas_left).offset(-10);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
}
-(UIImage*)getBlurImage:(UIImage*)image{
    /*..CoreImage中的模糊效果滤镜..*/
    //CIImage,相当于UIImage,作用为获取图片资源
    CIImage * ciImage = [[CIImage alloc]initWithImage:image ];
    //CIFilter,高斯模糊滤镜
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //将图片输入到滤镜中
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    //用来查询滤镜可以设置的参数以及一些相关的信息
    NSLog(@"%@",[blurFilter attributes]);
    //设置模糊程度,默认为10,取值范围(0-100)
    [blurFilter setValue:@(20) forKey:@"inputRadius"];
    //将处理好的图片输出
    CIImage * outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    //CIContext
    CIContext * context = [CIContext contextWithOptions:nil];
    //获取CGImage句柄,也就是从数据流中取出图片
    CGImageRef outCGImage = [context createCGImage:outCiImage fromRect:[outCiImage extent]];
    //最终获取到图片
    UIImage * blurImage = [UIImage imageWithCGImage:outCGImage];
    //释放CGImage句柄
    CGImageRelease(outCGImage);
    return blurImage;
}
-(void)setTimeLineInfo:(TimelinesListDetailInfo *)timeLineInfo{

    _timeLineInfo=timeLineInfo;
    if (timeLineInfo.imageUrls.count==0) {
        self.gkSlider.hidden=YES;
        self.coverImgView.hidden=YES;
        self.timelineBrowseView.hidden=YES;
        self.blurImageView.hidden=YES;
        self.timeBgView.hidden=YES;
    }else if (timeLineInfo.imageUrls.count==1){
        if (timeLineInfo.videoUrl.length>0) {
            self.gkSlider.hidden=NO;
            self.coverImgView.hidden=NO;
            self.blurImageView.hidden=YES;
            self.timelineBrowseView.hidden=YES;
            [self.blurImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_200/blur,r_3,s_2",timeLineInfo.imageUrls.firstObject]]];
        }else{
            self.gkSlider.hidden=YES;
            self.blurImageView.hidden=NO;
            self.coverImgView.hidden=YES;
            self.timelineBrowseView.hidden=NO;
            [self.blurImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_200/blur,r_3,s_2",timeLineInfo.imageUrls.firstObject]]];
        }
    }else{
        self.timeBgView.hidden=YES;
        self.gkSlider.hidden=YES;
        self.blurImageView.hidden=NO;
        self.coverImgView.hidden=YES;
        self.timelineBrowseView.hidden=NO;
        [self.blurImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_200/blur,r_3,s_2",timeLineInfo.imageUrls.firstObject]]];
    }
    
    if ([timeLineInfo.visibleRange isEqualToString:@"Open"]) {
        self.shareBtn.hidden=self.shareCountLabel.hidden=NO;
    }else{
        self.shareBtn.hidden=self.shareCountLabel.hidden=YES;
    }
    self.timelineBrowseView.timeLineInfo=timeLineInfo;
    self.sliderView.value = 0;
    [self.coverImgView setImageWithString:timeLineInfo.imageUrls.firstObject placeholder:nil];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:timeLineInfo.headImgUrl] placeholderImage:[timeLineInfo.gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
    self.nameLabel.text=[NSString stringWithFormat:@"@%@",timeLineInfo.nickName];
    NSMutableAttributedString *textAttributedString = [XMFaceManager emotionStrWithString:timeLineInfo.content];
    [textAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f*ADAPTATIONRATIO] range:NSMakeRange(0, textAttributedString.length)];
    [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, textAttributedString.length)];
    self.contentLabel.attributedText=textAttributedString ;
    
    NSMutableAttributedString *commentNumattributedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",timeLineInfo.commentNum]];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 1.0;
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowColor = [UIColor blackColor];
    [commentNumattributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, commentNumattributedString.length)];
    self.conmentCountLabel.attributedText=commentNumattributedString;
    
    NSMutableAttributedString *loveNumattributedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",timeLineInfo.loveNum]];
    NSShadow *loveshadow = [[NSShadow alloc]init];
    loveshadow.shadowBlurRadius = 1.0;
    loveshadow.shadowOffset = CGSizeMake(1, 1);
    loveshadow.shadowColor = [UIColor blackColor];
    [loveNumattributedString addAttribute:NSShadowAttributeName value:loveshadow range:NSMakeRange(0, loveNumattributedString.length)];
    self.loveCountLabel.attributedText=loveNumattributedString;
    
    NSMutableAttributedString *forwardNumattributedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd",timeLineInfo.forwardNum]];
    NSShadow *forwardNumshadow = [[NSShadow alloc]init];
    forwardNumshadow.shadowBlurRadius = 1.0;
    forwardNumshadow.shadowOffset = CGSizeMake(1, 1);
    forwardNumshadow.shadowColor = [UIColor blackColor];
    [forwardNumattributedString addAttribute:NSShadowAttributeName value:forwardNumshadow range:NSMakeRange(0, forwardNumattributedString.length)];
    self.shareCountLabel.attributedText=forwardNumattributedString;
    
    self.loveButton.selected=timeLineInfo.love;
    self.commentBtn.selected=timeLineInfo.comment;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:timeLineInfo.belongsId successBlock:^(UserMessageInfo * _Nonnull info) {
        if ([timeLineInfo.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
            self.addButton.hidden=YES;
        }else if (info.isFriend){
            self.addButton.hidden=YES;
        }else{
            self.addButton.hidden=NO;
        }
    }];
    
}

#pragma mark - Public Methods
- (void)setProgress:(float)progress {
    if (!self.gkSlider.isSliding) {
        if ( [self.gkSlider isDescendantOfView:self]) {
            self.gkSlider.sliderPercent=progress;
        }
    }
    
}

- (void)startLoading {
    //    [self.sliderView showLineLoading];
}

- (void)stopLoading {
    //    [self.sliderView hideLineLoading];
}

- (void)showPlayBtn {
    if (self.timeLineInfo.videoUrl.length>0) {
        self.playBtn.hidden = NO;
    }else{
        self.playBtn.hidden = YES;
    }
    
}

- (void)hidePlayBtn {
    
    self.playBtn.hidden = YES;
}

- (void)showLikeAnimation {
    [self.likeView startAnimationWithIsLike:YES];
}

- (void)showUnLikeAnimation {
    [self.likeView startAnimationWithIsLike:NO];
}

#pragma mark - Action
- (void)controlViewDidClick {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)iconDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickIcon:)]) {
        [self.delegate controlViewDidClickIcon:self];
    }
}
- (void)nameDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickNameLabel:)]) {
        [self.delegate controlViewDidClickNameLabel:self];
    }
}

- (void)praiseBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPriase:)]) {
        [self.delegate controlViewDidClickPriase:self];
    }
}

- (void)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickComment:)]) {
        [self.delegate controlViewDidClickComment:self];
    }
}

- (void)shareBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickShare:)]) {
        [self.delegate controlViewDidClickShare:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSTimeInterval delayTime = 0.3f;
    
    if (touch.tapCount <= 1) {
        [self performSelector:@selector(controlViewDidClick) withObject:nil afterDelay:delayTime];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlViewDidClick) object:nil];
        
        if ([self.delegate respondsToSelector:@selector(controlView:touchesBegan:withEvent:)]) {
            [self.delegate controlView:self touchesBegan:touches withEvent:event];
        }
    }
}

#pragma mark - 懒加载
-(GKPlayerProgressSlider *)gkSlider{
    if (!_gkSlider) {
        _gkSlider=[[NSBundle mainBundle]loadNibNamed:@"GKPlayerProgressSlider" owner:self options:nil].firstObject;
        @weakify(self);
        _gkSlider.valueEndBlock = ^(double value) {
            @strongify(self);
            if (self.delegate&&[self.delegate respondsToSelector:@selector(controlViewDidPanSelf:value:)]) {
                [self.delegate controlViewDidPanSelf:self value:value];
            }
            
        };
        _gkSlider.valueChangeBlock = ^(double value) {
            @strongify(self);
            if (self.delegate&&[self.delegate respondsToSelector:@selector(controlViewDidChangePanSelf:value:)]) {
                [self.delegate controlViewDidChangePanSelf:self value:value];
            }
        };
    }
    return _gkSlider;
}
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImgView.clipsToBounds = YES;
        _coverImgView.backgroundColor=UIColor.clearColor;
    }
    return _coverImgView;
}
- (UIImageView *)blurImageView {
    if (!_blurImageView) {
        _blurImageView = [UIImageView new];
        _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurImageView.clipsToBounds = YES;
    }
    return _blurImageView;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.userInteractionEnabled = YES;
        [_iconView layerWithCornerRadius:ADAPTATIONRATIO * 55.0f/2 borderWidth:1 borderColor:UIColor.whiteColor];
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_iconView addGestureRecognizer:iconTap];
    }
    return _iconView;
}
-(UIButton *)addButton{
    if (!_addButton) {
        _addButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(iconDidClick:)];
        [_addButton setBackgroundImage:UIImageMake(@"icon_dyviewcon_add") forState:UIControlStateNormal];
    }
    return _addButton;
}
- (GKLikeView *)likeView {
    if (!_likeView) {
        _likeView = [GKLikeView new];
    }
    return _likeView;
}
- (UIButton *)loveButton {
    if (!_loveButton) {
        _loveButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(praiseBtnClick:)];
        [_loveButton setBackgroundImage:UIImageMake(@"icon_timeline_praise_sel") forState:UIControlStateSelected];
        [_loveButton setBackgroundImage:UIImageMake(@"icon_timeline_praise_unsel") forState:UIControlStateNormal];
    }
    return _loveButton;
}
-(UILabel *)loveCountLabel{
    if (!_loveCountLabel) {
        _loveCountLabel=[UILabel centerLabelWithTitle:nil font:14*ADAPTATIONRATIO color:UIColor.whiteColor];
    }
    return _loveCountLabel;
}
- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(commentBtnClick:)];
        [_commentBtn setBackgroundImage:UIImageMake(@"icon_timeline_comment_unsel") forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:UIImageMake(@"icon_timeline_comment_sel") forState:UIControlStateSelected];
    }
    return _commentBtn;
}
-(UILabel *)conmentCountLabel{
    if (!_conmentCountLabel) {
        _conmentCountLabel=[UILabel centerLabelWithTitle:nil font:14*ADAPTATIONRATIO color:UIColor.whiteColor];
    }
    return _conmentCountLabel;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(shareBtnClick:)];
        [_shareBtn setBackgroundImage:UIImageMake(@"icon_gkvideo_share") forState:UIControlStateNormal];
    }
    return _shareBtn;
}
-(UILabel *)shareCountLabel{
    if (!_shareCountLabel) {
        _shareCountLabel=[UILabel centerLabelWithTitle:nil font:14*ADAPTATIONRATIO color:UIColor.whiteColor];
    }
    return _shareCountLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f*ADAPTATIONRATIO];
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameDidClick:)];
        [_nameLabel addGestureRecognizer:nameTap];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 3;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.userInteractionEnabled=YES;
        _contentLabel.font = [UIFont systemFontOfSize:16.0f*ADAPTATIONRATIO];
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap:)];
        [_contentLabel addGestureRecognizer:nameTap];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}
-(void)contentTap:(id)sender{
    DYTimelineShowContentView *commentView = [DYTimelineShowContentView new];
    commentView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, ADAPTATIONRATIO * 440.0f);
    commentView.timelinesListDetailInfo=self.timeLineInfo;
    GKSlidePopupView *popupView = [GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:commentView];
    [popupView showFrom:[UIApplication sharedApplication].keyWindow completion:^{
        
    }];
    
}

- (GKSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [GKSliderView new];
        _sliderView.isHideSliderBlock = NO;
        _sliderView.sliderHeight = ADAPTATIONRATIO * 1.0f;
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.hidden=NO;
    }
    return _sliderView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
        _playBtn.hidden = YES;
        [_playBtn addTarget:self action:@selector(controlViewDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(TimelineBrowseImageView *)timelineBrowseView{
    if (!_timelineBrowseView) {
        _timelineBrowseView=[[TimelineBrowseImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
    }
    return _timelineBrowseView;
}
-(UIView *)coverBgView{
    if (!_coverBgView) {
        _coverBgView=[[UIView alloc]init];
        _coverBgView.hidden=YES;
        _coverBgView.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.3);
    }
    return _coverBgView;
}
-(UIView *)timeBgView{
    if (!_timeBgView) {
        _timeBgView=[[UIView alloc]init];
        _timeBgView.hidden=YES;
    }
    return _timeBgView;
}
-(UILabel *)totalTimeLab{
    if (!_totalTimeLab) {
        _totalTimeLab=[UILabel leftLabelWithTitle:nil font:25 color:UIColor153Color];
    }
    return _totalTimeLab;
}
-(UILabel *)currentTimeLab{
    if (!_currentTimeLab) {
        _currentTimeLab=[UILabel leftLabelWithTitle:nil font:30 color:UIColor.whiteColor];
        _currentTimeLab.font=[UIFont boldSystemFontOfSize:25];
    }
    return _currentTimeLab;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColor.grayColor;
    }
    return _lineView;
}

@end

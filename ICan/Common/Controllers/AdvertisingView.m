//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 29/6/2020
 - File name:  AdvertisingView.m
 - Description:
 - Function List:
 */


#import "AdvertisingView.h"
@interface AdvertisingView ()
@property(nonatomic, strong) UIImageView *adverImageView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) dispatch_source_t timer;
@end
@implementation AdvertisingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.whiteColor;
        [self addSubview:self.adverImageView];
        [self.adverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self addSubview:self.closeButton];
        if (isIPhoneX) {
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@54);
                make.right.equalTo(@-20);
                make.height.equalTo(@30);
                make.width.equalTo(@70);
            }];
        }else{
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@34);
                make.right.equalTo(@-20);
                make.height.equalTo(@30);
                make.width.equalTo(@70);
            }];
        }
        
        
    }
    return self;
}
-(void)setStartInfo:(GetPublicStartInfo *)startInfo{
    _startInfo=startInfo;
    __block NSInteger time = startInfo.closeTime; //倒计时时间
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            time=time-1;
            if (time<=0) {
                dispatch_source_cancel(self.timer);
            }
            [self.closeButton setTitle:[NSString stringWithFormat:@"跳过 %ld",time] forState:UIControlStateNormal];
        });
        
    });
    dispatch_resume(self.timer);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startInfo.closeTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    [self.adverImageView sd_setImageWithURL:[NSURL URLWithString:startInfo.imgUrl]];
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton=[UIButton dzButtonWithTitle:@"跳过" image:nil backgroundColor:UIColorMakeWithRGBA(0, 0, 0, 0.5) titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(closeButtonAction)];
        [_closeButton layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    }
    return _closeButton;
}
-(void)closeButtonAction{
    [self removeFromSuperview];
    
}
-(UIImageView *)adverImageView{
    if (!_adverImageView) {
        _adverImageView=[[UIImageView alloc]init];
        _adverImageView.contentMode=UIViewContentModeScaleAspectFill;
        _adverImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_adverImageView addGestureRecognizer:tap];
    }
    return _adverImageView;
}
-(void)tapAction{
    /**URLURL,
     商品id ProductId,
     分类id
     CategoryId,
     分组id
     ProdTagId
     */
    [self removeFromSuperview];
    if ([self.startInfo.jumpType isEqualToString:@"URL"]) {
        NSURL*url= [NSURL URLWithString:self.startInfo.linkUrl];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        }
    }
}
@end

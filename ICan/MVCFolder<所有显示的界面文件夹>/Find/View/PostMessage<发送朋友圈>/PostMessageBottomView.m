//
//  PostMessageBottomView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "PostMessageBottomView.h"
#import "EmojyShowView.h"
@interface PostMessageBottomView()

@property(nonatomic,strong)UIView * locationView;
@property(nonatomic,strong)UIView * friendView;
@property(nonatomic,strong)UIView * faceView;
@property(nonatomic,strong)UIView * photoView;
@property(nonatomic,strong)UILabel * tipLabel;
@property(nonatomic,strong)UIView * cameraView;
/** 安全区域的高度为了区分是否是iPhonex的机型 */
@property (nonatomic, assign) CGFloat starBarBottomHeight;

@end

@implementation PostMessageBottomView
-(instancetype)initWithFrame:(CGRect)frame isInputView:(BOOL)isInputView{
    if (self=[super initWithFrame:frame]) {
        self.isInputView=isInputView;
        [self setUpView];
        self.userInteractionEnabled =YES;
    }
    
    return self;
}
-(void)setUpView{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.locationView];
    [self addSubview:self.friendView];
    [self addSubview:self.faceView];
    [self addSubview:self.photoView];
    [self addSubview:self.cameraView];
    if (self.isInputView) {
        [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@23.5);
            make.height.equalTo(@21);
            make.left.equalTo(@10);
        }];
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.cameraView.mas_right).offset(22);
            
        }];
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.photoView.mas_right).offset(22);
            
        }];
        [self.friendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.faceView.mas_right).offset(22);
        }];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.friendView.mas_right).offset(22);
        }];
        
    }else{
        [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@14);
            make.width.equalTo(@23.5);
            make.height.equalTo(@21);
            make.left.equalTo(@10);
        }];
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cameraView.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.cameraView.mas_right).offset(22);
            
        }];
        [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cameraView.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.photoView.mas_right).offset(22);
            
        }];
        [self.friendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cameraView.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.faceView.mas_right).offset(22);
        }];
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cameraView.mas_centerY);
            make.width.height.equalTo(@22);
            make.left.equalTo(self.friendView.mas_right).offset(22);
        }];
    }
    
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger index=tap.view.tag;
    switch (index) {
        case 300:
            !self.tapBlock?:self.tapBlock(PostMessageFunctionType_photograph);
            break;
        case 301:
            !self.tapBlock?:self.tapBlock(PostMessageFunctionType_image);
            break;
        case 302:
            !self.tapBlock?:self.tapBlock(PostMessageFunctionType_face);
            break;
        case 303:
            !self.tapBlock?:self.tapBlock(PostMessageFunctionType_atUser);
            break;
        case 304:
            !self.tapBlock?:self.tapBlock(PostMessageFunctionType_location);
            break;
        default:
            break;
    }
    
}
-(UIView *)locationView{
    if (!_locationView) {
        _locationView = [UIView new];
        _locationView.userInteractionEnabled =YES;
        _locationView.layer.contents = (id)[UIImage imageNamed:@"icon_timeline_post_location"].CGImage;
        _locationView.tag = 304;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_locationView addGestureRecognizer:tap];
        
    }
    
    return _locationView;
}
-(UIView *)friendView{
    if (!_friendView) {
        _friendView = [UIView new];
        _friendView.tag = 303;
        _friendView.layer.contents = (id)[UIImage imageNamed:@"icon_timeline_at"].CGImage;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_friendView addGestureRecognizer:tap];
    }
    
    return _friendView;
}

-(UIView *)faceView{
    if (!_faceView) {
        _faceView = [UIView new];
        _faceView.tag = 302;
        _faceView.layer.contents = (id)[UIImage imageNamed:@"icon_timeline_expression"].CGImage;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_faceView addGestureRecognizer:tap];
        
    }
    
    return _faceView;
}

-(UIView *)photoView{
    if (!_photoView) {
        _photoView = [UIView new];
        _photoView.tag = 301;
        _photoView.layer.contents = (id)[UIImage imageNamed:@"icon_timeline_select_picture"].CGImage;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_photoView addGestureRecognizer:tap];
    }
    return _photoView;
}


-(UIView *)cameraView{
    if (!_cameraView) {
        _cameraView = [UIView new];
        _cameraView.tag = 300;
        _cameraView.layer.contents = (id)[UIImage imageNamed:@"icon_timeline_camera"].CGImage;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_cameraView addGestureRecognizer:tap];
    }
    return _cameraView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel leftLabelWithTitle:@"AddMoreElements".icanlocalized font:14 color:UIColor252730Color];
    }
    
    return _tipLabel;
}

@end

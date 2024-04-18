//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 25/8/2020
 - File name:  ChatViewConnectTipsView.m
 - Description:
 - Function List:
 */


#import "ChatViewConnectTipsView.h"
@interface ChatViewConnectTipsView()
@property(nonatomic, strong) UIView *netWorkBgView;
@property(nonatomic, strong) UIImageView *tipsImageView;
@property(nonatomic, strong) UILabel *tipsLabel;
//显示登录状态
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end
@implementation ChatViewConnectTipsView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.netWorkBgView];
        [self.netWorkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.left.right.bottom.equalTo(@0);
        }];
        [self.netWorkBgView addSubview:self.activityView];
        [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(self.netWorkBgView.mas_centerY);
        }];
        [self.netWorkBgView addSubview:self.tipsImageView];
        [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.width.height.equalTo(@15);
            make.centerY.equalTo(self.netWorkBgView.mas_centerY);
        }];
        [self.netWorkBgView addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipsImageView.mas_right).offset(10);
            make.centerY.equalTo(self.netWorkBgView.mas_centerY);
        }];
    }
    return self;
}
-(void)setStatus:(SocketConnectStatus)status{
    _status=status;
    
    switch (_status) {
        case SocketConnectStatus_NoNet:{
            [self noNet];
            self.hidden=NO;
        }
            break;
        case SocketConnectStatus_Connecting:{
            [self loginStart];
            self.hidden=NO;
        }
            break;
        case SocketConnectStatus_Connected:{
            [self loginSuccess];
            self.hidden=YES;
        }
            break;
        case SocketConnectStatus_UnConnected:{
            [self loginFailed];
            self.hidden=NO;
        }
            break;
        default:
            break;
    }
}
-(void)loginSuccess{
    [self.activityView removeFromSuperview];
    [self.tipsLabel removeFromSuperview];
    [self.tipsImageView removeFromSuperview];
    [self.activityView stopAnimating];
}
-(void)loginFailed{
    [self.activityView removeFromSuperview];
    [self.tipsLabel removeFromSuperview];
    [self.tipsImageView removeFromSuperview];
    [self.activityView stopAnimating];
    self.tipsImageView.image=UIImageMake(@"icon_network_break");
    self.netWorkBgView.backgroundColor=UIColorMakeWithRGBA(253, 237, 239, 0.5);
    self.tipsLabel.text=@"Not connected".icanlocalized;
    [self.netWorkBgView addSubview:self.tipsImageView];
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.netWorkBgView.mas_centerY);
    }];
    [self.netWorkBgView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsImageView.mas_right).offset(10);
        make.centerY.equalTo(self.netWorkBgView.mas_centerY);
    }];
}
-(void)loginStart{
    [self.activityView removeFromSuperview];
    [self.tipsLabel removeFromSuperview];
    [self.tipsImageView removeFromSuperview];
    [self.activityView stopAnimating];
    self.tipsLabel.text=@"Connecting".icanlocalized;
    [self.netWorkBgView addSubview:self.activityView];
    [self.netWorkBgView addSubview:self.tipsLabel];
    [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@20);
    }];
    self.netWorkBgView.backgroundColor=UIColor.whiteColor;
    [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.activityView.mas_right).offset(5);
    }];
    
    [self.activityView startAnimating];
}
-(void)noNet{
    [self.activityView removeFromSuperview];
    [self.tipsLabel removeFromSuperview];
    [self.tipsImageView removeFromSuperview];
    [self.activityView stopAnimating];
    self.netWorkBgView.backgroundColor = UIColorMakeWithRGBA(253, 237, 239, 0.9);
    self.tipsLabel.text=@"Disconnected".icanlocalized;
    self.tipsImageView.image=UIImageMake(@"icon_network_break");
    [self.netWorkBgView addSubview:self.tipsImageView];
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.netWorkBgView.mas_centerY);
    }];
    [self.netWorkBgView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsImageView.mas_right).offset(10);
        make.centerY.equalTo(self.netWorkBgView.mas_centerY);
    }];
}
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView  alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleGray)];
        _activityView.hidden=NO;
    }
    return _activityView;
}
-(UIView *)netWorkBgView{
    if (!_netWorkBgView) {
        _netWorkBgView=[[UIView alloc]init];
        _netWorkBgView.hidden=NO;
    }
    return _netWorkBgView;
}
-(UIImageView *)tipsImageView{
    if (!_tipsImageView) {
        _tipsImageView=[[UIImageView alloc]init];
    }
    return _tipsImageView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel leftLabelWithTitle:nil font:12 color:UIColor153Color];
    }
    return _tipsLabel;
}


@end

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 13/4/2020
- File name:  NewFriendRecommendListTableViewCell.m
- Description:
- Function List:
*/
        

#import "NewFriendRecommendListTableViewCell.h"
@interface NewFriendRecommendListTableViewCell()
@property (nonatomic,strong)  DZIconImageView *headerImageView;
@property (nonatomic,strong)  UILabel *nameLab;
@property (nonatomic,strong)  UILabel *friendInfoLab;
@property (nonatomic,strong)  UIButton *refuseBtn;
@property (nonatomic,strong)  UIButton *agreeBtn;
@property(nonatomic, strong) UIImageView *genderImgView;
@end
@implementation NewFriendRecommendListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)setUserRecommendListInfo:(UserRecommendListInfo *)userRecommendListInfo{
    _userRecommendListInfo=userRecommendListInfo;
    [self.headerImageView setDZIconImageViewWithUrl:userRecommendListInfo.headImgUrl gender:userRecommendListInfo.gender];
    self.friendInfoLab.text=userRecommendListInfo.signature;
    self.nameLab.text=userRecommendListInfo.nickname;
    if (userRecommendListInfo.gender) {
        
        self.genderImgView.hidden=NO;
        self.genderImgView.image=[userRecommendListInfo.gender isEqualToString:@"2"]?UIImageMake(GirlDefault):UIImageMake(BoyDefault);
    }else{
        self.genderImgView.hidden=YES;
    }
    
}
-(void)setUpUI {
    [super setUpUI];
    self.backgroundColor = UIColorViewBgColor;
    self.contentView.backgroundColor = UIColorViewBgColor;
    [self addSubview:self.headerImageView];
    [self addSubview:self.friendInfoLab];
    [self addSubview:self.nameLab];
    [self addSubview:self.refuseBtn];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.genderImgView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@15);
        make.width.height.equalTo(@60);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
        make.top.equalTo(@15);
        make.height.equalTo(@15);
//        make.right.mas_greaterThanOrEqualTo(@-20);
    }];
    [self.genderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.height.equalTo(@16);
        make.width.equalTo(@11);
        make.centerY.equalTo(self.nameLab.mas_centerY);
    }];
    [self.friendInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@15);
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
    }];
    //110
    
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        
        make.width.equalTo(@((ScreenWidth-110)/2.0-30));
        make.bottom.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.refuseBtn.mas_left).offset(-10);
        
        make.width.equalTo(@((ScreenWidth-110)/2.0+30));
        make.bottom.equalTo(@-10);
        make.height.equalTo(@30);
        
    }];
}

-(void)agreeBtnClick {
    if (self.agreeSucessBlock) {
        self.agreeSucessBlock();
    }
}


-(DZIconImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView=[[DZIconImageView alloc]init];
        [_headerImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    }
    return _headerImageView;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab=[UILabel leftLabelWithTitle:@"" font:16 color:UIColorThemeMainTitleColor];
        
    }
    return _nameLab;
}
-(UIButton *)refuseBtn{
    if (!_refuseBtn) {
        _refuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseBtn setTitle:@"Remove".icanlocalized forState:UIControlStateNormal];
        _refuseBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _refuseBtn.backgroundColor=UIColorSearchBgColor;
        [_refuseBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
        [_refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_refuseBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    return _refuseBtn;
}
-(void)refuseBtnClick{
    if (self.refuseSucessBlock) {
        self.refuseSucessBlock();
    }
}
-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //加好友
        [_agreeBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _agreeBtn.backgroundColor= UIColorThemeMainColor;
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        
    }
    return _agreeBtn;
}

-(UILabel *)friendInfoLab{
    if (!_friendInfoLab) {
        _friendInfoLab = [UILabel leftLabelWithTitle:@"" font:13 color:UIColorThemeMainSubTitleColor];
    }
    return _friendInfoLab;
}
-(UIImageView *)genderImgView{
    if (!_genderImgView) {
        _genderImgView=[[UIImageView alloc]init];
    }
    return _genderImgView;
}

@end

//
//  TransferTableViewCell.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/5/24.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "GroupListTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface GroupListTableViewCell ()
@property (nonatomic,strong) DZIconImageView *headerImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *vipImageView;

@end
@implementation GroupListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.contentView.backgroundColor = UIColorThemeMainBgColor;
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.centerY.mas_equalTo(self);
    }];
    [self addSubview:self.vipImageView];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16.5);
        make.right.equalTo(self.headerImageView.mas_right);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
    }];
}
-(void)setGroupListInfo:(GroupListInfo *)groupListInfo{
    _groupListInfo=groupListInfo;
    [self.headerImageView setImageWithString:groupListInfo.headImgUrl placeholder:GroupDefault];
    if ([groupListInfo.businessType isEqualToString:@"Vip"]) {
        self.vipImageView.hidden=NO;
    }else{
        self.vipImageView.hidden=YES;
    }
    self.nameLabel.text = groupListInfo.name;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel leftLabelWithTitle:@"" font:16 color:UIColorThemeMainTitleColor];
    }
    return _nameLabel;
}
-(UIImageView *)vipImageView{
    if (!_vipImageView) {
        _vipImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_group_vip_tip")];
        
    }
    return _vipImageView;
}
-(DZIconImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView=[[DZIconImageView alloc]init];
        [_headerImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    }
    return _headerImageView;
}
@end

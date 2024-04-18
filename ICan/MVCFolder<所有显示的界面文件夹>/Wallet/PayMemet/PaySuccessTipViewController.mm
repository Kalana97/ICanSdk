//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 3/9/2020
 - File name:  PaySuccessTipViewController.m
 - Description:
 - Function List:
 */


#import "PaySuccessTipViewController.h"
#import "UIViewController+Extension.h"
#import "WCDBManager+UserMessageInfo.h"
@interface PaySuccessTipViewController ()
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation PaySuccessTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Payment Result".icanlocalized;
    self.view.backgroundColor = UIColorViewBgColor;
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@75);
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(NavBarHeight+50));
    }];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
        make.left.equalTo(@90);
        make.right.equalTo(@-90);
    }];
    [self.view addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"PayMoneyViewController",@"PayReceiptMentViewController",@"QRCodeController",@"PayMoneyInputViewController"]];
}
-(void)setUserId:(NSString *)userId{
    _userId=userId;
    if (self.isPay) {
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            if (BaseSettingManager.isChinaLanguages) {
                self.nameLabel.text=[NSString stringWithFormat:@"向%@成功支付了",info.remarkName?:info.nickname];
            }else{//
                self.nameLabel.text=[NSString stringWithFormat:@"Successfully paid to %@",info.remarkName?:info.nickname];
            }
            
        }];
    }else{
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            if (BaseSettingManager.isChinaLanguages) {
                self.nameLabel.text=[NSString stringWithFormat:@"%@向你支付了",info.remarkName?:info.nickname];
            }else{//
                self.nameLabel.text=[NSString stringWithFormat:@"%@ paid to you",info.remarkName?:info.nickname];
            }
            
        }];
    }
    //XXX 向你支付了 XX
    
    
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:75/2 borderWidth:0 borderColor:nil];
    }
    return _iconImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:nil font:16 color:UIColorThemeMainTitleColor];
        _nameLabel.numberOfLines=0;
    }
    return _nameLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel=[UILabel centerLabelWithTitle:nil font:40 color:UIColorThemeMainTitleColor];
        _amountLabel.font=[UIFont boldSystemFontOfSize:40];
    }
    return _amountLabel;
}


@end

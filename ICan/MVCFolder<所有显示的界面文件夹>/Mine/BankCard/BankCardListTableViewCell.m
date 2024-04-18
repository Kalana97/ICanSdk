//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  BankCardListTableViewCell.m
- Description:
- Function List:
*/
        

#import "BankCardListTableViewCell.h"
@interface BankCardListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end

@implementation BankCardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    [self.iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
    [self.bgImageView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.lineView.hidden=YES;
}
-(void)setBindingBankCardListInfo:(BindingBankCardListInfo *)bindingBankCardListInfo{
    _bindingBankCardListInfo=bindingBankCardListInfo;
    self.nameLabel.text=bindingBankCardListInfo.bankName;
    self.accountLabel.text=bindingBankCardListInfo.cardNo.encryptBankCardNum;
    
    NSString*bankType=bindingBankCardListInfo.bankCode;
    NSString*bgImageName;
    NSString*iconImageName;
    if ([bankType isEqualToString:@"ABC"]) {//中国农业银行
        bgImageName=@"nongyebg";
        iconImageName=@"nongye";
    }else if ([bankType isEqualToString:@"ICBC"]){
        bgImageName=@"gongshangbg";
        iconImageName=@"gongshang";
    }else if ([bankType isEqualToString:@"CEB"]){//光大
        bgImageName=@"guangdabg";
        iconImageName=@"guangda";
    }else if ([bankType isEqualToString:@"CGB"]){//广发
        bgImageName=@"guangfabg";
        iconImageName=@"guangfa";
    }else if ([bankType isEqualToString:@"HXB"]){//华夏
        bgImageName=@"huaxiabg";
        iconImageName=@"huaxia";
    }else if ([bankType isEqualToString:@"CCB"]){//建设
        bgImageName=@"jianshebg";
        iconImageName=@"jianshe";
    }else if ([bankType isEqualToString:@"BOCO"]){//交通
        bgImageName=@"jiaotongbg";
        iconImageName=@"jiaotong";
    }else if ([bankType isEqualToString:@"CMBC"]){//民生
        bgImageName=@"minshengbg";
        iconImageName=@"minsheng";
    }else if ([bankType isEqualToString:@"SDB"]){//平安
        bgImageName=@"pinganbg";
        iconImageName=@"pingan";
    }else if ([bankType isEqualToString:@"CIB"]){//兴业
        bgImageName=@"xingyebg";
        iconImageName=@"xingye";
    }else if ([bankType isEqualToString:@"PSBC"]){//邮政
        bgImageName=@"youzhengbg";
        iconImageName=@"youzheng";
    }else if ([bankType isEqualToString:@"CMBCHINA"]){//招商
        bgImageName=@"zhaoshangbg";
        iconImageName=@"zhaoshang";
    }else if ([bankType isEqualToString:@"BOC"]){//中国银行
        bgImageName=@"zhongguobg";
        iconImageName=@"zhongguo";
    }else if ([bankType isEqualToString:@"ECITIC"]){//中信
        bgImageName=@"zhongxinbg";
        iconImageName=@"zhongxin";
    }else {//其他
        bgImageName=@"yinlianbg";
        iconImageName=@"yinlian";
    }
    self.bgImageView.image=UIImageMake(bgImageName);
    self.iconImageView.image=UIImageMake(iconImageName);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

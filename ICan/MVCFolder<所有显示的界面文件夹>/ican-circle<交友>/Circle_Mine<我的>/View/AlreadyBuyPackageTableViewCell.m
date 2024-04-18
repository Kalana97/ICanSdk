
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  AlreadyBuyPackageTableViewCell.m
- Description:
- Function List:
*/
        

#import "AlreadyBuyPackageTableViewCell.h"

@interface AlreadyBuyPackageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *packageTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *packageTypeDetailLabel;

//@property (weak, nonatomic) IBOutlet UILabel *userLabel;
//@property (weak, nonatomic) IBOutlet UILabel *userDetialLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIView *expireBgView;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;

@end

@implementation AlreadyBuyPackageTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden=YES;

//    "AlreadyBuyPackageTableViewCell.packageTypeLabel"="套餐";
//    "AlreadyBuyPackageTableViewCell.userLabel"="使用次数/总次数";
//    "AlreadyBuyPackageTableViewCell.timeTipLabel"="购买日期";
//    self.packageTypeLabel.text=@"AlreadyBuyPackageTableViewCell.packageTypeLabel".icanlocalized;
    
    //购买日期
//    self.timeTipLabel.text=@"AlreadyBuyPackageTableViewCell.timeTipLabel".icanlocalized;
//    实现以初始位置为基准,将坐标系统逆时针旋转angle弧度(弧度=π/180×角度,M_PI弧度代表180角度)
    self.expireBgView.transform = CGAffineTransformMakeRotation(M_PI*0.15);
//    "AlreadyBuyPackageTableViewCell.expireLabel"="已过期";
    self.expireLabel.text=@"AlreadyBuyPackageTableViewCell.expireLabel".icanlocalized;
    [self.expireBgView layerWithCornerRadius:2 borderWidth:1 borderColor:UIColor153Color];
    [self.typeImgView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
}
#pragma mark - Setter
-(void)setMyPackagesInfo:(MyPackagesInfo *)myPackagesInfo{
    _myPackagesInfo=myPackagesInfo;
    self.packageNameLabel.text=myPackagesInfo.showLocalPackageName;
//    self.packageTypeDetailLabel.text=myPackagesInfo.showLocaltitle;
    self.timeLabel.text=[GetTime convertDateWithString:myPackagesInfo.payTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    if ([myPackagesInfo.packageType isEqualToString:@"Count"]) {//次数
        self.expireBgView.hidden=myPackagesInfo.useCount!=myPackagesInfo.totalCount;
        self.expireLabel.text=@"AlreadyBuyPackageTableViewCell.expireLabel.count".icanlocalized;
//        "AlreadyBuyPackageTableViewCell.expireLabel.count"="已用完";
//        "AlreadyBuyPackageTableViewCell.expireLabel.time"="已失效";
    }else{
//        1622563200000
        NSInteger current=[[NSDate date]timeIntervalSince1970]*1000;
        self.expireBgView.hidden=current<myPackagesInfo.endTime.integerValue;
        self.expireLabel.text=@"AlreadyBuyPackageTableViewCell.expireLabel.time".icanlocalized;
    }
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        if ([myPackagesInfo.unit isEqualToString:@"CNY"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",myPackagesInfo.price];
            if ([myPackagesInfo.packageType isEqualToString:@"Count"]) {
                //使用次数
    //            self.userLabel.text=@"AlreadyBuyPackageTableViewCell.userLabel".icanlocalized;
                self.packageNameLabel.text = [NSString stringWithFormat:@"%@(%ld/%ld)",myPackagesInfo.showLocalPackageName,myPackagesInfo.useCount,myPackagesInfo.totalCount];
            }else{
                self.packageNameLabel.text = myPackagesInfo.showLocalPackageName;
            }
        }else if ([myPackagesInfo.unit isEqualToString:@"LKR"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"Rs%.2f",myPackagesInfo.price];
            if ([myPackagesInfo.packageType isEqualToString:@"Count"]) {
                self.packageNameLabel.text = [NSString stringWithFormat:@"%@(%ld/%ld)",myPackagesInfo.showLocalPackageName,myPackagesInfo.useCount,myPackagesInfo.totalCount];
            }else{
                self.packageNameLabel.text = myPackagesInfo.showLocalPackageName;
            }
        }
     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        if ([myPackagesInfo.unit isEqualToString:@"CNT"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",myPackagesInfo.price];
            if ([myPackagesInfo.packageType isEqualToString:@"Count"]) {
                //使用次数
    //            self.userLabel.text=@"AlreadyBuyPackageTableViewCell.userLabel".icanlocalized;
                self.packageNameLabel.text = [NSString stringWithFormat:@"%@(%ld/%ld)",myPackagesInfo.showLocalPackageName,myPackagesInfo.useCount,myPackagesInfo.totalCount];
            }else{
                self.packageNameLabel.text = myPackagesInfo.showLocalPackageName;
            }
           
        }else if ([myPackagesInfo.unit isEqualToString:@"LKR"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"Rs%.2f",myPackagesInfo.price];
            if ([myPackagesInfo.packageType isEqualToString:@"Count"]) {
                self.packageNameLabel.text = [NSString stringWithFormat:@"%@(%ld/%ld)",myPackagesInfo.showLocalPackageName,myPackagesInfo.useCount,myPackagesInfo.totalCount];
            }else{
                self.packageNameLabel.text = myPackagesInfo.showLocalPackageName;
            }
        }
    }
    [self.typeImgView setImageWithString:myPackagesInfo.logo placeholder:nil];
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end


/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  BuyPackageCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "BuyPackageCollectionViewCell.h"

@interface BuyPackageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *packDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *packNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
//236 67 99  51 54 59
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation BuyPackageCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgContentView layerWithCornerRadius:15 borderWidth:2 borderColor:UIColorMake(29, 124, 243)];
   
}
#pragma mark - Setter
-(void)setPackagesInfo:(PackagesInfo *)packagesInfo{
    _packagesInfo=packagesInfo;
    self.packNameLabel.text=packagesInfo.showLocalPackageName;
//    "BuyPackageCollectionViewCell.countChat"="人聊天";
    //    "BuyPackageCollectionViewCell.unlock"="解锁";
    //    "BuyPackageCollectionViewCell.day"="天";
    //    "BuyPackageCollectionViewCell.people"="人";
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        if ([packagesInfo.unit isEqualToString:@"CNY"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",packagesInfo.price];
            if ([packagesInfo.packageType isEqualToString:@"Count"]) {
                self.packDetailLabel.text = [NSString stringWithFormat:@"%ld%@",packagesInfo.totalCount,@"BuyPackageCollectionViewCell.countChat".icanlocalized];
                self.detailLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",packagesInfo.price/packagesInfo.totalCount,@"BuyPackageCollectionViewCell.people".icanlocalized];
            }else{
                self.detailLabel.text = @"";
                self.packDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@",@ "BuyPackageCollectionViewCell.unlock".icanlocalized,packagesInfo.totalTime,@"BuyPackageCollectionViewCell.day".icanlocalized];
            }
           
        }else if ([packagesInfo.unit isEqualToString:@"LKR"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"Rs%.2f",packagesInfo.price];
            if ([packagesInfo.packageType isEqualToString:@"Count"]) {
                self.packDetailLabel.text = [NSString stringWithFormat:@"%ld%@",packagesInfo.totalCount,@"BuyPackageCollectionViewCell.countChat".icanlocalized];
                self.detailLabel.text = [NSString stringWithFormat:@"Rs%.2f/%@",packagesInfo.price/packagesInfo.totalCount,@"BuyPackageCollectionViewCell.people".icanlocalized];
            }else{
                self.detailLabel.text = @"";
                self.packDetailLabel.text=[NSString stringWithFormat:@"%@%ld%@",@ "BuyPackageCollectionViewCell.unlock".icanlocalized,packagesInfo.totalTime,@"BuyPackageCollectionViewCell.day".icanlocalized];
            }
        }
     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        if ([packagesInfo.unit isEqualToString:@"CNY"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",packagesInfo.price];
            if ([packagesInfo.packageType isEqualToString:@"Count"]) {
                self.packDetailLabel.text = [NSString stringWithFormat:@"%ld%@",packagesInfo.totalCount,@"BuyPackageCollectionViewCell.countChat".icanlocalized];
                self.detailLabel.text = [NSString stringWithFormat:@"￥%.2f/%@",packagesInfo.price/packagesInfo.totalCount,@"BuyPackageCollectionViewCell.people".icanlocalized];
            }else{
                self.detailLabel.text = @"";
                self.packDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@",@ "BuyPackageCollectionViewCell.unlock".icanlocalized,packagesInfo.totalTime,@"BuyPackageCollectionViewCell.day".icanlocalized];
            }
        }else if ([packagesInfo.unit isEqualToString:@"LKR"]) {
            self.amountLabel.text = [NSString stringWithFormat:@"Rs%.2f",packagesInfo.price];
            if ([packagesInfo.packageType isEqualToString:@"Count"]) {
                self.packDetailLabel.text = [NSString stringWithFormat:@"%ld%@",packagesInfo.totalCount,@"BuyPackageCollectionViewCell.countChat".icanlocalized];
                self.detailLabel.text = [NSString stringWithFormat:@"Rs%.2f/%@",packagesInfo.price/packagesInfo.totalCount,@"BuyPackageCollectionViewCell.people".icanlocalized];
            }else{
                self.detailLabel.text = @"";
                self.packDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@",@ "BuyPackageCollectionViewCell.unlock".icanlocalized,packagesInfo.totalTime,@"BuyPackageCollectionViewCell.day".icanlocalized];
            }
        }
    }
    if (packagesInfo.select) {
        [self.bgContentView layerWithCornerRadius:15 borderWidth:2 borderColor:UIColorMake(29, 124, 243)];
        self.amountLabel.textColor=UIColorMake(29, 124, 243);
        self.bgContentView.backgroundColor=UIColor.whiteColor;
    }else{
        [self.bgContentView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        self.amountLabel.textColor=UIColor.blackColor;
        self.bgContentView.backgroundColor=UIColorBg243Color;
    }
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end


/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/6/2021
- File name:  UtilityPaymentsFavoriteTableViewCell.m
- Description:
- Function List:
*/
        

#import "UtilityPaymentsFavoriteTableViewCell.h"

@interface UtilityPaymentsFavoriteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaNameLabel;

@end

@implementation UtilityPaymentsFavoriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.typeImageVIew layerWithCornerRadius:30 borderWidth:1 borderColor:UIColorBg243Color];
}
#pragma mark - Setter
-(void)setDialogInfo:(DialogListInfo *)dialogInfo{
    _dialogInfo=dialogInfo;
    [self.typeImageVIew setImageWithString:dialogInfo.logo placeholder:nil];
    self.diaNameLabel.text=dialogInfo.name;
    self.mobileLabel.text=dialogInfo.accountNumber;
    self.nameLabel.text=dialogInfo.nickname;
}

@end

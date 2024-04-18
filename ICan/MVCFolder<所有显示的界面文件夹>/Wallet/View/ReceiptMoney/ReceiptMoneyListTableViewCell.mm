//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 1/9/2020
 - File name:  ReceiptMoneyListTableViewCell.m
 - Description:
 - Function List:
 */


#import "ReceiptMoneyListTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
@interface ReceiptMoneyListTableViewCell ()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
@implementation ReceiptMoneyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setInfo:(Notice_PayQRInfo *)info{
    _info=info;
    /**
     * 支付中 1
     * 支付完成 2
     * 支付取消 3
     */
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:[NSString stringWithFormat:@"%zd",info.userId] successBlock:^(UserMessageInfo * _Nonnull info) {
        [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        self.nameLabel.text=info.remarkName?:info.nickname;
    }];
    switch (info.status) {
        case 1:
            self.statusLabel.text=@"Paying";
            self.statusLabel.text=@"Paying".icanlocalized;
            break;
        case 2:
            self.statusLabel.text=@"Payment successful";
            self.statusLabel.text=@"Payment successful".icanlocalized;
            self.statusLabel.text=[NSString stringWithFormat:@"￥%.2f",info.money];
            break;
        case 3:
            self.statusLabel.text=@"Cancel payment";
            self.statusLabel.text=@"Cancel payment".icanlocalized;
            break;
        default:
            break;
            
    }
    
}


@end

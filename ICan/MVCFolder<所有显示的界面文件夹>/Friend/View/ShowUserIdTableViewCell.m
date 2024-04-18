//
//  ShowUserIdTableViewCell.m
//  OneChatAPP
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "ShowUserIdTableViewCell.h"

@interface ShowUserIdTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *userIdLB;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation ShowUserIdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorThemeMainBgColor;
    self.userIdLB.textColor=UIColorThemeMainTitleColor;
    self.backgroundColor=[UIColor clearColor];
    self.userIdLB.text = [NSString stringWithFormat:@"ID:%@",[UserInfoManager sharedManager].numberId];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.qrImageView.userInteractionEnabled=YES;
    [self.qrImageView addGestureRecognizer:tap];

}

-(void)tapAction{
    !self.tapQrBlock?:self.tapQrBlock();
}

@end

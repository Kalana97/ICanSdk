//
//  ReinviteCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ReinviteCell.h"

@implementation ReinviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setDataForCell:(MemebersResponseInfo *)userModel{
    [self.userImgIcon setDZIconImageViewWithUrl:userModel.headImgUrl gender:@""];
    self.nameLbl.text = userModel.nickname;
    self.userImgIcon.layer.cornerRadius = self.userImgIcon.frame.size.height/2;
    self.userImgIcon.clipsToBounds = YES;
    [self.btnBoarderResend layerWithCornerRadius:3 borderWidth:1 borderColor:UIColor.clearColor];
    [self.bgCell layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.reinviteLbl.text = @"Reinvite".icanlocalized;
}

- (IBAction)didClickOnReinvite:(id)sender {
    if (self.inviteBlock) {
        self.inviteBlock();
    }
}

@end

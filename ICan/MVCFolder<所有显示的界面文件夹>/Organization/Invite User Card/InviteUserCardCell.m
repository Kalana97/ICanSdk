//
//  InviteUserCardCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "InviteUserCardCell.h"

@implementation InviteUserCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDataForCell:(UserMessageInfo *)userModel{
    [self.iconImgLogo setDZIconImageViewWithUrl:userModel.headImgUrl gender:@""];
    self.userNameLbl.text = userModel.nickname;
    self.iconImgLogo.layer.cornerRadius = self.iconImgLogo.frame.size.height/2;
    self.iconImgLogo.clipsToBounds = YES;
    [self.inviteBtn layerWithCornerRadius:3 borderWidth:1 borderColor:UIColor.clearColor];
    [self.bgCellView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.inviteBtn setTitle:@"Invite".icanlocalized forState:UIControlStateNormal];
}

-(void)setContact:(MemebersResponseInfo *)userModel{
    [self.iconImgLogo setDZIconImageViewWithUrl:userModel.headImgUrl gender:@""];
    self.userNameLbl.text = userModel.nickname;
    self.iconImgLogo.layer.cornerRadius = self.iconImgLogo.frame.size.height/2;
    self.iconImgLogo.clipsToBounds = YES;
    [self.inviteBtn layerWithCornerRadius:3 borderWidth:1 borderColor:UIColor.clearColor];
    [self.bgCellView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.inviteBtn setTitle:@"Invite".icanlocalized forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didClickInviteAction:(id)sender {
    if (self.inviteBlock) {
        self.inviteBlock();
    }
}


@end

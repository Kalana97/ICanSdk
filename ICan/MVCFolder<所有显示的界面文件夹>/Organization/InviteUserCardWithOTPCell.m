//
//  InviteUserCardWithOTPCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "InviteUserCardWithOTPCell.h"

@implementation InviteUserCardWithOTPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.otpTxt.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setDataForCell:(MemebersResponseInfo *)userModel{
    [self.inviteBtn layerWithCornerRadius:3 borderWidth:1 borderColor:UIColor.clearColor];
    [self.inviteBtn setTitle:@"Sure".icanlocalized forState:UIControlStateNormal];
    [self.userImgIcon setDZIconImageViewWithUrl:userModel.headImgUrl gender:@""];
    self.userNameLbl.text = userModel.nickname;
    self.userImgIcon.layer.cornerRadius = self.userImgIcon.frame.size.height/2;
    self.userImgIcon.clipsToBounds = YES;
    [self.cellBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    NSString *originalString = [NSString stringWithFormat:@"Please get OTP from %@ and verify him in to the organization.".icanlocalized, userModel.nickname];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    NSString *substring = userModel.nickname;
    NSRange boldRange = [originalString rangeOfString:substring];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:15.0]
                             range:boldRange];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blackColor]
                             range:boldRange];
    self.descLbl.attributedText = attributedString;
    self.otpTxt.placeholder = @"Enter the OTP".icanlocalized;
}

- (IBAction)didInvite:(id)sender {
        if (self.tapBlock) {
            self.tapBlock(self.otpTxt.text);
            self.otpTxt.text = @"";
        }
}


@end

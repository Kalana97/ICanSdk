//
//  MemberCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(MemebersResponseInfo *)memberModel{
    [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.userImg.layer.cornerRadius = self.userImg.frame.size.height/2;
    self.userImg.clipsToBounds = YES;
    [self.userTypeBgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColor.clearColor];
    [self.userImg setDZIconImageViewWithUrl:memberModel.headImgUrl gender:@""];
    if([UserInfoManager.sharedManager.userId integerValue] == memberModel.userId){
        self.userNameLbl.text = [NSString stringWithFormat:@"%@ (%@)", memberModel.nickname, @"tabbar.me".icanlocalized];
    }else{
        self.userNameLbl.text = [NSString stringWithFormat:@"%@", memberModel.nickname];
    }
    if(memberModel.userType == 1){
        self.userTypeLbl.text = @"Owner".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X2F80ED);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FAFF);
    }else if (memberModel.userType == 2){
        self.userTypeLbl.text = @"Manager".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X27AE60);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FFF6) ;
    }else{
        self.userTypeLbl.text = @"User".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X9B51E0);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF8F3FF);
    }
}

- (IBAction)didSelectUserAction:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end

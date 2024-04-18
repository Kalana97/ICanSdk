//
//  AssignMemberCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AssignMemberCell.h"

@implementation AssignMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(MemebersResponseInfo *) modelData{
    self.userLogoImg.layer.cornerRadius = self.userLogoImg.frame.size.height/2;
    self.userLogoImg.clipsToBounds = YES;
    [self.userTypeBgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColor.clearColor];
    [self.userLogoImg setDZIconImageViewWithUrl:modelData.headImgUrl gender:@""];
    if([UserInfoManager.sharedManager.userId integerValue] == modelData.userId){
        self.nameLbl.text = [NSString stringWithFormat:@"%@ (%@)", modelData.nickname, @"tabbar.me".icanlocalized];
        self.selectImg.hidden = YES;
        self.tapBtn.enabled = NO;
    }else{
        self.nameLbl.text = [NSString stringWithFormat:@"%@ (L%ld)", modelData.nickname,(long)modelData.userType];
        self.selectImg.hidden = NO;
        self.tapBtn.enabled = YES;
    }
    if(modelData.userType == 1){
        self.userTypeLbl.text = @"Owner".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X2F80ED);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FAFF);
    }else if (modelData.userType == 2){
        self.userTypeLbl.text = @"Manager".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X27AE60);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF3FFF6) ;
    }else{
        self.userTypeLbl.text = @"User".icanlocalized;
        self.userTypeLbl.textColor = UIColorMakeHEXCOLOR(0X9B51E0);
        self.userTypeBgView.backgroundColor = UIColorMakeHEXCOLOR(0XF8F3FF);
    }
    if(modelData.isSelected == true){
        self.selectImg.image = [UIImage imageNamed:@"done-round-svgrepo-com (1) 1 (1)"];
    }else{
        self.selectImg.image = [UIImage imageNamed:@"Notdone-round-svgrepo-com (1) 1"];
    }
    [self.bgCell layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

- (IBAction)didClickOnMember:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end

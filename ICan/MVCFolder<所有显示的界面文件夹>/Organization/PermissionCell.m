//
//  PermissionCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "PermissionCell.h"

@implementation PermissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(PermissionResponse *)modelData{
    self.permissionLogoImg.image = [UIImage imageNamed:modelData.imageName];
    self.permissionTypeLbl.text = modelData.showName;
    if(modelData.isSelected == true){
        self.isSelectBtn.image = [UIImage imageNamed:@"done-round-svgrepo-com (1) 1 (1)"];
    }else{
        self.isSelectBtn.image = [UIImage imageNamed:@"Notdone-round-svgrepo-com (1) 1"];
    }
    [self.bgCell layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

- (IBAction)didClickOnCell:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end

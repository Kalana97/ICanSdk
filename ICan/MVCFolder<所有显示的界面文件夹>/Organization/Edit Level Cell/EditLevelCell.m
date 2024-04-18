//
//  EditLevelCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "EditLevelCell.h"

@implementation EditLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(int)levelVal{
    [self.bgCell layerWithCornerRadius:8 borderWidth:1 borderColor:UIColor.clearColor];
    self.levelNamLbl.text = [NSString stringWithFormat:@"%@ %02d",@"Level".icanlocalized ,levelVal];
    if(levelVal == 1){
        self.deleteBtn.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
    }
}

- (IBAction)didClickDeleteLevel:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

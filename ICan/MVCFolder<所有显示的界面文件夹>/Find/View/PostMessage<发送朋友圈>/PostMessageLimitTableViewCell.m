//
//  PostMessageLimitTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/6.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "PostMessageLimitTableViewCell.h"

@implementation PostMessageLimitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDictionary:(NSDictionary *)dictionary{
    _dictionary =dictionary;
    self.topLabel.text =dictionary[@"top"];
    self.bottomLabel.text =dictionary[@"bottom"];
    self.iconImageView.image = [UIImage imageNamed:dictionary[@"icon"]];
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        [self.leftBtn setImage:[UIImage imageNamed:@"wallet_recharge_way_select"] forState:UIControlStateNormal];
    }else{
        
        [self.leftBtn setImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonAction:(id)sender {
    !self.leftBtnBlock?:self.leftBtnBlock();
    
}

@end

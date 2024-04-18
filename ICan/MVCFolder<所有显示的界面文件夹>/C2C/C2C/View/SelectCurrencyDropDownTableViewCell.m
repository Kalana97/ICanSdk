//
//  SelectCurrencyDropDownTableViewCell.m
//  ICan
//  Created by Kalana Rathnayaka on 12/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "SelectCurrencyDropDownTableViewCell.h"

@implementation SelectCurrencyDropDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
}

-(void)hiddenView{
    !self.hiddenBlock?:self.hiddenBlock();
}

@end

//
//  InsideDynamicViewTableViewCell.m
//  ICan
//
//  Created by Kalana Rathnayaka on 06/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "InsideDynamicViewTableViewCell.h"

@implementation InsideDynamicViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

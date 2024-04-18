//
//  AmountViewCollectionViewCell.m
//  ICan
//
//  Created by Kalana Rathnayaka on 20/10/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AmountViewCollectionViewCell.h"

@implementation AmountViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.amountLabel.layer.cornerRadius = 5.0;
    self.amountLabel.layer.masksToBounds = YES;
}

@end

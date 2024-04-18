//
//  ReactCollectionViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ReactCollectionViewCell.h"
@interface ReactCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *reactIcon;
@property (weak, nonatomic) IBOutlet UIView *reactionBg;
@end
@implementation ReactCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setReactItem:(ReactItem *)reactItem{
    self.reactIcon.image = UIImageMake(reactItem.reactImg);
    self.reactionBg.layer.cornerRadius = 21;
    self.reactionBg.backgroundColor = reactItem.bgColor;
}

@end

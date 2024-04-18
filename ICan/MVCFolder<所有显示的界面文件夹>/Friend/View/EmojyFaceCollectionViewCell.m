//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  EmojyFaceCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "EmojyFaceCollectionViewCell.h"

@implementation EmojyFaceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:tap];
    
}
-(void)tapAction{
    if (self.selectEmojyBlock) {
        self.selectEmojyBlock(self.faceLabel.text);
    }
}
@end

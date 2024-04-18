//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  CatogoryCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "CatogoryCollectionViewCell.h"

@implementation CatogoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:tap];
    self.contentView.backgroundColor=UIColorViewBgColor;
    
}
-(void)tapAction{
    if (self.catogoryTapBlock) {
        self.catogoryTapBlock();
    }
}
@end

//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/2
- ICan
- File name:  DZIconImageView.m
- Description:
- Function List:
*/
        

#import "DZIconImageView.h"
#import "UIImageView+SDWebImage.h"
@implementation DZIconImageView
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self addTap];
//    
//}
//-(instancetype)init{
//    if (self=[super init]) {
//        [self addTap];
//    }
//    return self;
//}
-(void)addTap{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}
-(void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
-(void)setDZIconImageViewWithUrl:(NSString *)headImageUrl gender:(NSString *)gender{
    self.contentMode=UIViewContentModeScaleAspectFill;
   [self setImageWithString:headImageUrl placeholder:[gender isEqualToString:@"2"]?GirlDefault:BoyDefault];
    
}
-(void)setCircleIconImageViewWithUrl:(NSString*)headImageUrl gender:(NSString*)gender{
    self.contentMode=UIViewContentModeScaleAspectFill;
    [self setImageWithString:headImageUrl placeholder:[gender isEqualToString:@"Male"]?GirlDefault:BoyDefault];
}
@end


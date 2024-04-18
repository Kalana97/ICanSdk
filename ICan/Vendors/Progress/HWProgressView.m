//
//  HWProgressView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWProgressView.h"
#import "ColorMacro.h"
#import "NSString+DZExtension.h"
#define KProgressBorderWidth 2.0f
#define KProgressPadding 1.0f
#define KProgressColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]
#define UIColorDDMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
@interface HWProgressView ()

@property (nonatomic, weak) UIView *tView;

@end

@implementation HWProgressView

- (instancetype)initWithFrame:(CGRect)frame{
//    200  80
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=UIColorDDMakeWithRGBA(0, 0, 0, 0.6);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        UILabel*tipsLabel=[[UILabel alloc]init];
        tipsLabel.font=[UIFont systemFontOfSize:16];
        tipsLabel.textColor=UIColor.whiteColor;
        tipsLabel.text=@"HWProgressView.Processing".icanlocalized;
        tipsLabel.frame=CGRectMake(20, 15, self.bounds.size.width-40, 20);
        [self addSubview:tipsLabel];
        //底框
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(20, 55, self.bounds.size.width-40, 6)];
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.backgroundColor=UIColorDDMakeWithRGBA(68, 68, 66, 1);
        [self addSubview:borderView];
        //顶部背景进度
        UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 6)];
        tView.backgroundColor = UIColor.whiteColor;
        [borderView addSubview:tView];
        self.tView = tView;
      
        
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    CGFloat maxWidth = self.bounds.size.width - 40;
    _tView.frame = CGRectMake(0, 0, maxWidth * progress, 6);
}

@end


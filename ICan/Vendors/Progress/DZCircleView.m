//
//  HWCircleView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "DZCircleView.h"

#define KHWCircleLineWidth 5.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:20.0f]
#define KHWCircleColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6]

@interface DZCircleView ()

@property (nonatomic, weak) UILabel *cLabel;

@end

@implementation DZCircleView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUIView];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUIView];
    }
    
    return self;
}
-(void)setUIView{
    [self addSubview:self.cLabel];
    [self.cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
-(UILabel *)cLabel{
    if (!_cLabel) {
        _cLabel=[UILabel centerLabelWithTitle:nil font:20 color:UIColor.whiteColor];
        _cLabel.font=[UIFont boldSystemFontOfSize:20.0f];
    }
    return _cLabel;
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    //路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //线宽
    path.lineWidth = KHWCircleLineWidth;
    //颜色
    [UIColor.whiteColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - KHWCircleLineWidth*5) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

@end


//
/**
- Copyright © 2020 dzl. All rights reserved.
- AUthor: Created  by DZL on 2020/2/24
- ICan
- File name:  DZUploadVideoProgressCircleView.m
- Description:
- Function List:
*/
        

#import "DZExportVideoProgressCircleView.h"
@interface DZExportVideoProgressCircleView()
@property (nonatomic, weak) UILabel *cLabel;
@property(nonatomic, strong) UILabel *tipsLabel;

@end
@implementation DZExportVideoProgressCircleView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    //百分比标签
    [self addSubview:self.cLabel];
    [self.cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(-5);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //百分比标签
        [self addSubview:self.cLabel];
        [self.cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY).offset(-10);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [self addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).offset(-5);
            make.left.equalTo(@5);
            make.right.equalTo(@-5);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    
    return self;
}
-(UILabel *)cLabel{
    if (!_cLabel) {
        _cLabel=[UILabel centerLabelWithTitle:nil font:14 color:UIColorThemeMainColor];
    }
    return _cLabel;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel centerLabelWithTitle:@"HWProgressView.Processing".icanlocalized font:14 color:UIColorThemeMainColor];
        _tipsLabel.numberOfLines=0;
    }
    return _tipsLabel;
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
    path.lineWidth = 2;
    //颜色
    [UIColorThemeMainColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - 2) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

@end

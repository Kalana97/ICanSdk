
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/7/2021
- File name:  PlayerProgressSlider.m
- Description:
- Function List:
*/
        

#import "PlayerProgressSlider.h"
#import "UIView+Nib.h"
//⭕️的宽度
#define CIRCLEWIDTH 12
@interface PlayerProgressSlider ()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *progressLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLineViewWidth;

@property (weak, nonatomic) IBOutlet UIView *circleView;

@end

@implementation PlayerProgressSlider
//-(instancetype)initWithCoder:(NSCoder *)coder{
//    if (self=[super initWithCoder:coder]) {
//        [[NSBundle mainBundle] loadNibNamed:@"PlayerProgressSlider" owner:self options:nil];
//        [self addSubview:self.view];
//    }
//    return self;
//}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.view.frame = self.bounds;
//}
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer*pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:tap];
    [self.circleView layerWithCornerRadius:6 borderWidth:0 borderColor:nil];
    [self.circleView addGestureRecognizer:pan];
}
-(void)updateSliderWidth{
    self.progressLineViewWidth.constant=(self.bottomLineView.width-12)*self.sliderPercent;
}
-(void)setSliderPercent:(CGFloat)sliderPercent{
    _sliderPercent=sliderPercent;
    self.progressLineViewWidth.constant=(self.bottomLineView.width-12)*sliderPercent;
}
-(void)tap:(UITapGestureRecognizer*)tap{
    CGPoint point=[tap locationInView:self.bottomLineView];
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
            self.isSliding=YES;
            NSLog(@"tap--UIGestureRecognizerStateBegan%@",NSStringFromCGPoint(point));
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:{
            //超出范围不改变
            if (point.x<=0) {
                self.progressLineViewWidth.constant=0;
                return;
            }
            if (point.x+CIRCLEWIDTH>=self.bottomLineView.width) {
                self.progressLineViewWidth.constant=self.bottomLineView.width-CIRCLEWIDTH;
                return;
            }
            self.progressLineViewWidth.constant=point.x;
            CGFloat progressWidth=self.progressLineViewWidth.constant;
            float value=progressWidth/(self.frame.size.width*1.0f-CIRCLEWIDTH);
            if (self.valueChangeBlock) {
                self.valueChangeBlock(value);
            }
            self.isSliding=NO;
        }
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        default:
            break;
    }
}
-(void)panAction:(UIPanGestureRecognizer*)pan{
    CGPoint point=[pan locationInView:self.bottomLineView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.isSliding=YES;
            break;
        case UIGestureRecognizerStateChanged:
            self.isSliding=YES;
            //超出范围不改变
            if (point.x<=0) {
                self.progressLineViewWidth.constant=0;
                return;
            }
            if (point.x+CIRCLEWIDTH>=self.bottomLineView.width) {
                self.progressLineViewWidth.constant=self.bottomLineView.width-CIRCLEWIDTH;
                return;
            }
            self.progressLineViewWidth.constant=point.x;
            break;
        case UIGestureRecognizerStateEnded:{
            CGFloat progressWidth=self.progressLineViewWidth.constant;
            float value=progressWidth/(self.frame.size.width*1.0f-CIRCLEWIDTH);
            if (self.valueChangeBlock) {
                self.valueChangeBlock(value);
            }
            self.isSliding=NO;
        }
           
            
            break;
        case UIGestureRecognizerStateFailed:
            self.isSliding=NO;
            
            break;
        case UIGestureRecognizerStateCancelled:
            self.isSliding=NO;
            
            
            break;
        default:
            break;
    }
}

@end

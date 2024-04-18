
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/7/2021
- File name:  PlayerProgressSlider.m
- Description:
- Function List:
*/
        

#import "GKPlayerProgressSlider.h"
@interface GKPlayerProgressSlider ()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *progressLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLineViewWidth;

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@end

@implementation GKPlayerProgressSlider
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer*pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
    [self.circleView layerWithCornerRadius:6 borderWidth:0 borderColor:nil];
}
-(void)setSliderPercent:(CGFloat)sliderPercent{
    _sliderPercent=sliderPercent;
    if (!isnan(sliderPercent)) {
        self.progressLineViewWidth.constant=self.bottomLineView.width*sliderPercent;
    }
    
}
-(void)tap:(UITapGestureRecognizer*)tap{
//    CGPoint point=[tap locationInView:self.bottomLineView];
//    switch (tap.state) {
//        case UIGestureRecognizerStateBegan:
//            self.isSliding=YES;
//            NSLog(@"tap--UIGestureRecognizerStateBegan%@",NSStringFromCGPoint(point));
//            break;
//        case UIGestureRecognizerStateChanged:
//            break;
//        case UIGestureRecognizerStateEnded:{
//            //超出范围不改变
//            if (point.x<=0) {
//                self.progressLineViewWidth.constant=0;
//                return;
//            }
//            if (point.x+CIRCLEWIDTH>=self.bottomLineView.width) {
//                self.progressLineViewWidth.constant=self.bottomLineView.width-CIRCLEWIDTH;
//                return;
//            }
//            self.progressLineViewWidth.constant=point.x;
//            CGFloat progressWidth=self.progressLineViewWidth.constant;
//            float value=progressWidth/(self.frame.size.width*1.0f-CIRCLEWIDTH);
//            if (self.valueChangeBlock) {
//                self.valueChangeBlock(value);
//            }
//            self.isSliding=NO;
//        }
//            
//            break;
//        case UIGestureRecognizerStateFailed:
//            
//            break;
//        case UIGestureRecognizerStateCancelled:
//            
//            break;
//        default:
//            break;
//    }
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
            if (point.x>=self.bottomLineView.width) {
                self.progressLineViewWidth.constant=self.bottomLineView.width;
                return;
            }
            self.lineViewHeight.constant=2;
            self.progressLineViewWidth.constant=point.x;
            CGFloat progressWidth=self.progressLineViewWidth.constant;
            float value=progressWidth/(self.frame.size.width*1.0f);
            if (self.valueChangeBlock) {
                self.valueChangeBlock(value);
            }
            break;
        case UIGestureRecognizerStateEnded:{
            self.lineViewHeight.constant=1;
            CGFloat progressWidth=self.progressLineViewWidth.constant;
            float value=progressWidth/(self.frame.size.width*1.0f);
            if (self.valueEndBlock) {
                self.valueEndBlock(value);
            }
            self.isSliding=NO;
        }
           
            
            break;
        case UIGestureRecognizerStateFailed:
            self.isSliding=NO;
            self.lineViewHeight.constant=1;
            break;
        case UIGestureRecognizerStateCancelled:
            self.isSliding=NO;
            self.lineViewHeight.constant=1;
            
            break;
        default:
            break;
    }
}

@end

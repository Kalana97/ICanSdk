//
//  UIButton+HYQUIButton.m
//  HaoYuanQu
//
//  Created by 陈工 on 16/1/28.
//  Copyright © 2016年 HaoYuanQu. All rights reserved.
//

#import "UIButton+HYQUIButton.h"

@implementation UIButton (HYQUIButton)

static dispatch_source_t __timer;
static NSString *__title;
static UIColor *__mColor;


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)withEvent{
    
    CGRect rect = self.bounds;
    CGSize size1 = rect.size;
    if (size1.width <= 44 && size1.height <= 44) {
        
        CGFloat widthDelta = MAX(44.0 - rect.size.width, 0);
        CGFloat heightDelta = MAX(44.0 - rect.size.height, 0);
        rect = CGRectInset(rect, -0.5 * widthDelta, -0.5 * heightDelta);
        return CGRectContainsPoint(rect, point);
    }
    return CGRectContainsPoint(rect, point);
}






+(UIButton*)dzNavButtonWithTitle:(NSString*)title image:(NSString*)image backgroundColor:(UIColor*)backgroundColor titleFont:(CGFloat)titleFont titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action;{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    if (title) {
        [button setTitle:title forState:(UIControlStateNormal)];
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    [button setTitleColor:titleColor?:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button sizeToFit];
    return button;
}
+(UIButton*)functionButtonWithTitle:(NSString*)title image:(NSString*)image backgroundColor:(UIColor*)backgroundColor titleFont:(CGFloat)titleFont target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (title) {
        [button setTitle:title forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button sizeToFit];
    return button;
}
+(UIButton*)dzButtonWithTitle:(NSString *)title image:(NSString *)image backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (title) {
        [button setTitle:title forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button sizeToFit];
    return button;
}

-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
    [self setBackgroundImage:[UIImage imageNamed:nbg] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg] forState:UIControlStateHighlighted];
}

- (void)setN_BGColor:(UIColor *)nbg H_BGColoor:(UIColor *)hbg {
    
        [self setBackgroundImage:[UIImage imageWithColor:nbg] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:hbg] forState:UIControlStateHighlighted];
}


-(void)setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
        [self setBackgroundImage:[UIImage stretchedImageWithName:nbg] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage stretchedImageWithName:hbg] forState:UIControlStateHighlighted];
}

- (void)setEnabledBGColor:(UIColor *)nbg unEnabledBGColoor:(UIColor *)uhbg {
        [self setBackgroundImage:[UIImage imageWithColor:uhbg] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageWithColor:nbg] forState:UIControlStateNormal];
}

- (void)setEnabledBG:(NSString *)bg unEnabledBG:(NSString *)unbg {
    //    [self setBackgroundImage:[UIImage stretchedImageWithName:unbg] forState:UIControlStateDisabled];
    //    [self setBackgroundImage:[UIImage stretchedImageWithName:bg] forState:UIControlStateNormal];
}
-(CGFloat)getButtonTextWith{
    [self sizeToFit];
    return self.bounds.size.width;
}
@end

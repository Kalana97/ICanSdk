//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/28
- ICan
- File name:  UIColor+DZExtension.m
- Description:
- Function List:
*/
        

#import "UIColor+DZExtension.h"

@implementation UIColor (DZExtension)
+(CAGradientLayer*)caGradientLayerWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius colors:(NSArray*)colors locations:(NSArray*)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    if (cornerRadius!=0) {
        gradientLayer0.cornerRadius = cornerRadius;
    }
    
    gradientLayer0.frame =frame;
    gradientLayer0.colors =colors;
    gradientLayer0.locations =locations;
    [gradientLayer0 setStartPoint:startPoint];
    [gradientLayer0 setEndPoint:endPoint];
    return gradientLayer0;
}
@end

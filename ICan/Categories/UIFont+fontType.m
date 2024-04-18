//
//  UIFont+fontType.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/23.
//  Copyright © 2019 EasyPay. All rights reserved.
//
#import "UIFont+fontType.h"

@implementation UIFont (fontType)
+ (UIFont *)fontWithLightSize:(CGFloat)size{
    UIFont *font;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        font = [UIFont fontWithName:@"PingFangSC-Light" size:KWidthRatio(size)];

    } else {
        font = TextFont(size);
    }
    return font;
}
+ (UIFont *)fontWithMediumSize:(CGFloat)size{
    UIFont *font;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:KWidthRatio(size)];
        
    } else {
        font = TextFont(size);
    }
    return font;
}
+ (UIFont *)fontWithSemiboldSize:(CGFloat)size{
    UIFont *font;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:KWidthRatio(size)];
        
    } else {
        font = TextFont(size);
    }
    return font;
}
+ (UIFont *)fontWithRegularSize:(CGFloat)size{
    UIFont *font;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:KWidthRatio(size)];
        
    } else {
        font = TextFont(size);
    }
    return font;
}
+ (UIFont *)fontWithDINSize:(CGFloat)size{
    UIFont *font;
    font = [UIFont fontWithName:@"DINMittelschrift-Alternate" size:KWidthRatio(size)];
    return font;
}
+ (UIFont *)fontWithDINAlternateSize:(CGFloat)size{
    UIFont *font;
    font = [UIFont fontWithName:@"DINAlternate-Bold" size:KWidthRatio(size)];
    return font;
}
@end

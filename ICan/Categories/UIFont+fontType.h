//
//  UIFont+fontType.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/23.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (fontType)

+ (UIFont *)fontWithLightSize:(CGFloat)size;

+ (UIFont *)fontWithMediumSize:(CGFloat)size;

+ (UIFont *)fontWithSemiboldSize:(CGFloat)size;

+ (UIFont *)fontWithRegularSize:(CGFloat)size;

+ (UIFont *)fontWithDINSize:(CGFloat)size;

+ (UIFont *)fontWithDINAlternateSize:(CGFloat)size;
@end

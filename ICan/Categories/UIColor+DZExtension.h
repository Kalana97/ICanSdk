//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/28
- ICan
- File name:  UIColor+DZExtension.h
- Description:
- Function List:
*/
        




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DZExtension)


+(CAGradientLayer*)caGradientLayerWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius colors:(NSArray*)colors locations:(NSArray*)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END

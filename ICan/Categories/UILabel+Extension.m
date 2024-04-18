//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 20/9/2019
- File name:  UILabel+Extension.m
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+ (UILabel *)leftLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    return [self labelWithTitle:title font:font color:color alignment:NSTextAlignmentLeft];
}

+ (UILabel *)centerLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    return [self labelWithTitle:title font:font color:color alignment:NSTextAlignmentCenter];
}
+ (UILabel *)rightLabelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color {
    return [self labelWithTitle:title font:font color:color alignment:NSTextAlignmentRight];
}

#pragma mark - Tool
+ (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
    UILabel *label          = [[UILabel alloc] init];
    label.text              = title;
    label.textColor         = color;
    label.font              = [UIFont systemFontOfSize:font];
    label.textAlignment     = alignment;
    label.backgroundColor   = [UIColor clearColor];
    [label sizeToFit];
    return label;
}
+(UILabel *)iconfontLableWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor iconfontColor:(UIColor *)iconfontColor iconfontRange:(NSRange)iconfontRange{
    UILabel*label=[[UILabel alloc]init];
    UIFont*iconfont = [UIFont fontWithName:@"iconfont"size:font];
    label.textColor=textColor;
    label.font=iconfont;
    NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:iconfontColor range:iconfontRange];
    label.attributedText=str;
    return label;
    
}
-(void)setLabelNativeCHFontWith:(CGFloat)font otherFont:(CGFloat)otherFont{
    if ([self isChinaLanguages]) {
        [self setFont:[UIFont systemFontOfSize:font]];
    }else{
         [self setFont:[UIFont systemFontOfSize:otherFont]];
    }
}
-(BOOL)isChinaLanguages{
//    zh-Hans-CN,中文简体
//    en-CN,
//    ja-JP,
//    en-US
    
//    zh-Hant-HK,
//    en-US,
//    zh-Hans-US,
//    en
    NSArray *appleLanguages = [NSLocale preferredLanguages];
    if (appleLanguages && appleLanguages.count > 0) {
        NSString *languages = appleLanguages[0];
        if ([languages hasPrefix:@"zh-Hans"]||[languages hasPrefix:@"zh-Hant"]||[languages hasPrefix:@"zh"]) {
            return YES;
        }
    }
    return NO;
}
@end

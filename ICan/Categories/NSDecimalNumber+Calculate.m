//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 17/12/2021
 - File name:  NSDecimalNumber+Calculate.m
 - Description:
 - Function List:
 */


#import "NSDecimalNumber+Calculate.h"
/*
     NSRoundPlain:四舍五入  NSRoundDown:向下取正   NSRoundUp:向上取正     NSRoundBankers:(特殊的四舍五入，碰到保留位数后一位的数字为5时，根据前一位的奇偶性决定。为偶时向下取正，为奇数时向上取正。如：1.25保留1为小数。5之前是2偶数向下取正1.2；1.35保留1位小数时。5之前为3奇数，向上取正1.4）
     scale:精确到几位小数
     raiseOnExactness:发生精确错误时是否抛出异常，一般为NO
     raiseOnOverflow:发生溢出错误时是否抛出异常，一般为NO
     raiseOnUnderflow:发生不足错误时是否抛出异常，一般为NO
     raiseOnDivideByZero:被0除时是否抛出异常，一般为YES
     */
@implementation NSDecimalNumber (Calculate)
-(NSDecimalNumber*)calculateWithRoundingMode:(NSRoundingMode)roundingMode scale:(short)scale{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:roundingMode
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [self decimalNumberByRoundingAccordingToBehavior: roundUp];
    return number;
}
-(NSDecimalNumber*)calculateByRoundingScale:(short)scale{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [self decimalNumberByRoundingAccordingToBehavior: roundUp];
    return number;
}
-(NSDecimalNumber*)calculateByNSRoundDownScale:(short)scale{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [self decimalNumberByRoundingAccordingToBehavior: roundUp];
    return number;
}

-(NSString*)calculateByNSRoundDownScaleSpecial:(short)scale{
    NSDecimalNumberHandler *roundingHandler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedNumber = [self decimalNumberByRoundingAccordingToBehavior: roundingHandler];
    NSString *formattedString = [roundedNumber stringValue];
    return formattedString;
}

-(NSString *)currencyString{
    NSRange dianRange = [self.stringValue rangeOfString:@"."];
    if (dianRange.location == NSNotFound) {
        return [NSString stringWithFormat:@"%.2f",self.doubleValue];
    }else{
        float lastLenth = [self.stringValue substringFromIndex:dianRange.location].length;
        if (lastLenth<=2) {
            return [NSString stringWithFormat:@"%.2f",self.doubleValue];
        }
    }
    return self.stringValue;
   
}
@end

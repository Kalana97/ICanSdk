//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2021
- File name:  NSString+DecimalNumber.m
- Description:
- Function List:
*/
        

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)
-(NSDecimalNumber*)decimalNumber{
    return [NSDecimalNumber decimalNumberWithString:self];
}


//加
- (NSString *)calculateByAdding:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *addingNum = [num1 decimalNumberByAdding:num2];
    return [addingNum stringValue];
}
NSString *decimalNumbeAdding(NSString *value1, NSString *value2)
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value1]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value2]];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByAdding:multiplicandNumber];
    return [product stringValue];
}

//减
- (NSString *)calculateBySubtracting:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *subtractingNum = [num1 decimalNumberBySubtracting:num2];
    return [subtractingNum stringValue];
}
NSString *decimalNumbeBySubtracting(NSString *value1, NSString *value2)
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value1]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value2]];
    NSDecimalNumber *product = [multiplierNumber decimalNumberBySubtracting:multiplicandNumber];
    return [product stringValue];
}
//乘
- (NSString *)calculateByMultiplying:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *multiplyingNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [multiplyingNum stringValue];
}
NSString *decimalNumbeByMultiplying(NSString *value1, NSString *value2)
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value1]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value2]];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByMultiplyingBy:multiplicandNumber];
    return [product stringValue];
}
//除
- (NSString *)calculateByDividing:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *dividingNum = [num1 decimalNumberByDividingBy:num2];
    return [dividingNum stringValue];
    
}
NSString *decimalNumbeByDividing(NSString *value1, NSString *value2)
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value1]];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value2]];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
    return [product stringValue];
}
//幂运算
- (NSString *)calculateByRaising:(NSUInteger)power
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *raisingNum = [num1 decimalNumberByRaisingToPower:power];
    return [raisingNum stringValue];
    
}
//四舍五入
- (NSString *)calculateByRounding:(NSUInteger)scale
{
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *roundingNum = [num1 decimalNumberByRoundingAccordingToBehavior:handler];
    return [roundingNum stringValue];
}
///只舍不入
-(NSString*)nSRoundDownByScale:(NSUInteger)scale{
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *roundingNum = [num1 decimalNumberByRoundingAccordingToBehavior:handler];
    return [roundingNum stringValue];
}
//是否相等
- (BOOL)calculateIsEqual:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedSame) {
        return YES;
    }
    return NO;
}
//是否大于
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;

}
//是否小于
- (BOOL)calculateIsLessThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedAscending) {
        return YES;
    }
    return NO;

}

- (double)calculateDoubleValue
{
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self];
    return [num doubleValue];
}

/// 最多保留8位小数
-(NSString *)decimal8Places{
    NSRange dianRange = [self rangeOfString:@"."];
    if (dianRange.location == NSNotFound) {
        return [NSString stringWithFormat:@"%.2f",self.doubleValue];
    }else{
        float lastLenth = [self substringFromIndex:dianRange.location].length;
        if (lastLenth<=2) {
            return [NSString stringWithFormat:@"%.2f",self.doubleValue];
        }
        if (lastLenth>8) {
            return  [NSString stringWithFormat:@"%.8f",self.doubleValue];
        }
    }
    return self;
   
}
@end

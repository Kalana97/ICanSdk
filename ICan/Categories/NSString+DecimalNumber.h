//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2021
- File name:  NSString+DecimalNumber.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DecimalNumber)

-(NSDecimalNumber*)decimalNumber;
//加
- (NSString *)calculateByAdding:(NSString *)stringNumer;
NSString *decimalNumbeAdding(NSString *value1, NSString *value2);
//减
- (NSString *)calculateBySubtracting:(NSString *)stringNumer;
NSString *decimalNumbeBySubtracting(NSString *value1, NSString *value2);
//乘
- (NSString *)calculateByMultiplying:(NSString *)stringNumer;
NSString *decimalNumbeByMultiplying(NSString *value1, NSString *value2);
//除
- (NSString *)calculateByDividing:(NSString *)stringNumer;
NSString *decimalNumbeByDividing(NSString *value1, NSString *value2);
//幂运算
- (NSString *)calculateByRaising:(NSUInteger)power;

/// 四舍五入
/// @param scale 保留的位数
- (NSString *)calculateByRounding:(NSUInteger)scale;
-(NSString*)nSRoundDownByScale:(NSUInteger)scale;
//是否相等
- (BOOL)calculateIsEqual:(NSString *)stringNumer;
//是否大于
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer;
//是否小于
- (BOOL)calculateIsLessThan:(NSString *)stringNumer;
//转成小数
- (double)calculateDoubleValue;
-(NSString *)decimal8Places;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 17/12/2021
- File name:  NSDecimalNumber+Calculate.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDecimalNumber (Calculate)
-(NSDecimalNumber*)calculateWithRoundingMode:(NSRoundingMode)roundingMode scale:(short)scale;

/// 向下取整
/// @param scale 保留多少位小数
-(NSDecimalNumber*)calculateByNSRoundDownScale:(short)scale;

-(NSString*)calculateByNSRoundDownScaleSpecial:(short)scale;
/// 四舍五入
/// @param scale 保留多少位小数
-(NSDecimalNumber*)calculateByRoundingScale:(short)scale;

/// 如果小数点后面没有数值 那么小数点后面保留两个0
-(NSString *)currencyString;
@end

NS_ASSUME_NONNULL_END

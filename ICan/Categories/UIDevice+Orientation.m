//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 10/5/2022
- File name:  UIDevice+Orientation.m
- Description:
- Function List:
*/
        

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)
+(void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    //  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    //    SEL selector = NSSelectorFromString(@"setOrientation:");
    //    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    //    [invocation setSelector:selector];
    //    [invocation setTarget:[UIDevice currentDevice]];
    //    int val = orientation;
    //    // 从2开始是因为0 1 两个参数已经被selector和target占用
    //    [invocation setArgument:&val atIndex:2];
    //    [invocation invoke];
    //  }
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
@end

//
/**
- Copyright © 2020 limao01. All rights reserved.
- Author: Created  by DZL on 24/11/2020
- File name:  UIViewController+Extension.m
- Description:
- Function List:
*/
        

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
-(void)removeVcWithArray:(NSArray<NSString *> *)vcArray{
    NSMutableArray*array=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController*vc in self.navigationController.viewControllers) {
        for (NSString*vcS in vcArray) {
            if ([vc isKindOfClass:NSClassFromString(vcS)]) {
                [array removeObject:vc];
            }
        }
    }
    self.navigationController.viewControllers=[array copy];
}
@end

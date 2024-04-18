//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/1/2021
- File name:  UITabBar+Extension.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Extension)
- (void)showBadgeOnItmIndex:(int)index tabbarNum:(int)tabbarNum;
-(void)hideBadgeOnItemIndex:(int)index;
- (void)removeBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END

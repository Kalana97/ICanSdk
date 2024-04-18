//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/12/2021
- File name:  C2CChangeOptionOrQuickPopView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2CChangeOptionOrQuickPopView : UIView
@property(nonatomic, copy) void (^optionBlock)(void);
@property(nonatomic, copy) void (^quickBlock)(void);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/7/2021
- File name:  PlayerProgressSlider.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerProgressSlider : UIView
/** 当前是否正在滑动 */
@property(nonatomic, assign) BOOL isSliding;
// 滑动百分比
@property (nonatomic, assign) CGFloat sliderPercent;
@property(nonatomic, copy) void (^valueChangeBlock)(double value);
@property (nonatomic, weak) IBOutlet UIView *view;
-(void)updateSliderWidth;
@end

NS_ASSUME_NONNULL_END

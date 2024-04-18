//
/**
- Copyright © 2020 dzl. All rights reserved.
- AUthor: Created  by DZL on 2020/2/22
- ICan
- File name:  DZProgressSlider.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RHSliderDirection) {
    
    RHSliderDirectionHorizonal = 0,
    RHSliderDirectionVertical  = 1
};
@interface DZProgressSlider : UIControl
// 最小值
@property (nonatomic, assign) CGFloat minValue;
// 最大值
@property (nonatomic, assign) CGFloat maxValue;
// 滑动值
@property (nonatomic, assign) CGFloat value;
// 滑动百分比
@property (nonatomic, assign) CGFloat sliderPercent;
// 缓冲的百分比
@property (nonatomic, assign) CGFloat progressPercent;
// 是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱
@property (nonatomic, assign) BOOL isSliding;
// 方向
@property (nonatomic, assign) RHSliderDirection direction;

- (instancetype)initWithFrame:(CGRect)frame direction:(RHSliderDirection)direction;
@end

NS_ASSUME_NONNULL_END

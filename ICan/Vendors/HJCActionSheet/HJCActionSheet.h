//
//  HJCActionSheet.h
//  wash
//  仿微信 ActionSheet
//
//  Created by weixikeji on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@class HJCActionSheet;

@protocol HJCActionSheetDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface HJCActionSheet : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id <HJCActionSheetDelegate> delegate;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<HJCActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithArrayDelegate:(id<HJCActionSheetDelegate>)delegate cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray*)array;
- (void)show;

/**
 *  更改button的 颜色 字体大小 是否
 */
- (void)setBtnTag:(NSInteger)tag TextColor:(UIColor *)color textFont:(CGFloat)font enable:(BOOL)enable;
-(void)coverClick;

@end

//
//  JKPickerView.h
//  OneChatAPP
//  picker选择器
//  Created by mac on 2017/2/14.
//  Copyright © 2017年 DW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKPickerView : NSObject

+(instancetype)sharedJKPickerView;
/**
 *  -- 设置pickView --
 */
- (UIPickerView *)setPickViewWithTarget:(id)target title:(NSString *)title leftItemTitle:(NSString *)leftTitle rightItemTitle:(NSString *)rightTitle leftAction:(SEL)leftAction rightAction:(SEL)rightAction dataArray:(NSArray *)dataArray dataBlock:(void(^)(id obj))dataBlock;

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)inComponent animated:(BOOL)animated;
/**
 *  移除pickView
 */
- (void)removePickView;

/**
 * 确定按钮
 */
- (void)sureAction;

@end

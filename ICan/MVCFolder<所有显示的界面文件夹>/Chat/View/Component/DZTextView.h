//
//  DZTextView.h
//  fortune
//
//  Created by lidazhi on 2019/1/3.
//  Copyright © 2019 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DZAttributeModel : NSObject

@property (nonatomic, copy,nullable) NSString *str;

@property (nonatomic, assign) NSRange range;

@end


@interface DZTextView : UITextView
@property (nonatomic,strong,nullable) NSArray *matchArray;
/**
 *  是否打开点击效果，默认是打开
 */

@property (nonatomic, assign) BOOL enabledTapEffect;
@property (nonatomic, assign) BOOL isTapAction;
@property (nonatomic, assign) BOOL isTapEffect;
@property (nonatomic,strong,nullable)  NSMutableDictionary *effectDic;
@property (nonatomic,strong,nullable) NSMutableArray * attributeStrings;
@property (nonatomic,copy)   void (^tapBlock)(NSString * string , NSRange range , NSInteger index);
@property (nonatomic,copy)   void (^longBlock)(BOOL islongPressUrl,NSString *string , NSRange range , NSInteger index);

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)yb_addAttributeTapActionWithStrings:(NSArray <NSString *> *_Nonnull)strings
                                 tapClicked:(void (^_Nullable) (NSString * _Nullable string , NSRange range , NSInteger index))tapClick;

@end
NS_ASSUME_NONNULL_END


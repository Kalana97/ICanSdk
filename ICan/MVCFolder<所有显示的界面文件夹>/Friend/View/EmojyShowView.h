//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  EmojyShowView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
@protocol EmojyShowViewDeleagete<NSObject>

@end
NS_ASSUME_NONNULL_BEGIN

@interface EmojyShowView : UIView
@property(nonatomic, copy) void (^selectEmojyBlock)(NSString*text);
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic, copy) void (^deleteBlock)(void);
@property(nonatomic, copy) void (^sendBlock)(void);
-(void)setSendButtonHidden:(BOOL)hidden;
/**
 当有文字的时候 修改删除和发送按钮的状态
 */
-(void)changeButtonUI:(BOOL)hasText;
@end

NS_ASSUME_NONNULL_END

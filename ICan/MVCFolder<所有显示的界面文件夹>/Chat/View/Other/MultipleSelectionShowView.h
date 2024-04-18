//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  multipleSelectionShowView.h
- Description: 当编辑多选的时候
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultipleSelectionShowView : UIView
@property(nonatomic, copy) void (^deleteButtonActionBlock)(void);
@property(nonatomic, copy) void (^transpondButtonActionBlock)(void);
@property(nonatomic, copy) void (^collectButtonActionBlock)(void);
@property(nonatomic, assign) BOOL enable;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@end

NS_ASSUME_NONNULL_END

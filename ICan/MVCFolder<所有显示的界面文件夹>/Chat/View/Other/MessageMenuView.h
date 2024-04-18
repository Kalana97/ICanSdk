//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MessageMenuView.h
- Description:长按消息 显示的View
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class MenuItem;
@class ReactItem;
@class ChatModel;
typedef NS_ENUM(NSInteger,MessageMenuViewType){
    MessageMenuViewTypeChatMessage,//聊天界面
    MessageMenuViewTypeTimelineContent,//长按朋友圈内容
    MessageMenuViewTypeTimelineComment,//长按朋友圈评论
    ReactionMenuViewMessage,
};
NS_ASSUME_NONNULL_BEGIN
@protocol MessageMenuViewDelegate <NSObject>

@optional
- (void)didClickMesageMenuViewDelegate:(MenuItem*)item;
- (void)didClickReactMenuItemDelegate:(ReactItem *)item;
@end

@interface MessageMenuView : UIView
/** 复制 */
@property(nonatomic, strong) MenuItem *copyMenuItem;
@property(nonatomic, strong) NSArray *menuItems;
@property(nonatomic, strong) NSArray *reactMenuItems;
@property(nonatomic, weak) id <MessageMenuViewDelegate> messageMenuViewDelegate;
@property(nonatomic, assign) MessageMenuViewType type;
@property(nonatomic, assign) BOOL needReactionMenu;
- (void)showMessageMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView  ChatModel:(ChatModel*)chatModel showTime:(BOOL)isShowTime;
- (void)showReactionMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView  ChatModel:(ChatModel*)chatModel showTime:(BOOL)isShowTime;
/// 长按朋友圈文字 显示弹框
/// @param originView
/// @param convertRectView convertRectView description
- (void)showTimelineMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView;
/** 长按评论 */
- (void)showTimelineCommentMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView isMine:(BOOL)isMine showTranslate:(BOOL)showTranslate isShowOrigin:(BOOL)isShowOrigin;
- (void)hiddenMessageMenuView;

@end

NS_ASSUME_NONNULL_END

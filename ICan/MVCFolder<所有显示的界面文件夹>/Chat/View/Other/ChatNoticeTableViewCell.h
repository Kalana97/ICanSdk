//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 26/9/2019
- File name:  ChatNoticeTableViewCell.h
- Description: 用来展示通知类型的消息
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "QMUITableViewCell.h"
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN
static NSString* const KChatNoticeTableViewCell = @"ChatNoticeTableViewCell";
@interface ChatNoticeTableViewCell : QMUITableViewCell
@property(nonatomic, strong) ChatModel *chatModel;
/** 用来分割时间的cell（例如昨天今天） */
@property(nonatomic, strong) UIView *segmentationBgView;
@property(nonatomic, strong) UIView *leftLineView;
@property(nonatomic, strong) UIView *rightLineView;
@property(nonatomic, strong) UILabel *segmentationTimeLabel;
/** 作用是显示昨天今天 */
@property(nonatomic, assign) BOOL isShowSegmentationTime;

- (void)setcurrentChatModel:(ChatModel *)currentChatModel;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- Author: Created  by DZL on 8/10/2019
- File name:  ChatDetailViewController.h
- Description: 聊天详情页
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailViewController : QDCommonViewController
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) void (^deleteMessageBlock)(void);
@property (nonatomic,copy) void (^selectDestorytimeBlock)(ChatModel*model);

/// 点击了截屏通知的开关回调
@property (nonatomic,copy) void (^clickScreenNoticeBlock)(ChatModel*model);
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@property(nonatomic, copy) NSString *chatMode;
@property(nonatomic, copy) NSString *typeAi;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 25/12/2019
- File name:  ChatListSearchViewController.h
- Description:
- Function List:
*/
        
/**
 聊天列表点击头部搜索框跳转的搜索界面
 */
#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatListSearchViewController : QDCommonTableViewController

@property(nonatomic, copy) void (^tapBlock)(NSString*chatId,NSString*chatType);
@end

NS_ASSUME_NONNULL_END

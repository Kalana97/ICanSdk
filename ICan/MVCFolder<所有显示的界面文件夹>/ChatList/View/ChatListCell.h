//
//  ChatListCell.h
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/12.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@class ChatListModel;
@class ChatModel;
static NSString* const kChatListCell = @"ChatListCell";
static CGFloat const kChatListCellHeight = 80;
@interface ChatListCell : BaseCell
@property (nonatomic, strong) ChatListModel *chatListModel; //消息模型

@end

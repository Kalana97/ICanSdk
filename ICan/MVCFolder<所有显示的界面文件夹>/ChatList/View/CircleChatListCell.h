//
//  ChatListCell.h
//  CocoaAsyncSocket_TCP
//
//  Created by 孟遥 on 2017/5/12.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "CircleChatListCell.h"
#import "WCDBManager+ChatList.h"
@class ChatModel;
static NSString* const kCircleChatListCell = @"CircleChatListCell";
static CGFloat const kCircleChatListCellHeight = 80;
@interface CircleChatListCell : BaseCell
@property (nonatomic, strong) ChatListModel *chatListModel; //消息模型

@end

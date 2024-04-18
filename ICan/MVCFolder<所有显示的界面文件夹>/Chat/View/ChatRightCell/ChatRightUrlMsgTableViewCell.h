//
//  ChatRightUrlMsgTableViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2022-12-22.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightUrlMsgTableViewCell = @"ChatRightUrlMsgTableViewCell";
@interface ChatRightUrlMsgTableViewCell : ChatRightMsgBaseTableViewCell
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, assign) BOOL shouldHightShow;
@property(nonatomic, assign) BOOL seeMoreBtnFlag;
@property(nonatomic, assign) BOOL longpressStatus;
@property(copy, nonatomic) void (^resetBlock)(void);
@end

NS_ASSUME_NONNULL_END

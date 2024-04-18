//
//  ChatLeftTxtMsgTableViewCell.h
//  ICan
//
//  Created by dzl on 23/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"
#import "ReactionBar.h"
@class MenuItem;
NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightTxtMsgTableViewCell = @"ChatRightTxtMsgTableViewCell";
@interface ChatRightTxtMsgTableViewCell : ChatRightMsgBaseTableViewCell
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, assign) BOOL timeLableFlag;
@property(nonatomic, strong) ReactionBar *reactionBar;
/** 是否应该高亮显示 */
@property(nonatomic, assign) BOOL shouldHightShow;
@property(nonatomic, assign) BOOL longpressStatus;

@end

NS_ASSUME_NONNULL_END

//
//  ChatLeftTxtMsgTableViewCell.h
//  ICan
//
//  Created by dzl on 23/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftMsgBaseTableViewCell.h"

@class MenuItem;
NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatLeftTxtMsgTableViewCell = @"ChatLeftTxtMsgTableViewCell";
@interface ChatLeftTxtMsgTableViewCell : ChatLeftMsgBaseTableViewCell
@property(nonatomic, copy) NSString *searchText;
@property(nonatomic, assign) BOOL timeLableFlag;
@property(nonatomic, assign) BOOL longpressStatus;
/** 是否应该高亮显示 */
@property(nonatomic, assign) BOOL shouldHightShow;

@end

NS_ASSUME_NONNULL_END

//
//  ChatLeftTimelineTableViewCell.h
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightTimelineTableViewCell = @"ChatRightTimelineTableViewCell";
@interface ChatRightTimelineTableViewCell : ChatRightMsgBaseTableViewCell
@property(nonatomic, assign) BOOL longpressStatus;
@end

NS_ASSUME_NONNULL_END

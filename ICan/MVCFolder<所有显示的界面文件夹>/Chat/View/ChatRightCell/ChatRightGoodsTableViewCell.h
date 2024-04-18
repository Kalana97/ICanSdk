//
//  ChatLeftGoodsTableViewCell.h
//  ICan
//
//  Created by dzl on 25/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightGoodsTableViewCell = @"ChatRightGoodsTableViewCell";
@interface ChatRightGoodsTableViewCell : ChatRightMsgBaseTableViewCell
@property(nonatomic, assign) BOOL longpressStatus;
@end

NS_ASSUME_NONNULL_END

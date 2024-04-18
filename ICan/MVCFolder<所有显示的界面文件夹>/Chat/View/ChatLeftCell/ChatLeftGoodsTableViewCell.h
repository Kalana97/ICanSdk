//
//  ChatLeftGoodsTableViewCell.h
//  ICan
//
//  Created by dzl on 25/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatLeftGoodsTableViewCell = @"ChatLeftGoodsTableViewCell";
@interface ChatLeftGoodsTableViewCell : ChatLeftMsgBaseTableViewCell
@property(nonatomic, assign) BOOL longpressStatus;
@end

NS_ASSUME_NONNULL_END

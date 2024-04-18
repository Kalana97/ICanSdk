//
//  ChatLeftVoiceTableViewCell.h
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static  NSString * const kChatLeftVoiceTableViewCell = @"ChatLeftVoiceTableViewCell";
@interface ChatLeftVoiceTableViewCell : ChatLeftMsgBaseTableViewCell
@property(nonatomic, assign) XMNVoiceMessageState voiceMessageState;
@property(nonatomic, assign) BOOL longpressStatus;
@end

NS_ASSUME_NONNULL_END

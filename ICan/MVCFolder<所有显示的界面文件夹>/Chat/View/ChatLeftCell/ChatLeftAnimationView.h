//
//  ChatLeftAnimationView.h
//  ICan
//
//  Created by Kalana Rathnayaka on 16/02/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ChatLeftMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatLeftGamifyMsgTableViewCell = @"ChatLeftAnimationView";
@interface ChatLeftAnimationView : ChatLeftMsgBaseTableViewCell
@property(nonatomic, strong) ChatModel *imageModel;
@property(nonatomic, assign) BOOL gameImage;
@property(nonatomic, copy) NSString *imgName;
@property(nonatomic, assign) BOOL isAnimated;
@end
NS_ASSUME_NONNULL_END


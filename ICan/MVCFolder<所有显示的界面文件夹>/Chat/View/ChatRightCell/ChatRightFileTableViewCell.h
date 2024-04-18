//
//  ChatLeftFileTableViewCell.h
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kChatRightFileTableViewCell = @"ChatRightFileTableViewCell";
@interface ChatRightFileTableViewCell : ChatRightMsgBaseTableViewCell
//这里使用weak 是因为导致了循环引用
@property(nonatomic,weak) UIViewController *fileContainerView;
@property(nonatomic, strong) ChatModel *fileModel;
@property(nonatomic, assign) BOOL longpressStatus;
@end

NS_ASSUME_NONNULL_END

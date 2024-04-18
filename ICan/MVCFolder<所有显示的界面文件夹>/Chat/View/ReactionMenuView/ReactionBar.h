//
//  ReactionBar.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-17.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ReactionBarDelegate <NSObject>
- (void)tapOnReactionBar;
@end

@interface ReactionBar : UIView
@property(nonatomic, weak) id <ReactionBarDelegate>reactionBarDelegate;
@property(nonatomic, strong) ChatModel *chatModel;
- (void)setReactions:(ChatModel *)model;
@end

NS_ASSUME_NONNULL_END

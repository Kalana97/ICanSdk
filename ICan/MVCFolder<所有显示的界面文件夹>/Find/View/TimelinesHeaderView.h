//
//  TimelinesHeaderView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/4.
//  Copyright © 2020 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimelinesHeaderView : UIView
@property(copy,nonatomic) void(^videoTapHandle)(void);
@property(copy,nonatomic) void(^shareTapHandle)(void);
@property(copy,nonatomic) void(^friendTapHandle)(void);
@property(copy,nonatomic) void(^publishVideoTapHandle)(void);
@property(copy,nonatomic) void(^publishShareTapHandle)(void);
@property(copy,nonatomic) void(^publishFriendTapHandle)(void);
@end

NS_ASSUME_NONNULL_END

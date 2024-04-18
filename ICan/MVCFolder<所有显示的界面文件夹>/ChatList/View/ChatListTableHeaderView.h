//
//  WGChatListTableHeaderView.h
//  ICan
//
//  Created by limaohuyu on 2022/4/21.
//  Copyright © 2022 dzl. All rights reserved.
// tableview的头部 如果继承View 那么高度无论如何设置都不会起作用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListTableHeaderView : UITableViewCell
@property(nonatomic, copy) void (^searchCallBack)(void);
@property(nonatomic, copy) void (^nearCallBack)(void);
@end

NS_ASSUME_NONNULL_END

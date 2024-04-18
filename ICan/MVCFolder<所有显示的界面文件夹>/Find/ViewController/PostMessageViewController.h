//
//  PostMessageViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface PostMessageViewController : BaseViewController
/** 发送帖子成功回调 */
@property(nonatomic,copy) void(^postMessageSucessBlock)(void);

@property(nonatomic,assign) PostMessageType postMessageType;

@end

NS_ASSUME_NONNULL_END

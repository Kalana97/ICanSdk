//
//  TranferAllFriendsViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/7.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranferAllFriendsViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectBlock)(UserMessageInfo*info);
@end

NS_ASSUME_NONNULL_END

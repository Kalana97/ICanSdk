//
//  WatchList.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableListViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface WatchList : QDCommonTableViewController
@property (nonatomic,copy) void (^viewPageBlock)(WatchWalletListInfo *modelData);
@end

NS_ASSUME_NONNULL_END

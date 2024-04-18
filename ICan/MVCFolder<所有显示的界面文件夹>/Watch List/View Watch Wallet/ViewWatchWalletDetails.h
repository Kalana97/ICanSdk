//
//  ViewWatchWalletDetails.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-12.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewWatchWalletDetails : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong, nullable) WatchWalletListInfo *walletModel;
@property(nonatomic, assign) BOOL isFromPageViewController;
@end

NS_ASSUME_NONNULL_END

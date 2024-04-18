//
//  ViewWalletVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewWalletVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) WatchWalletListInfo *walletModel;
@end

NS_ASSUME_NONNULL_END

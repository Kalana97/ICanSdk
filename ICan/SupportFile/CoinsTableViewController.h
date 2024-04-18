//
//  CoinsTableViewController.h
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableListViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoinsTableViewController : BaseTableListViewController <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@end

NS_ASSUME_NONNULL_END

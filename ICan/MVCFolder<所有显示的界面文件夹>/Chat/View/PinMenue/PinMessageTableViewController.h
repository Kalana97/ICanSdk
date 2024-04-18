//
//  PinMessageTableViewController.h
//  ICan
//
//  Created by apple on 28/06/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PinMessageTableViewController : QDCommonTableViewController
@property(nonatomic, strong) NSMutableArray<ChatModel *> *messagesArray;

@end

NS_ASSUME_NONNULL_END

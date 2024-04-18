//
//  AssignUsersVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssignUsersVC : BaseViewController <UITableViewDelegate, UITableViewDataSource,QMUITextFieldDelegate>
@property (nonatomic,copy) void (^goBackData)(NSArray<MemebersResponseInfo*> *selectedUsers);
@end

NS_ASSUME_NONNULL_END

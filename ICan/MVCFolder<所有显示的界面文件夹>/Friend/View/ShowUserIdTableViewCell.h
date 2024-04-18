//
//  ShowUserIdTableViewCell.h
//  OneChatAPP
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
static NSString * const kShowUserIdTableViewCell= @"ShowUserIdTableViewCell";

@interface ShowUserIdTableViewCell : BaseCell
@property (nonatomic,copy) void (^tapQrBlock)(void);

@end

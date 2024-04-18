//
//  AddFriendDefaultTableViewCell.h
//  OneChatAPP
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSettingItem.h"
static NSString * const kAddFriendDefaultTableViewCell= @"AddFriendDefaultTableViewCell";

@interface AddFriendDefaultTableViewCell : UITableViewCell


@property (nonatomic,strong) ImageSettingItem* imageSettingItem;
@end

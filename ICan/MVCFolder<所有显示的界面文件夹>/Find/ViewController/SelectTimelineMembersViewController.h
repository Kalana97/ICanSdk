//
//  SelectMembersViewController.h
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QDCommonTableViewController.h"

@class UserMessageInfo;
@interface SelectTimelineMembersViewController : QDCommonTableViewController

/** @人之后选择的 */
@property (nonatomic,copy) void (^addTimelinesAtMemberSuccessBlock)(NSArray<UserMessageInfo*> * atArray);

@property(nonatomic, strong) NSArray<NSString*> *userIds;
/** 已经选择的用户 */
@property(nonatomic, strong) NSArray<UserMessageInfo*> *selectUsers;

@end


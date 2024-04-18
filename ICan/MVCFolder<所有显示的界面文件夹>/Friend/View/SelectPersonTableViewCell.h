//
//  SelectPersonTableViewCell.h
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
static CGFloat const KHeightSelectPersonTableViewCell=55;
static NSString * const kSelectPersonTableViewCell = @"SelectPersonTableViewCell";
@interface SelectPersonTableViewCell : BaseCell


@property (nonatomic,strong)GroupMemberInfo * groupMemberInfo;
@property (nonatomic,strong) UserMessageInfo*userMessageInfo;
@property (nonatomic,copy)  void (^buttonBlock)(void);
@property(nonatomic,strong)GroupMemberInfo * settingGroupRoleGroupMemberInfo;
@property(nonatomic,assign)BOOL settingGroupRoleSelect;
@end

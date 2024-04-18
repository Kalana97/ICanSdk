//
//  TimelinesViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/4.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseTableListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TypeTimelinesViewController : BaseTableListViewController
@property(nonatomic, assign) TimelineType timelineType;

@property (nonatomic,copy)   NSString * userId;
@property(nonatomic, strong) UserMessageInfo *usermessageInfo;

@end

NS_ASSUME_NONNULL_END

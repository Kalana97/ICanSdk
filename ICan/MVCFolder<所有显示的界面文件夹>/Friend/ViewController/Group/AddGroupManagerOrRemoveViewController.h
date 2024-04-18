//
//  AddGroupManagerOrRemoveViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/11.
//  Copyright © 2020 dzl. All rights reserved.
//
/**
 设置群管理或者移除群管理的界面
 */
#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddGroupManagerOrRemoveViewController : QDCommonTableViewController
@property(nonatomic, strong) NSArray<GroupMemberInfo*> *allMemberItems;
@property(nonatomic, strong) GroupListInfo *groupDetailInfo;
@property(nonatomic,copy) void(^sucessSettingManagerBlock)(void);
@property(nonatomic,assign) BOOL isAddManager;
@property(nonatomic,assign) BOOL isAddMuteManager;
@property(nonatomic,assign) BOOL isRemoveMuteManager;
@end

NS_ASSUME_NONNULL_END

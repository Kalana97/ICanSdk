//
//  SelectMembersViewController.h
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDCommonTableViewController.h"

typedef NS_ENUM(NSInteger,SelectMembersType) {
    SelectMembersType_ChatDetail=0,//来自聊天详情创建新群聊
    SelectMembersType_addMember,//添加群成员
    SelectMembersType_chatList,//来自会话列表页面创建新群聊
    SelectMenbersType_kickOut, //踢人出群
    SelectMenbersType_Timelines,//朋友圈@ren
    SelectMenbersType_Transpond//转发页面进来的可以创建新的群聊 或者是选择群聊
};

@interface SelectMembersViewController : QDCommonTableViewController
/** 成功创建群聊 */
@property(nonatomic,copy) void (^createGroupSuccessBlock)(NSString*groupId,NSString*groupName);
/** 拉人成功block */
@property(nonatomic,copy) void (^addMemberSuccessBlock)(ChatModel*model);
/** 踢人成功block */
@property(nonatomic,copy) void (^quitMemberSuccessBlock)(ChatModel*model);
/** 从聊天列表创建群聊的时候，选择一个人，点击完成的block */
@property(nonatomic,copy) void (^chatWithFriendSuccessBlock)(ChatModel*model);
//朋友圈@人
@property(nonatomic,copy) void (^addTimelinesAtMemberSuccessBlock)(NSArray * atArray);
/**
 从转发页面跳转过来 点击选择了某些人
 */
@property(nonatomic, copy)    void (^transpondBlock)(NSArray*selectForwardUsersArr);

@property(nonatomic, copy)    NSString * groupId;
@property(nonatomic, strong)  GroupListInfo *groupDetailInfo;

@property(nonatomic,assign)   SelectMembersType selectMemberType;

/** 踢人的时候传进来的数组  */
@property(nonatomic,strong)   NSMutableArray<GroupMemberInfo*> *removeInGroupMembers;

/** 在群详情点击+号 邀请人进群  */
@property(nonatomic,strong)   NSArray<GroupMemberInfo*> * inGroupMember;

/**从聊天详情页面传进来的当前聊天对象    */
@property(nonatomic, strong)  UserMessageInfo *userMessageInfo;

/**
 当前选择的已经@的人
 */
@property(nonatomic, strong) NSArray<UserMessageInfo*> *currentSelectAtUser;


@property(nonatomic, copy)   void (^cancelBlock)(void);


@end


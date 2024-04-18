//
//  AddGroupManagerOrRemoveViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/11.
//  Copyright © 2020 dzl. All rights reserved.
//  设置群管理或者移除群管理的界面

#import "AddGroupManagerOrRemoveViewController.h"
#import "FriendListTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "SelectPersonTableViewCell.h"
#import "FriendListFirstHeaderView.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
@interface AddGroupManagerOrRemoveViewController ()
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property(nonatomic, strong) NSMutableArray *searchResultArray;

@property(nonatomic,strong)GroupMemberInfo * groupMemberInfo;

@end

@implementation AddGroupManagerOrRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isAddManager) {
        if(self.isAddMuteManager == YES){
            self.title = @"Add to restricted list".icanlocalized;
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"Add".icanlocalized target:self action:@selector(sureAction)];
        }else{
            self.title = NSLocalizedString(@"AdministratorSettings", 设置管理员);
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:[@"AddGroupManagerOrRemoveViewController.rightBarItem" icanlocalized:@"设置"] target:self action:@selector(sureAction)];
        }
    }else{
        if(self.isRemoveMuteManager == YES){
            self.title = @"Remove from restricted list".icanlocalized;
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"Remove".icanlocalized target:self action:@selector(sureAction)];
        }else{
            self.title = NSLocalizedString(@"Remove manager", 移除管理员);
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:[@"AddGroupManagerOrRemoveViewController.rightBarItem" icanlocalized:@"设置"] target:self action:@selector(sureAction)];
        }
    }
}

-(void)sureAction{
    if (!self.groupMemberInfo.isSelect) {
        if (self.isAddManager) {
            
            [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Please select a manager to add", 请选择要添加的管理员) inView:self.view];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Please select a manager to remove", 请选择要移除的管理员) inView:self.view];
        }
        return;
    }
    NSString * name;
    UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.groupMemberInfo.userId];
    if (messageInfo.isFriend) {
        name = messageInfo.remarkName?:self.groupMemberInfo.groupRemark?:self.groupMemberInfo.nickname;
    }else{
        name = self.groupMemberInfo.groupRemark?:self.groupMemberInfo.nickname;
    }
    
    NSString * tips;
    if (self.isAddManager) {
        if(self.isAddMuteManager == YES){
            tips = [NSString stringWithFormat:@"%@\"%@\"%@", NSLocalizedString(@"Are you sure you set", 你确认把),name,NSLocalizedString(@"as Mute?", 设置为管理员?)];
        }else{
            tips = [NSString stringWithFormat:@"%@\"%@\"%@", NSLocalizedString(@"Are you sure you set", 你确认把),name,NSLocalizedString(@"as an administrator?", 设置为管理员?)];
        }
    }else{
        if(self.isRemoveMuteManager == YES){
            tips = [NSString stringWithFormat:@"%@\"%@\"%@",NSLocalizedString(@"Are you sure to remove", 你确认把),name,NSLocalizedString(@"from the Mute list?", 从管理员列表中移除?)];
        }else{
            tips = [NSString stringWithFormat:@"%@\"%@\"%@",NSLocalizedString(@"Are you sure to remove", 你确认把),name,NSLocalizedString(@"from the administrator list?", 从管理员列表中移除?)];
        }
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tips message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"CommonButton.Confirm".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self settingGroupOwnerRequest];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    if (self.isAddManager) {
        if(self.isAddMuteManager == YES){
            [self settingGroupOwnerRequest];
        }else{
            [self presentViewController:alertVC animated:YES completion:^{}];
        }
    }else{
        if(self.isRemoveMuteManager == YES){
            [self settingGroupOwnerRequest];
        }else{
            [self presentViewController:alertVC animated:YES completion:^{}];
        }
    }
}

-(void)initTableView{
    [super initTableView];
    NSMutableArray * itmes = [NSMutableArray arrayWithArray:self.allMemberItems];
    for (GroupMemberInfo * info in self.allMemberItems) {
        info.isSelect=NO;
        if ([info.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
            [itmes removeObject:info];
        }
    }
    [self sortFriens:itmes];
    [self.tableView registerNib:[UINib nibWithNibName:kSelectPersonTableViewCell bundle:nil] forCellReuseIdentifier:kSelectPersonTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightSelectPersonTableViewCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kSelectPersonTableViewCell];
    cell.settingGroupRoleGroupMemberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    @weakify(self);
    cell.buttonBlock = ^{
        @strongify(self);
        GroupMemberInfo*memberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        for (NSArray*array in self.letterResultArr) {
            for (GroupMemberInfo*dMemberInfo in array) {
                if (![dMemberInfo.userId isEqualToString:memberInfo.userId]) {
                    dMemberInfo.isSelect=NO;
                }
            }
        }
        memberInfo.isSelect=!memberInfo.isSelect;
        self.groupMemberInfo =memberInfo ;
        [self.tableView reloadData];
        
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberInfo*memberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    for (NSArray*array in self.letterResultArr) {
        for (GroupMemberInfo*dMemberInfo in array) {
            if (![dMemberInfo.userId isEqualToString:memberInfo.userId]) {
                dMemberInfo.isSelect=NO;
            }
        }
    }
    memberInfo.isSelect=!memberInfo.isSelect;
    self.groupMemberInfo =memberInfo ;
    [self.tableView reloadData];
    
}



-(void)sortFriens:(NSArray*)friendListCoreDataArray{
    NSMutableDictionary*friendDict=[NSMutableDictionary dictionary];
    for (GroupMemberInfo * userMessageInfo in friendListCoreDataArray) {
        NSMutableArray*array=[friendDict objectForKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?userMessageInfo.groupRemark:userMessageInfo.nickname]];
        if (!array) {
            array=[NSMutableArray array];
            [friendDict setObject:array forKey:[NSString firstCharactorWithString:userMessageInfo.groupRemark?userMessageInfo.groupRemark:userMessageInfo.nickname]];
        }
        [array addObject:userMessageInfo];
    }
    //获取排序之后的字母
    NSArray *sortArray=  [friendDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexArray=[NSMutableArray arrayWithArray:sortArray];
    self.letterResultArr=[NSMutableArray array];
    if ([sortArray containsObject:@"#"]) {
        [self.indexArray removeObject:@"#"];
        [self.indexArray addObject:@"#"];
    }
    
    for (NSString * key in self.indexArray) {
        
        [self.letterResultArr addObject:[friendDict objectForKey:key]];
    }
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    self.tableView.sc_indexViewConfiguration = configuration;
    [self.searchController.tableView reloadData];
    [self.tableView reloadData];
    
}
-(NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray=[NSMutableArray array];
    }
    return _searchResultArray;
}


-(void)settingGroupOwnerRequest{
    if(self.isAddMuteManager == YES){
        MuteUserSettingGroupRequest *request = [MuteUserSettingGroupRequest request];
        request.groupId = [self.groupDetailInfo.groupId intValue] ;
        request.userToMute = [self.groupMemberInfo.userId intValue];
        request.mute = true;
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            if (self.sucessSettingManagerBlock) {
                self.sucessSettingManagerBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter ]postNotificationName:kUpdateGroupMessageNotification object:self.groupDetailInfo.groupId];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else if(self.isRemoveMuteManager == YES){
        MuteUserSettingGroupRequest *request = [MuteUserSettingGroupRequest request];
        request.groupId = [self.groupDetailInfo.groupId intValue] ;
        request.userToMute = [self.groupMemberInfo.userId intValue];
        request.mute = false;
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            if (self.sucessSettingManagerBlock) {
                self.sucessSettingManagerBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter ]postNotificationName:kUpdateGroupMessageNotification object:self.groupDetailInfo.groupId];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else{
        SettingGroupOwnerOrManagerRequest *request = [SettingGroupOwnerOrManagerRequest request];
        request.groupId = self.groupDetailInfo.groupId;
        request.userId = self.groupMemberInfo.userId;
        if (self.isAddManager) {
            request.groupRole = @"Manager";
        }else{
            request.groupRole = @"Member";
        }
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            if (self.sucessSettingManagerBlock) {
                self.sucessSettingManagerBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter ]postNotificationName:kUpdateGroupMessageNotification object:self.groupDetailInfo.groupId];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}

@end

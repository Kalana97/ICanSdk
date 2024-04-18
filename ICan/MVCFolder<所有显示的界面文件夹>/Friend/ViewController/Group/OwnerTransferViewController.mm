//
//  OwnerTransferViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/11.
//  Copyright © 2020 dzl. All rights reserved.
//  群主转让界面

#import "OwnerTransferViewController.h"

#import "UITableView+SCIndexView.h"
#import "SelectPersonTableViewCell.h"
#import "FriendListFirstHeaderView.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
@interface OwnerTransferViewController ()

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property(nonatomic, strong) NSMutableArray *searchResultArray;

@property(nonatomic,strong) GroupMemberInfo * groupMemberInfo;

@end

@implementation OwnerTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Transfer owner", 转让群主);
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"transfer".icanlocalized target:self action:@selector(sureAction)];
}

-(void)sureAction{
    if (!self.groupMemberInfo.isSelect) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Please select the owner to transfer", 请选择要转让的群主) inView:self.view];
        return;
    }
    NSString * name;
    UserMessageInfo*messageInfo= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.groupMemberInfo.userId];
    if (messageInfo.isFriend) {
        name = messageInfo.remarkName?:self.groupMemberInfo.groupRemark?:self.groupMemberInfo.nickname;
    }else{
        name = self.groupMemberInfo.groupRemark?:self.groupMemberInfo.nickname;
    }
    if (BaseSettingManager.isChinaLanguages) {
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@?",NSLocalizedString(@"Are you sure to transfer the owner to", 你确认把群主转让给),name] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self settingGroupOwnerRequest];
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Confirm the ownership transfer to %@",name] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"CommonButton.Confirm".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self settingGroupOwnerRequest];
        }];
        
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }
    
    
}
-(void)initTableView{
    [super initTableView];
    NSMutableArray * itmes = [NSMutableArray arrayWithArray:self.allMemberItems];
    for (GroupMemberInfo * info in self.allMemberItems) {
        info.isSelect=NO;
        info.canEnabled = YES;
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
        memberInfo.isSelect = !memberInfo.isSelect;
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
    
    SettingGroupOwnerOrManagerRequest * request = [SettingGroupOwnerOrManagerRequest request];
    request.groupId =self.groupDetailInfo.groupId;
    request.userId = self.groupMemberInfo.userId;
    request.groupRole = @"Owner";
    
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        if (self.sucessSettingOwnerBlock) {
            self.sucessSettingOwnerBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}


@end

//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletTransferTableViewController.m
 - Description:
 - Function List:
 */


#import "IcanWalletTransferInputUserTableViewController.h"
#import "IcanWalletTransferTableCell.h"
#import "IcanWalletTransferHeadView.h"
#import "IcanWalletTransferInputMoneyViewController.h"
#import "IcanWalletReceiveViewController.h"
#import "FriendDetailViewController.h"
@interface IcanWalletTransferInputUserTableViewController ()
@property(nonatomic, strong) IcanWalletTransferHeadView *headView;
@property(nonatomic, strong) NSArray<C2CTransferHistoryInfo*> *historyItems;
@property(nonatomic, strong) NSArray<UserMessageInfo*> *usersList;
@property(nonatomic, strong) NSMutableArray<NSString*> *idList;
@property (weak, nonatomic) IBOutlet UIButton *dongBtn;
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@end

@implementation IcanWalletTransferInputUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeight.constant = NavBarHeight;
    self.centerTitleLbl.text = @"Transfer".icanlocalized;
    [self getC2CTransferHistoryRequest];
    [self.dongBtn setTitle:@"C2CWalletReceive".icanlocalized forState:UIControlStateNormal];
}
-(IBAction)backAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}
-(IBAction)receiveAction{
    IcanWalletReceiveViewController * vc = [[IcanWalletReceiveViewController alloc]init];
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kIcanWalletTransferTableCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
}
-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.usersList.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kheightIcanWalletTransferTableCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanWalletTransferTableCell*cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletTransferTableCell];
    cell.recentTransactions = true;
    cell.shoulShowAddFriend = true;
    cell.addBlock = ^(UserMessageInfo * _Nonnull userMessageInfo) {
        [self pushToFriendDetail:userMessageInfo];
    };
    cell.historyInfo = self.usersList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanWalletTransferInputMoneyViewController *vc = [[IcanWalletTransferInputMoneyViewController alloc]init];
    UserMessageInfo *info = self.usersList[indexPath.row];
    vc.numberId = info.numberId;
    vc.userId = info.userId;
    vc.nickname = info.nickname;
    vc.balanceInfo = self.balanceInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToFriendDetail:(UserMessageInfo*)userInfo{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = userInfo.userId;
    vc.friendDetailType =FriendDetailType_push;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IcanWalletTransferHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletTransferHeadView" owner:self options:nil].firstObject;
        @weakify(self);
        _headView.sureBlcok = ^(NSString *  type, NSString *  account, NSString *  mobileCode) {
            @strongify(self);
            [self getUserInfoRequestByAccuracyRequest:type account:account mobileCode:mobileCode];
        };
    }
    return _headView;
}

-(void)getUserInfoRequestByAccuracyRequest:(NSString*)type account:(NSString*)account mobileCode:(NSString*)mobileCode{
    GetUserInfoRequestByAccuracyRequest *request = [GetUserInfoRequestByAccuracyRequest request];
    if ([type isEqualToString:@"email"]) {
        request.mail = account;
    }else if ([type isEqualToString:@"mobile"]){
        request.mobile = account;
        request.area = mobileCode;
    }else{
        request.numberId = account;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        if (response) {
            if (![response.userId isEqualToString:UserInfoManager.sharedManager.userId]) {
                IcanWalletTransferInputMoneyViewController *vc = [[IcanWalletTransferInputMoneyViewController alloc]init];
                vc.numberId = response.numberId;
                vc.nickname = response.nickname;
                vc.userId = response.userId;
                vc.balanceInfo = self.balanceInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"CannotTransferMyself".icanlocalized inView:self.view];
            }
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"userdoesnotexist".icanlocalized inView:self.view];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)getC2CTransferHistoryRequest{
    C2CTransferHistoryRequest * request = [C2CTransferHistoryRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CTransferHistoryInfo class] success:^(NSArray*  response) {
        self.historyItems = response;
        [self addDataToArrayFromModelArray];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

-(void)addDataToArrayFromModelArray{
    for (C2CTransferHistoryInfo *userData in self.historyItems) {
        if(userData.uid != nil){
            [self.idList addObject:userData.uid];
        }
    }
    [self getDataWithFriendStatus];
}

-(void)getDataWithFriendStatus{
    GetUserListRequest *request = [GetUserListRequest request];
    request.parameters = [self.idList mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*> *response) {
        self.usersList = response;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSLog(@"Errror");
    }];
}

-(NSMutableArray<NSString *> *)idList{
    if (!_idList) {
        _idList=[NSMutableArray array];
    }
    return _idList;
}

@end

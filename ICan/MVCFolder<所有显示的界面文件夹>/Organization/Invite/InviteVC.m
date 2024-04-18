//
//  InviteVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "InviteVC.h"
#import "InviteUserCardWithOTPCell.h"
#import "InviteUserCardCell.h"
#import "QRCodeController.h"
#import "ContactListVC.h"
#import "ReinviteCell.h"

@interface InviteVC ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *scanQrBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *scanQRLbl;
@property (weak, nonatomic) IBOutlet UILabel *contactsLbl;
@property (weak, nonatomic) IBOutlet UIButton *searchQRBtn;
@property (weak, nonatomic) IBOutlet UIView *contctBg;
@property(nonatomic, strong) SearchUserInfo *searchUserInfo;
@property(nonatomic, strong) NSMutableArray<MemebersResponseInfo *> *invitedUsersInfo;
@property(nonatomic, strong) NSMutableArray<MemebersResponseInfo *> *resendUsersInfo;
@property(nonatomic, strong) InviteResponseInfo *inviteInfo;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *inviteeList;

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"InviteUserCardWithOTPCell"];
    [self.myTableView registNibWithNibName:@"InviteUserCardCell"];
    [self.myTableView registNibWithNibName:@"ReinviteCell"];
    self.searchTxt.delegate = self;
    self.searchTxt.returnKeyType = UIReturnKeySearch;
    UIColor *color = [UIColor grayColor];
    self.searchTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search".icanlocalized attributes:@{NSForegroundColorAttributeName: color}];
    [self addLocalizations];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.searchTxt resignFirstResponder];
}

-(void)addLocalizations{
    self.titleLbl.text = @"Invite People".icanlocalized;
    self.scanQRLbl.text = @"Scan QR Code".icanlocalized;
    self.contactsLbl.text = @"chatlist.menu.list.contacts".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getInvitedUsersRequest];
}

-(void)getAllData{
    self.searchUserInfo = nil ;
    [self getInvitedUsersRequest];
}

-(void)getInvitedUsersRequest{
    [self.invitedUsersInfo removeAllObjects];
    [self.resendUsersInfo removeAllObjects];
    NSPredicate *otpValidPredicate = [NSPredicate predicateWithFormat:@"inviteType == %@", @(1)];
    NSPredicate *otpExpiredPredicate = [NSPredicate predicateWithFormat:@"inviteType == %@", @(2)];
    GetInvitedOTPUsers *request = [GetInvitedOTPUsers request];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemebersResponseInfo class] success:^(NSArray *response) {
        [QMUITips hideAllTips];
        NSArray *otpValidUsersArray = [response filteredArrayUsingPredicate:otpValidPredicate];
        NSArray *otpExpUsersArray = [response filteredArrayUsingPredicate:otpExpiredPredicate];
        [self.invitedUsersInfo addObjectsFromArray:otpValidUsersArray];
        [self.resendUsersInfo addObjectsFromArray:otpExpUsersArray];
        [self.myTableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

- (void)searchUser {
    if (self.searchTxt.text.length>0) {
        [QMUITips showLoadingInView:self.view];
        SearchUserAndGroupRequest *request = [SearchUserAndGroupRequest request];
        request.value = self.searchTxt.text;
        request.parameters = [request mj_JSONObject];
        [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[SearchUserInfo class] contentClass:[SearchUserInfo class] success:^(SearchUserInfo *response) {
            [QMUITips hideAllTips];
            self.searchUserInfo = response;
            [self.view endEditing:YES];
            [self.myTableView reloadData];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
}

- (void)searchUserWithQR:(NSString *)valQR {
    [QMUITips showLoadingInView:self.view];
    SearchUserAndGroupRequest *request = [SearchUserAndGroupRequest request];
    request.value = valQR;
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[SearchUserInfo class] contentClass:[SearchUserInfo class] success:^(SearchUserInfo *response) {
        [QMUITips hideAllTips];
        self.searchUserInfo = response;
        [self.view endEditing:YES];
        [self.myTableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(void)getUserInfo:(NSString *)valId{
    GetUserMessageRequest *request = [GetUserMessageRequest request];
    request.userId = valId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        [self searchUserWithQR:response.numberId];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchUser];
    return YES;
}

-(void)setupUI{
    [self.searchBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.scanQrBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.contctBg layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.contctBg layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

-(void)sendInviteRequest:(UserMessageInfo*)userModel{
    [self.inviteeList removeAllObjects];
    SendInviteRequest *request = [SendInviteRequest request];
    [self.inviteeList addObject:@([userModel.userId integerValue])];
    request.inviteeList = self.inviteeList;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[InviteResponseInfo class] contentClass:[InviteResponseInfo class] success:^(InviteResponseInfo *response)  {
        if(response.allInvited == TRUE){
            [QMUITipsTool showOnlyTextWithMessage:@"Add Success !!" inView:nil];
            [self getAllData];
        }else{
            [QMUITipsTool showErrorWihtMessage:response.failedIds.firstObject[@"reason"] inView:nil];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)sendReinviteRequest:(MemebersResponseInfo*)userModel{
    [self.inviteeList removeAllObjects];
    SendInviteRequest *request = [SendInviteRequest request];
    [self.inviteeList addObject:@(userModel.userId)];
    request.inviteeList = self.inviteeList;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[InviteResponseInfo class] contentClass:[InviteResponseInfo class] success:^(InviteResponseInfo *response)  {
        if(response.allInvited == TRUE){
            [QMUITipsTool showOnlyTextWithMessage:@"Add Success !!" inView:nil];
            [self getAllData];
        }else{
            [QMUITipsTool showErrorWihtMessage:response.failedIds.firstObject[@"reason"] inView:nil];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(void)verifyOtp:(NSString *) otpVal modelVal:(MemebersResponseInfo*) modelVal{
    ConfirmUserByOtpRequest *request = [ConfirmUserByOtpRequest request];
    request.otp = otpVal;
    request.userId = modelVal.userId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse* response) {
        [self getAllData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

- (IBAction)scanQRAction:(id)sender {
    QRCodeController *vc = [[QRCodeController alloc]init];
    vc.fromICanWallet = YES;
    vc.scanResultBlock = ^(NSString *result, BOOL isSucceed) {
        NSString *urlString = result;
        NSURL *url = [NSURL URLWithString:urlString];
        NSArray *pathComponents = [url pathComponents];
        NSString *userID = [pathComponents lastObject];
        NSLog(@"User ID: %@", userID);
        [self getUserInfo:userID];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)viewContactList:(id)sender {
    ContactListVC *vc = [[ContactListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.searchUserInfo.users.count;
    }else if(section == 1){
        return self.invitedUsersInfo.count;
    }else{
        return self.resendUsersInfo.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 80;
    }else if(indexPath.section == 1){
        return 150;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        InviteUserCardCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"InviteUserCardCell"];
        UserMessageInfo *modelVal = self.searchUserInfo.users[indexPath.row];
        [cell setDataForCell:modelVal];
        cell.inviteBlock = ^{
            [self sendInviteRequest:modelVal];
        };
        return cell;
    }else if (indexPath.section == 1){
        InviteUserCardWithOTPCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"InviteUserCardWithOTPCell"];
        MemebersResponseInfo *modelVal = self.invitedUsersInfo[indexPath.row];
        [cell setDataForCell:modelVal];
        cell.tapBlock = ^(NSString *text) {
            NSLog(@"Tapped with text: %@", text);
            [self verifyOtp:text modelVal:modelVal];
            [self.view endEditing:YES];
        };
        return cell;
    }else{
        ReinviteCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"ReinviteCell"];
        MemebersResponseInfo *modelVal = self.resendUsersInfo[indexPath.row];
        [cell setDataForCell:modelVal];
        cell.inviteBlock = ^{
            [self sendReinviteRequest:modelVal];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(NSMutableArray<NSNumber *> *)inviteeList{
    if (!_inviteeList) {
        _inviteeList = [NSMutableArray array];
    }
    return _inviteeList;
}

-(NSMutableArray<MemebersResponseInfo *> *)invitedUsersInfo{
    if (!_invitedUsersInfo) {
        _invitedUsersInfo = [NSMutableArray array];
    }
    return _invitedUsersInfo;
}

-(NSMutableArray<MemebersResponseInfo *> *)resendUsersInfo{
    if (!_resendUsersInfo) {
        _resendUsersInfo = [NSMutableArray array];
    }
    return _resendUsersInfo;
}

@end

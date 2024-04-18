//
//  AssignUsersVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AssignUsersVC.h"
#import "AssignMemberCell.h"

@interface AssignUsersVC ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet QMUITextField *searchtxt;
@property (weak, nonatomic) IBOutlet UILabel *assignUserForLevelLbl;
@property(nonatomic, strong) NSArray<MemebersResponseInfo *> *MemberItems;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property(nonatomic, strong) NSMutableArray<MemebersResponseInfo *> *selectedUsersList;
@end

@implementation AssignUsersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"AssignMemberCell"];
    [self.searchBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    UIColor *color = [UIColor grayColor];
    self.searchtxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search".icanlocalized attributes:@{NSForegroundColorAttributeName: color}];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"Done".icanlocalized target:self action:@selector(rightButtonAction)];
    self.searchtxt.delegate = self;
    self.searchtxt.returnKeyType = UIReturnKeySearch;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.searchtxt resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getMemberList];
    self.assignUserForLevelLbl.text = @"Assign users for the level".icanlocalized;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self getMemberList];
    [self.view endEditing:YES];
    return YES;
}

-(void)rightButtonAction{
    if (self.goBackData) {
        self.goBackData(self.selectedUsersList);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getMemberList{
    GetMemeberListRequest *request = [GetMemeberListRequest request];
    NSString *text = self.searchtxt.text;
    NSUInteger characterCount = [text length];
    if( characterCount > 0){
        request.search = self.searchtxt.text;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemebersResponseInfo class] success:^(NSArray<MemebersResponseInfo*>* response) {
        self.MemberItems = response;
        [self.myTableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.MemberItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignMemberCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"AssignMemberCell"];
    MemebersResponseInfo *modelData = self.MemberItems[indexPath.row];
    [cell setData:modelData];
    cell.tapBlock = ^{
        [self handleIsSelected:modelData];
    };
    return cell;
}

-(void)handleIsSelected:(MemebersResponseInfo *)modelData{
    modelData.isSelected = !modelData.isSelected;
    __block bool userIDExists = false;
    for (MemebersResponseInfo *user in self.selectedUsersList) {
        if (user.userId == modelData.userId) {
            userIDExists = YES;
            break;
        }
    }
    if (userIDExists) {
        [self.selectedUsersList removeObject:modelData];
    } else {
        [self.selectedUsersList addObject:modelData];
    }
    [self.myTableView reloadData];
}

-(void)showOptionView{
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"All", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Withdrawals".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
    }];
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"Utility payments".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(NSMutableArray<MemebersResponseInfo *> *)selectedUsersList{
    if (!_selectedUsersList) {
        _selectedUsersList=[NSMutableArray array];
    }
    return _selectedUsersList;
}

@end

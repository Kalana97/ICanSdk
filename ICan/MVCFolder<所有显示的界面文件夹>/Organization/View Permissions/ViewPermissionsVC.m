//
//  ViewPermissionsVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ViewPermissionsVC.h"
#import "PermissionCell.h"
#import "APRTransactionCell.h"
#import "JKPickerView.h"

@interface ViewPermissionsVC ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIControl *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *permissionsLbl;
@property (weak, nonatomic) IBOutlet UILabel *saveLbl;
@property(nonatomic, strong) NSMutableArray<PermissionResponse*> *permissionList;
@end

@implementation ViewPermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"PermissionCell"];
    [self.myTableView registNibWithNibName:@"APRTransactionCell"];
    [self.saveBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    [self addLocalizatins];
}

-(void)addLocalizatins{
    self.permissionsLbl.text = @"Permissions".icanlocalized;
    self.saveLbl.text = @"Save".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self addPermissionsListManually];
}

-(void)addPermissionsListManually{
    [self.permissionList removeAllObjects];
    
    PermissionResponse *response1 = [[PermissionResponse alloc] initWithShowName:@"Invite Users".icanlocalized permissionType:INVITE_USERS imageName: @"user-add" isSelected:NO];
    [self.permissionList addObject:response1];
    
    PermissionResponse *response2 = [[PermissionResponse alloc] initWithShowName:@"Remove Users".icanlocalized permissionType:REMOVE_USERS imageName: @"user-remov" isSelected:NO];
    [self.permissionList addObject:response2];
    
    PermissionResponse *response3 = [[PermissionResponse alloc] initWithShowName:@"Confirm Users".icanlocalized permissionType:CONFIRM_USERS imageName: @"user-confirm" isSelected:NO];
    [self.permissionList addObject:response3];
    
    PermissionResponse *response4 = [[PermissionResponse alloc] initWithShowName:@"Organization Settings".icanlocalized permissionType:CHANGE_PERMISSION imageName: @"Organization Settings Change" isSelected:NO];
    [self.permissionList addObject:response4];
    
    PermissionResponse *response5 = [[PermissionResponse alloc] initWithShowName:@"View Organization Transactions".icanlocalized permissionType:VIEW_TRANSACTION_ORG imageName: @"View Organization Transactions" isSelected:NO];
    [self.permissionList addObject:response5];
    
    PermissionResponse *response7 = [[PermissionResponse alloc] initWithShowName:@"Owner".icanlocalized permissionType:OWNER imageName: @"settingIcon" isSelected:NO];
    [self.permissionList addObject:response7];
    
    PermissionResponse *response6 = [[PermissionResponse alloc] initWithShowName:@"Approve Transactions".icanlocalized permissionType:APR_TRANSACTION imageName: @"View Organization Transactions" isSelected:NO];
    [self.permissionList addObject:response6];
    
    for (QTPermission *perType in self.memberInfo.permissions) {
        for (PermissionResponse *existType in self.permissionList) {
            if([existType.permission isEqualToString:perType.permission]){
                existType.isSelected = YES;
                if([perType.permission isEqualToString:APR_TRANSACTION]){
                    existType.data = perType.data;
                    existType.isSelected = YES;
                }
            }
        }
    }
    [self.myTableView reloadData];
}


- (IBAction)saveTheDataPermissions:(id)sender {
    NSMutableArray *qtPermissionArray = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == YES"];
    NSArray *filteredArray = [self.permissionList filteredArrayUsingPredicate:predicate];
    for (PermissionResponse *permissionResponse in filteredArray) {
        QTPermission *qtPermission = [[QTPermission alloc] init];
        qtPermission.data = permissionResponse.data;
        qtPermission.permission = permissionResponse.permission;
        if(![permissionResponse.data isEqualToString:@"No Level".icanlocalized]){
            [qtPermissionArray addObject:qtPermission];
        }
    }
    ChangeUserPermissions *request = [ChangeUserPermissions request];
    request.userId = self.memberInfo.userId;
    request.permissions = qtPermissionArray;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
        [QMUITips hideAllTips];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.permissionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PermissionResponse *modelData = self.permissionList[indexPath.row];
    if([modelData.permission isEqualToString:APR_TRANSACTION]){
        APRTransactionCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"APRTransactionCell"];
        [cell setData:modelData];
        cell.memberInfo = self.memberInfo;
        cell.organizationInfoModel = self.organizationInfoModel;
        cell.tapBlock = ^(NSString *text) {
            NSLog(@"Tapped with text: %@", text);
            modelData.data = text;
            modelData.isSelected = YES;
            [self.myTableView reloadData];
            [self.view endEditing:YES];
        };
        return cell;
    }else{
        PermissionCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"PermissionCell"];
        [cell setData:modelData];
        cell.tapBlock = ^{
            [self handleIsSelected:modelData];
        };
        return cell;
    }
    
}

-(void)handleIsSelected:(PermissionResponse *)modelData{
    if(![modelData.permission isEqualToString:APR_TRANSACTION]){
        modelData.isSelected = !modelData.isSelected;
        [self.myTableView reloadData];
    }else{
        NSLog(@"APR_TRANSACTION");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(NSMutableArray<PermissionResponse *> *)permissionList{
    if (!_permissionList) {
        _permissionList=[NSMutableArray array];
    }
    return _permissionList;
}

@end

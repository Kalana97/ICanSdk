
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/6/2021
- File name:  UtilityPaymentsRecordViewController.m
- Description:
- Function List:
*/
        

#import "UtilityPaymentsRecordViewController.h"
#import "UtilityPaymentsRecordDetailViewController.h"
#import "UtilityPaymentsRecordListTableViewCell.h"
@interface UtilityPaymentsRecordViewController ()

@end

@implementation UtilityPaymentsRecordViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    "UtilityPaymentsViewController.rightBarItem"="充值记录";
    self.listRequest=[GetDialogOrderListRequest request];
    self.listClass=[DialogOrdersListInfo class];
    [self refreshList];
    self.title=@"UtilityPaymentsViewController.rightBarItem".icanlocalized;
}
#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kUtilityPaymentsRecordListTableViewCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightUtilityPaymentsRecordListTableViewCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilityPaymentsRecordListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kUtilityPaymentsRecordListTableViewCell];
    cell.dialogOrderInfo=self.listItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilityPaymentsRecordDetailViewController*vc=[UtilityPaymentsRecordDetailViewController new];
    vc.dialogOrderInfo=self.listItems[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking

@end

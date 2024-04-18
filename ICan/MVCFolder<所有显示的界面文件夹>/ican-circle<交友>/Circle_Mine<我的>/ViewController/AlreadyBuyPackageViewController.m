
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  AlreadyBuyPackageViewController.m
- Description:
- Function List:
*/
        

#import "AlreadyBuyPackageViewController.h"
#import "AlreadyBuyPackageTableViewCell.h"

#import "ConsumptionRecordsViewController.h"
@interface AlreadyBuyPackageViewController ()

@end

@implementation AlreadyBuyPackageViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    "AlreadyBuyPackageViewController.title"="已购套餐";
    //    "AlreadyBuyPackageViewController.rightButton"="消费记录";
    self.title=@"AlreadyBuyPackageViewController.title".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"AlreadyBuyPackageViewController.rightButton".icanlocalized style:UIBarButtonItemStyleDone target:self action:@selector(consumptionRecords)];
    self.listRequest=[GetMyPackagesListRequest request];
    self.listClass=[MyPackagesListInfo class];
    [self refreshList];
    self.view.backgroundColor=UIColorBg243Color;
}
-(void)consumptionRecords{
    ConsumptionRecordsViewController*vc=[ConsumptionRecordsViewController new];
    vc.isDetail=NO;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kAlreadyBuyPackageTableViewCell];
    self.tableView.backgroundColor=UIColorBg243Color;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlreadyBuyPackageTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kAlreadyBuyPackageTableViewCell];
    cell.myPackagesInfo=self.listItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPackagesInfo*info=self.listItems[indexPath.row];
    ConsumptionRecordsViewController*vc=[ConsumptionRecordsViewController new];
    vc.isDetail=YES;
    vc.myPackageId=info.myPackageId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking

@end

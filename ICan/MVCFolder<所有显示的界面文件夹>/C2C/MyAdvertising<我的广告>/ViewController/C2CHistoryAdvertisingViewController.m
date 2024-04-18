//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 18/11/2021
 - File name:  C2CMyAdvertisingViewController.m
 - Description:
 - Function List:
 */


#import "C2CHistoryAdvertisingViewController.h"
#import "C2CMyAdvertisingListTableViewCell.h"

@interface C2CHistoryAdvertisingViewController ()
@property (nonatomic, strong) C2CGetUserAdverListRequest *request;
@end

@implementation C2CHistoryAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"HistoricalAds".icanlocalized;
    self.listClass = [C2COptionalListInfo class];
    [self resetFetchList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:kC2CPublishAdverSuccessNotification object:nil];
}
//重置搜索条件
-(void)resetFetchList{
    self.request = [C2CGetUserAdverListRequest request];
    self.request.deleted = @(1);
    self.listRequest=self.request;
    self.request.userId = C2CUserManager.shared.userId;
    
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorBg243Color;
    [self.tableView registNibWithNibName:kC2CMyAdvertisingListTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
        
    }];
}


-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CMyAdvertisingListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CMyAdvertisingListTableViewCell];
    cell.adverInfo = [self.listItems objectAtIndex:indexPath.row];
    cell.openSwitch.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
@end

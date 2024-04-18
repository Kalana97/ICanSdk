//
//  ReceiptRecordDetailViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptRecordDetailViewController.h"
#import "ReceiptRecordDetailHeaderView.h"
#import "ReceiptRecordDetailTableViewCell.h"


@interface ReceiptRecordDetailViewController ()
@property (nonatomic,strong)ReceiptRecordDetailHeaderView * headerView;

@end

@implementation ReceiptRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString(@"Bill details",详情);
}

-(void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor = UIColorBg243Color;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registNibWithNibName:KReceiptRecordDetailTableViewCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptRecordDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KReceiptRecordDetailTableViewCell];
    cell.info=self.info;
    return cell;
}

-(ReceiptRecordDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ReceiptRecordDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 137)];
        _headerView.info=self.info;
        
    }
    return _headerView;
}



@end

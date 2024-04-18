//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2020
- File name:  ReportListTableViewController.m
- Description:
- Function List:
*/
        

#import "ReportListTableViewController.h"
#import "RightArrowTableViewCell.h"
#import "SubmitReportViewController.h"
@interface ReportListTableViewController ()
@property(nonatomic, strong) NSArray<TimelinesReportInfo*> *reportItems;
@end

@implementation ReportListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[@"timeline.post.operation.complaint" icanlocalized:@"投诉"];
    [self getReportTypeRequest];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tableView registNibWithNibName:kRightArrowTableViewCell];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1    ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightRightArrowTableViewCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RightArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightArrowTableViewCell];
    cell.titleLabel.text=self.reportItems[indexPath.row].value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitReportViewController*vc=[[SubmitReportViewController alloc]init];
    vc.reportType=self.reportItems[indexPath.row].key;
    vc.timelineId=self.timelineId;
    vc.userId=self.userId;
    vc.type=self.type;
    vc.userId=self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getReportTypeRequest{
    GetTimelineReportTypeRequest*request=[GetTimelineReportTypeRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[TimelinesReportInfo class] success:^(NSArray* response) {
        self.reportItems=response;
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
@end

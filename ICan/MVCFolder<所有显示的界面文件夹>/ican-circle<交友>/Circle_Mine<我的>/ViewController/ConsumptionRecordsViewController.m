
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  ConsumptionRecordsViewController.m
- Description:
- Function List:
*/
        

#import "ConsumptionRecordsViewController.h"
#import "ConsumptionRecordsTableViewCell.h"
@interface ConsumptionRecordsViewController ()

@end

@implementation ConsumptionRecordsViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    "AlreadyBuyPackageViewController.rightButton"="消费记录";
    self.title=@"AlreadyBuyPackageViewController.rightButton".icanlocalized;
    if (self.isDetail) {
        ConsumptionRecordsListRequest*request= [ConsumptionRecordsListRequest request];
        request.myPackageId=self.myPackageId;
        self.listRequest=request;
        self.listClass=[ConsumptionRecordsListInfo class];
    }else{
        self.listRequest=[ConsumptionRecordsListRequest request];
        self.listClass=[ConsumptionRecordsListInfo class];
    }
   
    [self refreshList];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kConsumptionRecordsTableViewCell];
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
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsumptionRecordsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kConsumptionRecordsTableViewCell];
    cell.consumptionRecordsInfo=[self.listItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event
#pragma mark - Networking

@end

//
//  ReceiptRecordViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptRecordViewController.h"
#import "ReceiptRecordTableViewCell.h"
#import "ReceiptRecordDetailViewController.h"


@interface ReceiptRecordViewController ()
@property(nonatomic, strong) NSMutableDictionary *dict;
@property(nonatomic, strong) NSArray *keyItems;
@property(nonatomic, strong) NSMutableArray<NSArray*> *flowsItems;
@end

@implementation ReceiptRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //收款记录
    self.title =@"Collection records".icanlocalized;
    self.listRequest=[PayQRCodereceiveFlowsRequest request];
    self.listClass=[ReceiveFlowsListInfo class];
    [self refreshList];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor = UIColorBg243Color;
    [self.tableView setTableViewSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registNibWithNibName:KReceiptRecordTableViewCell];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keyItems.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.flowsItems objectAtIndex:section] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KReceiptRecordTableViewCell];
    cell.flowsInfo=[[self.flowsItems objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightReceiptRecordTableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 36;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    view.backgroundColor = UIColorMake(241, 245, 249);
    UILabel * label = [UILabel leftLabelWithTitle:@"" font:12 color:UIColorThemeMainSubTitleColor];
    NSString*time=[GetTime convertDateWithString:[self.keyItems objectAtIndex:section] dateFormmate:@"yyyy/MM/d"];
    label.text=time;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiptRecordDetailViewController*vc=[[ReceiptRecordDetailViewController alloc]init];
    vc.info=[[self.flowsItems objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)doSometingBeforeReloadData:(ListInfo *)response{
    [self sortListItems];
}
-(void)sortListItems{
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    for (ReceiveFlowsInfo*info in self.listItems) {
        NSString*key=[GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",info.payTime] dateFormmate:@"yyyy/MM/d"];
        NSDate*date=  [GetTime convertDateFromStringDay:key withDateFormat:@"yyyy/MM/d"];
        NSString*keyy=[GetTime dateConversionTimeStamp:date];
        NSMutableArray*array=[dict objectForKey:keyy];
        if (!array) {
            array=[NSMutableArray array];
            [dict setObject:array forKey:keyy];
        }
        [array addObject:info];
    }
    self.flowsItems=[NSMutableArray array];
    //获取排序之后的字母
    self.keyItems=  [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        if ([obj1 integerValue]<[obj2 integerValue]) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
        
    }];
    for (NSString * key in self.keyItems) {
        
        [self.flowsItems addObject:[dict objectForKey:key]];
    }
    [self.tableView reloadData];
}




@end

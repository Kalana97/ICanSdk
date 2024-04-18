//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/11/2019
- File name:  WithdrawRecordListViewController.m
- Description:
- Function List:
*/
        

#import "WithdrawRecordListViewController.h"
#import "WithdrawRecordListTableViewCell.h"
#import <BRPickerView.h>
@interface WithdrawRecordListViewController ()
@property(nonatomic, strong) UILabel * timeLabel;
@property(nonatomic, strong) UIImageView * rightImageView;
@property(nonatomic, strong) UIControl *timeConView;
@property(nonatomic,copy)    NSString *year;
@property(nonatomic,copy)    NSString *month;
@end

@implementation WithdrawRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"WithdrawalRecord", 提现记录);
    NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
    self.year = [GetTime stringFromDate:date withDateFormat:@"yyyy"];
    self.month = [GetTime stringFromDate:date withDateFormat:@"MM"];
    [self refreshList];
    [self.view addSubview:self.timeConView];
    [self.timeConView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.height.equalTo(@40);
        make.top.equalTo(@(NavBarHeight));
    }];
    [self.timeConView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeConView.mas_centerY);
        make.left.equalTo(@10);
    }];
    
    [self.timeConView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.width.equalTo(@9);
        make.height.equalTo(@5.5);
        make.centerY.equalTo(self.timeConView.mas_centerY);
    }];
    [self refreshList];
    
}
-(void)layoutTableView{
    
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kWithdrawRecordListTableViewCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight+40));
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightWithdrawRecordListTableViewCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithdrawRecordListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kWithdrawRecordListTableViewCell];
    cell.withdrawRecordInfo=self.listItems[indexPath.row];
    return cell;
}
-(UIControl *)timeConView{
    if (!_timeConView) {
        _timeConView=[[UIControl alloc]init];
        [_timeConView addTarget:self action:@selector(showDatePickerView) forControlEvents:UIControlEventTouchUpInside];
        _timeConView.backgroundColor=UIColorBg243Color;
    }
    return _timeConView;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel leftLabelWithTitle:@"" font:15 color:UIColorThemeMainSubTitleColor];
        NSDate *  date = [GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
        NSString *time = [GetTime stringFromDate:date withDateFormat:@"yyyy/MM"];
        _timeLabel.text = time;
    }
    return _timeLabel;
}


-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_drop_choose"]];
        
    }
    return _rightImageView;
}
-(void)showDatePickerView{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYM];
    // 2.设置属性
    datePickerView.title = @"Select period".icanlocalized;
    //    @"2019-10"
    datePickerView.selectValue = [NSString stringWithFormat:@"%@-%@",self.year,self.month];
    //    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:2010 month:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    //     datePickerView.addToNow = YES;  // 是否添加“至今”
    // datePickerView.showToday = YES; // 是否显示“今天”
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSArray * dateArray = [selectValue componentsSeparatedByString:@"-"];
        self.year = [dateArray objectAtIndex:0];
        self.month = [dateArray objectAtIndex:1];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@/",self.year,self.month];
        [self refreshList];
        
    };
    // 自定义主题样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColorBg243Color;
    customStyle.pickerTextColor = UIColor102Color;
    customStyle.separatorColor = UIColor102Color;
    datePickerView.pickerStyle = customStyle;
    customStyle.titleBarColor=UIColor.whiteColor;
    
    // 3.显示
    [datePickerView show];
    
}
-(void)fetchListRequest{
    WithdrawRecordRequest *request = [WithdrawRecordRequest request];
    request.size=@(self.pageSize);
    request.page=@(self.current);
    request.startTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",self.year,self.month];
    NSString *count=[GetTime daysCountOfMonth:self.month year:self.year];
    request.endTime = [NSString stringWithFormat:@"%@-%@-%@ 23:59:59",self.year,self.month,count];
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[WithdrawRecordListInfo class] contentClass:[WithdrawRecordInfo class] success:^(WithdrawRecordListInfo* response) {
        @strongify(self);
        self.listInfo=response;
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:response.content];
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
@end

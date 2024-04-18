//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/2/2022
- File name:  BillPageContentViewController.m
- Description:
- Function List:
*/
        

#import "BillPageContentViewController.h"
#import <BRPickerView.h>
#import "BillPageViewController.h"
@interface BillPageContentViewController ()
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property(nonatomic, strong) BillPageViewController *billPageVc;
@end

@implementation BillPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"TransactionsBalance",账单);
    NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
    NSString *time =[GetTime stringFromDate:date withDateFormat:@"yyyy/MM"];
    self.timeLabel.text = time;
    self.billPageVc =  [[BillPageViewController alloc]init];
    self.billPageVc.year = [GetTime stringFromDate:date withDateFormat:@"yyyy"];
    self.billPageVc.month = [GetTime stringFromDate:date withDateFormat:@"MM"];
    [self addChildViewController:self.billPageVc];
    
    self.billPageVc.view.frame = CGRectMake(0, NavBarHeight+35, ScreenWidth, ScreenHeight-35-NavBarHeight);
    [self.billPageVc didMoveToParentViewController:self];
    [self.view addSubview:self.billPageVc.view];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePickerView)];
    [self.dateView addGestureRecognizer:tap];
    [self.billPageVc reloadVc];
   
}

-(void)showDatePickerView{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYM];
    // 2.设置属性
    datePickerView.title = @"Select period".icanlocalized;
    //    @"2019-10"
//    datePickerView.selectValue = [NSString stringWithFormat:@"%@-%@",self.year,self.month];
    //    datePickerView.selectDate = [NSDate br_setYear:2019 month:10 day:30];
    datePickerView.minDate = [NSDate br_setYear:2010 month:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    //     datePickerView.addToNow = YES;  // 是否添加“至今”
    // datePickerView.showToday = YES; // 是否显示“今天”
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSArray * dateArray = [selectValue componentsSeparatedByString:@"-"];
        self.billPageVc.year = [dateArray objectAtIndex:0];
        self.billPageVc.month = [dateArray objectAtIndex:1];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@/",self.billPageVc.year,self.billPageVc.month];
        [self.billPageVc reloadVc];
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
@end

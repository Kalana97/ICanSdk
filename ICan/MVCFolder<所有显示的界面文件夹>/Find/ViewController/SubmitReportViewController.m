//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2020
- File name:  SubmitReportViewController.m
- Description:
- Function List:
*/
        

#import "SubmitReportViewController.h"

@interface SubmitReportViewController ()
@property(nonatomic, strong) QMUITextView *textView;
@property(nonatomic, strong) UIButton *submitButton;
@end

@implementation SubmitReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[@"timeline.post.operation.complaint" icanlocalized:@"投诉"];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@100);
        make.right.equalTo(@-10);
        make.top.equalTo(@(NavBarHeight+10));
    }];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@45);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
    }];
}
-(QMUITextView *)textView{
    if (!_textView) {
        _textView=[[QMUITextView alloc]init];
        _textView.placeholder=@"Complaint details (optional)".icanlocalized;
        _textView.backgroundColor=UIColor153Color;
        _textView.placeholderColor=UIColor153Color;
        _textView.font=[UIFont systemFontOfSize:16];
        _textView.textColor=UIColorThemeMainTitleColor;
    }
    return _textView;
}
-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton=[UIButton dzButtonWithTitle:@"Submit".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(submitButtonAction)];
        [_submitButton layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    }
    return _submitButton;
}
-(void)submitButtonAction{
    TimeLinesReportRequest*request=[TimeLinesReportRequest request];
    request.content=self.textView.text;
    request.reportType=self.reportType;
    request.type=self.type;
    if ([self.type isEqualToString:@"User"]) {
         request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/reports/%@",self.userId];
    }else{
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/reports/%@",self.timelineId];
    }
   
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"SubmitReportViewController.tips".icanlocalized inView:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
@end

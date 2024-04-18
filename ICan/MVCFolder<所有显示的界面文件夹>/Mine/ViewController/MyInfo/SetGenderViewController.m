//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 15/10/2019
- File name:  SetGenderViewController.m
- Description:
- Function List:
*/
        

#import "SetGenderViewController.h"

@interface SetGenderViewController ()
@property (weak, nonatomic) IBOutlet UIControl *manCon;
@property (weak, nonatomic) IBOutlet UIControl *womenCon;
@property (weak, nonatomic) IBOutlet UILabel *womenLab;
@property (weak, nonatomic) IBOutlet UILabel *manLab;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

@end

@implementation SetGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorViewBgColor;
    
    self.title = NSLocalizedString(@"Gender setting", 设置性别);
    self.womenLab.text =NSLocalizedString(@"Female", 女);
    self.womenLab.textColor = UIColorThemeMainTitleColor;
    self.manLab.text = NSLocalizedString(@"Male", 男);
    self.manLab.textColor = UIColorThemeMainTitleColor;
    self.lineView1.backgroundColor=
    self.lineView2.backgroundColor = UIColorSeparatorColor;

}
- (IBAction)manConAction {
    [self setGender:@"1"];
    
}
- (IBAction)womenConAction {
    [self setGender:@"2"];
    
}


-(void)setGender:(NSString*)gender{
    EditUserMessageRequest*request=[EditUserMessageRequest request];
    request.gender = gender;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
        [UserInfoManager sharedManager].gender = gender;
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
         [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}



@end

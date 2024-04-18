//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 31/10/2019
- File name:  EditGroupAnnounceViewController.m
- Description:
- Function List:
*/
        

#import "EditGroupAnnounceViewController.h"

@interface EditGroupAnnounceViewController ()
@property(nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic,strong) UITextView * textView;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UILabel * numberLabel;
@end

@implementation EditGroupAnnounceViewController
- (BOOL)forceEnableInteractivePopGestureRecognizer{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    //群公告
    self.title=@"group.detail.listCell.groupNotice".icanlocalized;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UIAlertController.cancel.title".icanlocalized target:self action:@selector(cancelAction)];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavBarHeight+10));
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@200);
    }];
    
    
    
    self.textView.text=self.groupDetailInfo.announce;
    self.textView.editable=[self.groupDetailInfo.role isEqualToString:@"2"]?NO:YES;
    
    if (![self.groupDetailInfo.role isEqualToString:@"2"] ) {
        [self.view addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.top.equalTo(self.textView.mas_bottom).offset(-20);
            
        }];
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"EditGroupAnnounceViewController.rightButton".icanlocalized target:self action:@selector(sureAction)];
    }
    [self.textView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)textFieldDidChange:(NSNotification*)nofication{
    
        if ( (unsigned long)self.textView.text.length > 300) {
    // 对超出的部分进行剪切
         self.textView.text = [self.textView.text substringToIndex:300];
            
        }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)self.textView.text.length];
    
}

-(void)cancelAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sureAction{
    if (self.textView.text.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please enter content".icanlocalized inView:self.view];
        return;
        
    }
    [self settting];
}


-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:@"EditGroupAnnounceViewController.rightButton".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:14 titleColor:UIColor.whiteColor target:self action:@selector(sureAction)];
        ViewRadius(_rightBtn, 22);
    }
    return _rightBtn;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]init];
        _textView.textColor=UIColor252730Color;
        _textView.backgroundColor=[UIColor whiteColor];
        _textView.font=[UIFont systemFontOfSize:16];
        
    }
    return _textView;
}
-(UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
        _scrollview.showsVerticalScrollIndicator=NO;
        _scrollview.showsHorizontalScrollIndicator=NO;
        _scrollview.backgroundColor=UIColorBg243Color;
        
    }
    return _scrollview;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel rightLabelWithTitle:@"0/300" font:13 color:UIColor153Color];
    }
    
    return _numberLabel;
}

-(void)settting{
    SettingAnnounceRequest*request=[SettingAnnounceRequest request];
    request.groupId=@([self.groupDetailInfo.groupId integerValue]);
    request.announce=self.textView.text;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITips hideAllTips];
        if (self.settingGroupAnnounceBlock) {
            self.settingGroupAnnounceBlock(self.textView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}



@end

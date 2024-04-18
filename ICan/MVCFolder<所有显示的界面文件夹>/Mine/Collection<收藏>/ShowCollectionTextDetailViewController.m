//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 30/3/2020
- File name:  ShowCollectionTextDetailViewController.m
- Description:
- Function List:
*/
        

#import "ShowCollectionTextDetailViewController.h"
#import "XMFaceManager.h"
@interface ShowCollectionTextDetailViewController ()
@property (strong,nonatomic) UITextView*textView;
@end

@implementation ShowCollectionTextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorViewBgColor;
    self.title=@"details".icanlocalized;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@50);
    }];
    NSMutableAttributedString* attrStr = [XMFaceManager emotionStrWithString:self.response.content isOutGoing:YES];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:UIColorThemeMainTitleColor} range:NSMakeRange(0, attrStr.length)];
    self.textView.attributedText=attrStr;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]init];
        _textView.backgroundColor =UIColorViewBgColor;
        _textView.textColor=UIColorThemeMainTitleColor;
        _textView.font=[UIFont systemFontOfSize:16];
    }
    return _textView;
}
@end

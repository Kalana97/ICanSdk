//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/6/2020
- File name:  ShowReplyTextViewController.m
- Description:
- Function List:
*/
        

#import "ShowReplyTextViewController.h"
#import "XMFaceManager.h"
#import "WCDBManager+UserMessageInfo.h"
@interface ShowReplyTextViewController ()
@property(nonatomic, strong) UITextView *textView;
@end

@implementation ShowReplyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
        
    }];
    
}
-(void)setReplyMessageInfo:(ReplyMessageInfo *)replyMessageInfo{
    TextMessageInfo*textInfo=[TextMessageInfo mj_objectWithKeyValues:replyMessageInfo.jsonMessage];
    
    NSString* replyText=textInfo.content;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:replyMessageInfo.userId successBlock:^(UserMessageInfo * _Nonnull info) {
        NSString*replydText=[NSString stringWithFormat:@"  %@:%@  ",info.nickname,replyText];
        NSMutableAttributedString*attrStr=[[NSMutableAttributedString alloc]init];
        attrStr = [XMFaceManager getReplyEmotionStrWithString:replydText isShowReplayView:YES];
        self.textView.attributedText=attrStr;
        
    }];
}

-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]init];
        _textView.textColor=UIColor252730Color;
        _textView.font=[UIFont systemFontOfSize:16];
    }
    return _textView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

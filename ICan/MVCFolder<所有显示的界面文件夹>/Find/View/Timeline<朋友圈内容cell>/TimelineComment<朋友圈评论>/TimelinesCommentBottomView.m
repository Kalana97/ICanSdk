//
//  TimelinesCommentBottomView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesCommentBottomView.h"
#import "DZTextView.h"
#import "XMChatFaceView.h"
#import "EmojyShowView.h"
#define kMaxHeight 100.0f
#define DefaultTextViewHeight 35
#define MaxTextViewHeight 76
static CGFloat const KFaceViewHeight=300;
@interface TimelinesCommentBottomView ()<QMUITextViewDelegate,XMChatFaceViewDelegate>

@property(nonatomic,strong)   UIView * clearView;
/** iPhonex底部多34 */
@property(nonatomic, assign)  CGFloat bottomMargin;
@property (strong, nonatomic) XMChatFaceView *commentfaceView;

@property(nonatomic, strong) EmojyShowView *commentEmojyShowView;
@property(nonatomic, assign) BOOL showFaceView;
/** 当前的键盘的高度 */
@property(nonatomic, assign) CGFloat kbHeight;
@property(nonatomic, assign) CGFloat mineHeight;
/** textViewheight输入框的高度 */
@property (nonatomic,assign)  CGFloat textViewHeight;

@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic, strong) UIView *bgKeyboardView;
@end
@implementation TimelinesCommentBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.bottomMargin=isIPhoneX?30:10;
        self.mineHeight=isIPhoneX?75:55;
        self.isComment=YES;
        [self addNotification];
        [self setUpView];
    }
    return self;
}

-(void)addNotification{
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    CGPoint tempPoint = [self.clearView convertPoint:point fromView:self];
    if(self.topBgView.hidden){
        return view;
    }
    if ([self.clearView pointInside:tempPoint withEvent:event]) {
        return self.clearView;
    }
    return view;
}


-(void)setUpView{
    self.backgroundColor =UIColor.whiteColor;
    self.userInteractionEnabled= YES;
    [self addSubview:self.topBgView];
    [self addSubview:self.bgKeyboardView];
    [self.bgKeyboardView addSubview:self.textView];
    [self.bgKeyboardView addSubview:self.faceImageView];
    [self addSubview:self.sendButton];
    self.textViewHeight=35;
    [self.bgKeyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.top.equalTo(@10);
        make.right.equalTo(@-55);
        make.left.equalTo(@10);
    }];
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgKeyboardView.mas_right).offset(-10);
        make.width.height.equalTo(@25);
        make.centerY.equalTo(self.textView.mas_centerY);
    }];
    //如果是iPhonex类型 默认高度是55  textview 35 上下距离是10
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(self.faceImageView.mas_left).offset(0);
    }];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@30);
    }];
    [self.topBgView addSubview:self.closeImageView];
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@21.5);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.topBgView.mas_centerY);
    }];
    [self.topBgView addSubview:self.replyLabel];
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBgView.mas_centerY);
        make.left.equalTo(self.closeImageView.mas_right).offset(10);
    }];
    [self.topBgView addSubview:self.clearView];
    [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.closeImageView);
        make.width.height.equalTo(@30);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.height.equalTo(@30);
        make.right.equalTo(@-12.5);
        make.centerY.equalTo(self.bgKeyboardView.mas_centerY);
    }];
    [self addSubview:self.commentEmojyShowView];
}

-(UIImageView *)faceImageView{
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_funtion_expression_select"]];
        _faceImageView.userInteractionEnabled =YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showfaceAction)];
        [_faceImageView addGestureRecognizer:tap];
    }
    
    return _faceImageView;
}
-(void)hiddenAllView{
    [self hiddenFaceView];
    [self.textView resignFirstResponder];
    self.mineHeight=self.textViewHeight+10+self.bottomMargin;
    [self updateConstraintsFram];
}
#pragma mark 键盘通知
-(void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary*userInfo = [noti userInfo];
    // 1,取出键盘动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.mineHeight=self.textViewHeight+10+self.bottomMargin;
    [self updateConstraintsFram];
}

-(void)keyboardWillShow:(NSNotification *)noti {
    //获取键盘的高度
    NSDictionary*userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self hiddenFaceView ];
    self.kbHeight = [value CGRectValue].size.height;
    self.mineHeight=self.textViewHeight+self.kbHeight+20;
    [self updateConstraintsFram];
}
-(void)showfaceAction{
    self.showFaceView=!self.showFaceView;
    if (self.showFaceView) {
        [self.textView resignFirstResponder];
        [self showFaceViewAction];
    }else{
        [self hiddenFaceView];
        [self.textView becomeFirstResponder];
    }
    
    
}

-(void)hiddenFaceView{
    self.showFaceView=NO;
    self.mineHeight=self.textViewHeight+10+self.bottomMargin;
//    self.commentfaceView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight);
    self.commentEmojyShowView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.bottomMargin);
    
}
-(void)showFaceViewAction{
    self.mineHeight=self.textViewHeight+20+KFaceViewHeight;
    if (self.isComment) {
//        self.commentfaceView.frame=CGRectMake(0, self.textViewHeight+20, ScreenWidth, KFaceViewHeight);
        self.commentEmojyShowView.frame=CGRectMake(0, self.textViewHeight+20, ScreenWidth, KFaceViewHeight+self.bottomMargin);
    }else{
//        self.commentfaceView.frame=CGRectMake(0, self.textViewHeight+20+30, ScreenWidth, KFaceViewHeight);
        self.commentEmojyShowView.frame=CGRectMake(0, self.textViewHeight+20+30, ScreenWidth, KFaceViewHeight+self.bottomMargin);
    }
    
    
    
}
-(UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [UIView new];
        _topBgView.backgroundColor = [UIColor whiteColor];
        _topBgView.userInteractionEnabled =YES;
        _topBgView.hidden=YES;
    }
    return _topBgView;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [UILabel leftLabelWithTitle:@"" font:14.0 color:UIColor153Color];
    }
    
    return _replyLabel;
}
-(void)showReplyView{
    self.isComment=NO;
    self.topBgView.hidden=NO;
    [self updateConstraintsFram];
}
-(void)closeAction{
    self.textView.placeholder = NSLocalizedString(@"Write a Review", 写评论...);
    self.isComment=YES;
    !self.closeBlock?:self.closeBlock();
    self.topBgView.hidden=YES;
    [self updateConstraintsFram];
    
}
-(UIImageView *)closeImageView{
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_close_reply"]];
        _closeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
        [_closeImageView addGestureRecognizer:tap];
    }
    
    return _closeImageView;
}
-(void)checkSendButtonCanSend{
    if (self.textView.text.length>0) {
        self.sendButton.enabled=YES;
        [self.sendButton setBackgroundImage:UIImageMake(@"chat_funtion_send_enabled") forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled=NO;
        [self.sendButton setBackgroundImage:UIImageMake(@"chat_funtion_send_disabled") forState:UIControlStateNormal];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    [self checkSendButtonCanSend];
}
-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(sendButtonAction)];
        [_sendButton setBackgroundImage:UIImageMake(@"chat_funtion_send_disabled") forState:UIControlStateNormal];
        _sendButton.enabled=NO;
        
    }
    return _sendButton;
}
-(void)sendButtonAction{
    !self.sendCommentBlock?:self.sendCommentBlock(self.textView.text);
    self.textView.text=@"";
}
-(XMChatFaceView *)commentfaceView{
    if (!_commentfaceView) {
        _commentfaceView = [[XMChatFaceView alloc] initWithFrame:(CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight))];
        _commentfaceView.backgroundColor = UIColor.whiteColor;
        _commentfaceView.delegate = self;
        _commentfaceView.sendButton.hidden =YES;
    }
    return _commentfaceView;
}
-(EmojyShowView *)commentEmojyShowView{
    if (!_commentEmojyShowView) {
        _commentEmojyShowView=[[EmojyShowView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.bottomMargin)];
        [_commentEmojyShowView setSendButtonHidden:YES];
        @weakify(self);
        _commentEmojyShowView.selectEmojyBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            self.textView.text = [self.textView.text stringByAppendingString:text];
        };
        _commentEmojyShowView.deleteBlock = ^{
            @strongify(self);
            if (self.textView.text.length>0) {
                NSRange lastRange = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.textView.text.length-1];
                self.textView.text = [self.textView.text stringByReplacingCharactersInRange:lastRange withString:@""];
            }
            
        };
    }
    return _commentEmojyShowView;
}

-(UIView *)clearView{
    if (!_clearView) {
        _clearView = [UIView new];
        _clearView.backgroundColor = UIColor.clearColor;
        _clearView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
        [_clearView addGestureRecognizer:tap];
    }
    
    return _clearView;
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return [self messageTextView:textView shouldChangeTextInRange:range replacementText:text];
}
- (void)faceViewSendFace:(NSString *)faceName {
    
    if ([faceName isEqualToString:@"[删除]"]) {
        [self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""];
    }else if ([faceName isEqualToString:@"发送"]){
        
    }else{
        self.textView.text = [self.textView.text stringByAppendingString:faceName];
    }
}
- (BOOL)messageTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        !self.sendCommentBlock?:self.sendCommentBlock(self.textView.text);
        self.textView.text=@"";
        return NO;
    }else if (text.length == 0){
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        if ([deleteText isEqualToString:@"]"]) {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            NSString *subText;
            while (YES) {
                if (location == 0) {
                    return YES;
                }
                location -- ;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            return NO;
        }
    }
    return YES;
}


-(QMUITextView *)textView{
    if (!_textView) {
        _textView = [[QMUITextView alloc]init];
        _textView.scrollEnabled = NO;
        _textView.textColor = UIColor252730Color;
        _textView.backgroundColor = UIColorBg243Color;
        _textView.placeholderColor=UIColor102Color;
        ViewRadius(_textView, 5);
        _textView.placeholder = NSLocalizedString(@"Write a Review", 写评论...);
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate=self;
        _textView.font = [UIFont systemFontOfSize:15.0];
    }
    return _textView;
}
-(UIView *)bgKeyboardView{
    if (!_bgKeyboardView) {
        _bgKeyboardView=[[UIView alloc]init];
        _bgKeyboardView.backgroundColor=UIColorBg243Color;
        [_bgKeyboardView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    return _bgKeyboardView;
}
-(void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    self.textViewHeight=height;
    if (self.textViewHeight<=DefaultTextViewHeight) {
        self.textViewHeight=DefaultTextViewHeight;
    }else if (self.textViewHeight>=MaxTextViewHeight){
        self.textViewHeight=MaxTextViewHeight;
    }
    
    if (self.showFaceView) {
        self.mineHeight=self.textViewHeight+20+KFaceViewHeight;
    }else{
         self.mineHeight=self.textViewHeight+self.kbHeight+20;
    }
   
    [self updateConstraintsFram];
}
-(void)updateConstraintsFram{
    if (self.showFaceView) {
        self.mineHeight=self.textViewHeight+20+KFaceViewHeight;
    }
    if (self.isComment) {
          self.frame=CGRectMake(0, ScreenHeight-self.mineHeight, ScreenWidth, self.mineHeight);
        [self.bgKeyboardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.textViewHeight));
            make.top.equalTo(@(10));
            make.right.equalTo(@-55);
            make.left.equalTo(@10);
        }];
       
        if (self.showFaceView) {
            self.commentEmojyShowView.frame=CGRectMake(0, self.textViewHeight+20, ScreenWidth, KFaceViewHeight+self.bottomMargin);
        }else{
            self.commentEmojyShowView.frame=CGRectMake(0, ScreenWidth, ScreenWidth, KFaceViewHeight+self.bottomMargin);
        }
        if (self.frameChangeFrameBlock) {
          
            self.frameChangeFrameBlock(self.mineHeight);
        }
        self.topBgView.hidden=YES;
    }else{
        self.topBgView.hidden=NO;
        self.frame=CGRectMake(0, ScreenHeight-self.mineHeight-30, ScreenWidth, self.mineHeight+30);
        [self.bgKeyboardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.textViewHeight));
            make.top.equalTo(@(40));
            make.right.equalTo(@-55);
            make.left.equalTo(@10);
        }];
        if (self.frameChangeFrameBlock) {
            self.frameChangeFrameBlock(self.mineHeight+30);
        }
        if (self.showFaceView) {
//            self.commentfaceView.frame=CGRectMake(0, self.textViewHeight+20+30, ScreenWidth, KFaceViewHeight);
            self.commentEmojyShowView.frame=CGRectMake(0, self.textViewHeight+20+30, ScreenWidth, KFaceViewHeight+self.bottomMargin);
        }else{
//            self.commentfaceView.frame=CGRectMake(0, ScreenWidth, ScreenWidth, KFaceViewHeight);
            self.commentEmojyShowView.frame=CGRectMake(0, ScreenWidth, ScreenWidth, KFaceViewHeight+self.bottomMargin);
        }
    }
    

    
}
@end

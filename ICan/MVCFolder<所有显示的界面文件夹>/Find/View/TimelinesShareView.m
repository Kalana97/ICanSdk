//
//  TimelinesShareView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/11.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesShareView.h"
#import "PostMessageChoseFriendView.h"
#import "XMChatFaceView.h"
#import "EmojyShowView.h"
#import "SelectMembersViewController.h"
#import "QDNavigationController.h"
static CGFloat const KFaceViewHeight=300;
@interface TimelinesShareView ()<QMUITextViewDelegate,XMChatFaceViewDelegate>

@property(nonatomic,strong)UIView * whiteBgView;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)PostMessageChoseFriendView * choseFriendView;
@property(nonatomic,strong)UIImageView * faceImageView;
@property(nonatomic,strong)UIImageView * peopleImageView;

/** 当前的键盘的高度 */
@property(nonatomic, assign) CGFloat kbHeight;
/** iphonex机型和其他机型的区别 */
@property(nonatomic, assign) CGFloat margin;
//键盘弹出的时间
@property(nonatomic, assign) CGFloat duration;
/**表情菜单*/
@property (strong, nonatomic) XMChatFaceView *faceView;

@property(nonatomic, strong) EmojyShowView *timelineShareEmojyShowView;
@property (nonatomic, assign) BOOL faceInput;
@property (nonatomic,assign) float whiteBgViewHeight;
@property(nonatomic, assign) float inputTextViewHeight;

@end

@implementation TimelinesShareView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.margin=isIPhoneX?37:0;
        self.inputTextViewHeight=0;
        self.backgroundColor=UIColorMakeWithRGBA(27, 25, 39, 0.8);
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTimelinesShareView)];
        [self addGestureRecognizer:tap];
        [self setUpView];
    }
    
    return self;
}
-(void)addNotification{
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark 键盘通知
-(void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary*userInfo = [noti userInfo];
    // 1,取出键盘动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin));
            make.bottom.equalTo(@0);
        }];
        [self layoutIfNeeded];
    }];
    
}


-(void)keyboardWillShow:(NSNotification *)noti {
    //获取键盘的高度
    NSDictionary*userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self. kbHeight = [value CGRectValue].size.height;
    // 1,取出键盘动画的时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.duration = duration;
    [self hiddenFaceView];
    
}

- (void)keyboardDidShow:(NSNotification *)noti {
    //获取键盘的高度
    NSDictionary*userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self. kbHeight = [value CGRectValue].size.height;
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

-(void)hiddenFaceView{
    self.faceInput = false;
    [self.faceImageView setImage:[UIImage imageNamed:@"icon_timeline_expression"]];
    [UIView animateWithDuration:self.duration animations:^{
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin));
            make.bottom.equalTo(@(-self.kbHeight+self.margin));
        }];
        self.timelineShareEmojyShowView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.margin);
        [self layoutIfNeeded];
    }];
    
    
}
-(void)hiddenBgWhiteView{
    [UIView animateWithDuration:self.duration animations:^{
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin));
            make.bottom.equalTo(@0);
        }];
        [self layoutIfNeeded];
    }];
}


-(void)showTimelinesShareView{
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    [self addNotification];
    [window addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}
-(void)hiddenTimelinesShareView{
    [self removeFromSuperview];
    self.textView.text=@"";
    [self removeNotification];
    [self hiddenFaceView];
    [self hiddenBgWhiteView];
}

-(void)showKeyBoard{
    if (!self.faceInput) {
        [self.textView becomeFirstResponder];
    }
}
#pragma mark==  处理 @ 用户的 ==
- (void)dealWithAtUserMessageWithShowName:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress{
    NSString *message = self.textView.text;
    NSArray * rangeArray=[self rangeOfSubString:@"@" inString:message];
    NSValue *rangeValue=[rangeArray lastObject];
    NSRange atRange =[rangeValue rangeValue];
    NSMutableString * messageMustr=[NSMutableString stringWithString:message];
    [messageMustr insertString:[NSString stringWithFormat:@"%@ ",showName] atIndex:atRange.location+1];
    self.textView.text = messageMustr;
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:4];
    // 用户的user
    infoDic[@"userId"] = userId;
    // 用户的昵称
    infoDic[@"remark"] = showName;
    // 用户在textView的末尾位置
    infoDic[@"location"] = [NSNumber numberWithInteger: atRange.location+showName.length+1];
    // 用户所占的长度
    infoDic[@"length"] = [NSNumber numberWithInteger:showName.length + 2];
    [self.atMemberArr addObject:infoDic];
    [self.textView becomeFirstResponder];
}
-(NSMutableArray *)atMemberArr{
    if (!_atMemberArr) {
        _atMemberArr=[NSMutableArray array];
    }
    return _atMemberArr;
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}
-(void)dealWithAtContent:(NSString *)content{
    self.textView.text = [NSString stringWithFormat:@"%@ %@",self.textView.text,content];
    if (!self.faceInput) {
        [self.textView becomeFirstResponder];
    }
}

-(void)setUpView{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(158+self.margin));
        make.bottom.equalTo(@0);
    }];
    [self.whiteBgView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
        make.width.height.equalTo(@35);
    }];
    [self.whiteBgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(-10);
        
    }];
    [self.whiteBgView addSubview:self.choseFriendView];
    [self.choseFriendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(10);
    }];
    
    [self.whiteBgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.bottom.equalTo(@(-50-self.margin));
    }];
    [self.whiteBgView addSubview:self.faceImageView];
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@(-20-self.margin));
        make.width.height.equalTo(@22);
        
    }];
    
    [self.whiteBgView addSubview:self.peopleImageView];
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.faceImageView.mas_right).offset(20);
        make.width.height.equalTo(@21);
        make.centerY.equalTo(self.faceImageView.mas_centerY);
    }];
    
    [self.whiteBgView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.faceImageView.mas_centerY);
        make.height.equalTo(@30);
        make.right.equalTo(@-10);
        make.width.equalTo(@70);
        
    }];
    [self addSubview:self.timelineShareEmojyShowView];
    
    
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
     if (text.length == 0){
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
        }else{
            for (NSDictionary *infoDic in self.atMemberArr) {
                if ([infoDic[@"location"] integerValue] == range.location) {
                    NSInteger indexLocation = [infoDic[@"location"] integerValue];
                    NSInteger length = [infoDic[@"length"] integerValue];
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(indexLocation - (length -1) , length - 1 ) withString:@""];
                    [textView setSelectedRange:NSMakeRange(indexLocation, 0)];
                    NSString*userId=infoDic[@"userId"];
                    [self.atMemberArr removeObject:infoDic];
                    NSMutableArray*array=[NSMutableArray arrayWithArray:self.reminders];
                    for (UserMessageInfo * user in self.reminders) {
                        if ([userId isEqualToString:user.userId]) {
                            [array removeObject:user];
                            break;
                        }
                    }
                    self.reminders = [NSMutableArray arrayWithArray:array];
                    return YES;
                }
            }
        }
    }
    return YES;
}
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    self.inputTextViewHeight=height>41?height-41:0;
    if (self.faceInput) {
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin+self.inputTextViewHeight));
            make.bottom.equalTo(@(-KFaceViewHeight));
        }];
    }else{
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin+self.inputTextViewHeight));
            make.bottom.equalTo(@(-self.kbHeight+self.margin));
        }];
    }
    
    
}
//白色背景 放置按钮
-(UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc]init];
        _whiteBgView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_whiteBgView addGestureRecognizer:tap];
    }
    return _whiteBgView;
}

-(void)tapAction{
    
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView layerWithCornerRadius:17.5 borderWidth:0 borderColor:nil];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager sharedManager].headImgUrl] placeholderImage:[UIImage imageNamed:BoyDefault]];
    }
    
    return _iconImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel leftLabelWithTitle:[UserInfoManager sharedManager].nickname font:15 color:UIColor252730Color];
    }
    return _nameLabel;
}
-(PostMessageChoseFriendView *)choseFriendView{
    if (!_choseFriendView) {
        _choseFriendView = [PostMessageChoseFriendView new];
        //视频和分享发帖，选择权限默认公开去掉下拉小三角
        NSString * leftIconImageString= @"icon_timeline_post_setting_open";;
        NSString*string=@"Public".icanlocalized;
        NSAttributedString*nullString= [[NSAttributedString alloc]initWithString:@" "];
        NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithAttributedString:nullString];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [UIImage imageNamed:leftIconImageString];
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds = CGRectMake(0, 0, 11 , 11);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [att appendAttributedString:imageStr];
        [att appendAttributedString:nullString];
        [att appendAttributedString:[[NSAttributedString alloc]initWithString:string]];
        [att appendAttributedString:nullString];
        _choseFriendView.centerLabel.attributedText=att;
    }
    
    return _choseFriendView;
}
- (XMChatFaceView *)faceView {
    if (!_faceView) {
        _faceView = [[XMChatFaceView alloc] initWithFrame:(CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight))];
        _faceView.backgroundColor = UIColor.redColor;
        _faceView.delegate = self;
        
    }
    return _faceView;
}
-(EmojyShowView *)timelineShareEmojyShowView{
    if (!_timelineShareEmojyShowView) {
        _timelineShareEmojyShowView=[[EmojyShowView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.margin)];
        _timelineShareEmojyShowView.backgroundColor = UIColor.whiteColor;
        [_timelineShareEmojyShowView setSendButtonHidden:YES];
        @weakify(self);
        _timelineShareEmojyShowView.selectEmojyBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            self.textView.text = [self.textView.text stringByAppendingString:text];
        };
        _timelineShareEmojyShowView.deleteBlock = ^{
            @strongify(self);
            if (self.textView.text.length>0) {
                NSRange lastRange = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.textView.text.length-1];
                self.textView.text = [self.textView.text stringByReplacingCharactersInRange:lastRange withString:@""];
            }
            
        };
    }
    return _timelineShareEmojyShowView;
}

-(QMUITextView *)textView{
    if (!_textView) {
        _textView = [[QMUITextView alloc]init];
        _textView.delegate =self;
        _textView.placeholder = @"What's on your mind...".icanlocalized;
        _textView.placeholderColor = UIColor153Color;
        _textView.font =[UIFont systemFontOfSize:15.0];
        _textView.backgroundColor = UIColor.whiteColor;
        _textView.textColor = UIColor252730Color;
        
    }
    return _textView;
}


-(UIImageView *)faceImageView{
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_timeline_expression"]];
        _faceImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(faceImageViewAction)];
        [_faceImageView addGestureRecognizer:tap];
    }
    return _faceImageView;
}
-(void)faceImageViewAction{
    self.faceInput=!self.faceInput;
    if (self.faceInput) {
        [self.faceImageView setImage:[UIImage imageNamed:@"chat_funtion_keyboard_select"]];
        [self.textView resignFirstResponder];
        [UIView animateWithDuration:0.35 animations:^{
            self.timelineShareEmojyShowView.frame=CGRectMake(0, ScreenHeight-KFaceViewHeight-self.margin, ScreenWidth, KFaceViewHeight+self.margin);
            [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.height.equalTo(@(158+self.margin+self.inputTextViewHeight));
                make.bottom.equalTo(@(-KFaceViewHeight));
            }];
            [self layoutIfNeeded];
        }];
    }else{
        [self.faceImageView setImage:[UIImage imageNamed:@"icon_timeline_expression"]];
        [self.textView becomeFirstResponder];
        self.timelineShareEmojyShowView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.margin);
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(158+self.margin+self.inputTextViewHeight));
            make.bottom.equalTo(@(-self.kbHeight+self.margin));
        }];
    }
}
-(UIImageView *)peopleImageView{
    if (!_peopleImageView) {
        _peopleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_timeline_at"]];
        _peopleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(peopleImageViewAction)];
        [_peopleImageView addGestureRecognizer:tap];
    }
    return _peopleImageView;
}
#pragma mark - 选择要@的人
-(void)peopleImageViewAction{
    SelectMembersViewController * vc = [SelectMembersViewController new];
    [self hiddenTimelinesShareView];
    vc.selectMemberType=SelectMenbersType_Timelines;
    vc.currentSelectAtUser = self.reminders;
    vc.cancelBlock = ^{
        [self showTimelinesShareView];
        for (UserMessageInfo*messageInfo in self.reminders) {
            self.textView.text = [NSString stringWithFormat:@"%@@", self.textView.text];
            [self dealWithAtUserMessageWithShowName:messageInfo.nickname userId:messageInfo.userId longPress:NO];
        }
    };
    @weakify(self);
    vc.addTimelinesAtMemberSuccessBlock = ^(NSArray *atArray) {
        @strongify(self);
        [self showTimelinesShareView];
        self.reminders = [NSMutableArray arrayWithArray:atArray];
        for (UserMessageInfo*messageInfo in self.reminders) {
            self.textView.text = [NSString stringWithFormat:@"%@@", self.textView.text];
            [self dealWithAtUserMessageWithShowName:messageInfo.nickname userId:messageInfo.userId longPress:NO];
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QDNavigationController * nav = [[QDNavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[AppDelegate shared] presentViewController:nav animated:YES completion:nil];
    });
    
}
-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton dzButtonWithTitle:@"tabbar.share".icanlocalized image:nil backgroundColor:UIColorMake(19, 132, 255) titleFont:15 titleColor:UIColor.whiteColor target:self action:@selector(shareAction)];
        [_shareBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    
    return _shareBtn;
}

-(void)shareAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(timelinesShareViewShareAction)]) {
        [self.delegate timelinesShareViewShareAction];
    }
    [self hiddenTimelinesShareView];
    
    
}
/**
 当前@的人
 */
-(NSMutableArray *)reminders{
    if (!_reminders) {
        _reminders=[NSMutableArray array];
    }
    return _reminders;
}
@end

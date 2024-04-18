//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/9/2020
- File name:  PayReceiptMoneyHeaderView.m
- Description:
- Function List:
*/
        

#import "PayReceiptMoneyHeaderView.h"
#import "WCDBManager+UserMessageInfo.h"
@interface PayReceiptMoneyHeaderView()<QMUITextFieldDelegate>
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *tipsCountLabel;

@property(nonatomic, strong) UILabel *yangLabel;

@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) UIButton *addCommentButton;


@property(nonatomic, strong) UIButton *sureButton;
@end
@implementation PayReceiptMoneyHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor=UIColorViewBgColor;
    }
    return self;
}
-(void)setUserId:(NSString *)userId{
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
        [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        self.nameLabel.text=info.remarkName?:info.nickname;
    }];
}
-(void)setUpView{
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-30);
        make.width.height.equalTo(@45);
        make.top.equalTo(@30);
    }];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.right.bottom.equalTo(@0);
    }];
    [self.bgView addSubview:self.tipsCountLabel];
    [self.tipsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@20);
    }];
    [self.bgView addSubview:self.yangLabel];
    [self.yangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(self.tipsCountLabel.mas_bottom).offset(30);
        make.width.equalTo(@30);
    }];
    [self.bgView addSubview:self.moneytextField];
    [self.moneytextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yangLabel.mas_right).offset(13.5);
        make.centerY.equalTo(self.yangLabel.mas_centerY);
        make.height.equalTo(@40);
        make.right.equalTo(@-20);
    }];
    [self.bgView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-20);
        make.height.equalTo(@1);
        make.top.equalTo(self.moneytextField.mas_bottom).offset(20);
    }];
    [self.bgView addSubview:self.addCommentButton];
    [self.addCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.height.equalTo(@25);
        make.width.equalTo(@70);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
    }];
    [self.bgView addSubview:self.commentTextView];
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(@30);
       make.height.equalTo(@50);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.right.equalTo(@-20);
        
    }];
    [self.bgView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@45);
        make.bottom.equalTo(@(-TabBarHeight));
        
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */

    // 判断是否有小数点
    BOOL isHaveDian=NO;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
//        BXLog(@"single = %c",single);
    
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
//            [MBProgressHUD bwm_showTitle:@"您的输入格式不正确" toView:self hideAfter:1.0];
            return NO;
        }
    
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
//            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
//                    [MBProgressHUD bwm_showTitle:@"小数点后最多有两位小数" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
  
    }

    return YES;
}


-(void)textFiledDidChange:(NSNotification*)noti{
    if (self.moneytextField.text.length>0) {//如果输入的是小数点 那么变成0.
        NSString*fitst=[self.moneytextField.text substringWithRange:NSMakeRange(0, 1)];
        if ([fitst isEqualToString:@"."]) {
            self.moneytextField.text=@"0.";
        }
    }
    
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        
    }
    return _iconImageView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel leftLabelWithTitle:@"Pay to individual".icanlocalized font:14 color:UIColorThemeMainTitleColor];
    }
    return _tipsLabel;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel leftLabelWithTitle:@"" font:14 color:UIColorThemeMainSubTitleColor];
    }
    return _nameLabel;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor=UIColorMake(247, 247, 247);
        UIBezierPath *addmaskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100-NavBarHeight) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(32/2,32/2)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-100-NavBarHeight);
        maskLayer.path = addmaskPath.CGPath;
        _bgView.layer.mask = maskLayer;
        
    }
    return _bgView;
}
-(UILabel *)tipsCountLabel{
    if (!_tipsCountLabel) {
        _tipsCountLabel=[UILabel leftLabelWithTitle:@"Amount".icanlocalized font:12 color:UIColorThemeMainTitleColor];
    }
    return _tipsCountLabel;
}
-(UILabel *)yangLabel{
    if (!_yangLabel) {
        _yangLabel=[UILabel leftLabelWithTitle:@"￥" font:36 color:UIColorThemeMainTitleColor];
    }
    return _yangLabel;
}

-(QMUITextField *)moneytextField{
    if (!_moneytextField) {
        _moneytextField=[[QMUITextField alloc]init];
        _moneytextField.textColor=UIColorThemeMainTitleColor;
        _moneytextField.font=[UIFont systemFontOfSize:36];
        _moneytextField.keyboardType=UIKeyboardTypeDecimalPad;
        _moneytextField.delegate=self;
    }
    return _moneytextField;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
    }
    return _lineView;
}

-(UIButton *)addCommentButton{
    if (!_addCommentButton) {
        _addCommentButton=[UIButton dzButtonWithTitle:@"Add notes".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(addCommentButtonAction)];
    }
    return _addCommentButton;
}
-(void)addCommentButtonAction{
    self.commentTextView.hidden=NO;
    self.addCommentButton.hidden=YES;
}

-(QMUITextView *)commentTextView{
    if (!_commentTextView) {
        _commentTextView=[[QMUITextView alloc]init];
        _commentTextView.textColor=UIColorThemeMainTitleColor;
        _commentTextView.hidden=YES;
        _commentTextView.placeholderColor=UIColorThemeMainSubTitleColor;
        _commentTextView.font=[UIFont systemFontOfSize:14];
        _commentTextView.placeholder=@"Add remarks (within 50 characters)".icanlocalized;
        _commentTextView.maximumTextLength=50;
        _commentTextView.backgroundColor=UIColor.clearColor;
    }
    return _commentTextView;
}
-(UIButton *)sureButton{
    if (!_sureButton) {
       
        _sureButton=[UIButton dzButtonWithTitle:@"surePay".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:14 titleColor:UIColor.whiteColor target:self action:@selector(sureButtonAction)];
        [_sureButton layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    }
    return _sureButton;
}
-(void)sureButtonAction{
    if (self.sureButtonBlock) {
        self.sureButtonBlock();
    }
}
@end


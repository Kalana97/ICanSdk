//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 5/11/2019
 - File name:  SearchHeadView.m
 - Description:
 - Function List:
 */


#import "TranspondHeadView.h"
@interface TranspondHeadView()<QMUITextFieldDelegate>
@property(nonatomic, strong)   UIImageView *searchTipsImageView;
@property(nonatomic, strong)   QMUITextField *searTextField;
@property(nonatomic, strong)   UIView *bgView;

@property(nonatomic, strong) UIControl *gotoNewChatCon;
@property(nonatomic, strong) UILabel *creatLabel;
@property(nonatomic, strong) UIImageView *arrowImageView;

@end
@implementation TranspondHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor=UIColor.whiteColor;
        [self addNotification];
    }
    return self;
}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.searTextField.markedTextRange) {
        self.searchDidChangeBlock(self.searTextField.text);
    }
}
-(void)setSearchTextFiledPlaceholderString:(NSString *)searchTextFiledPlaceholderString{
    _searchTextFiledPlaceholderString = searchTextFiledPlaceholderString;
    self.searTextField.placeholder=searchTextFiledPlaceholderString;
}

-(void)setUpView{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.height.equalTo(@35);
        make.right.equalTo(@-10);
    }];
    [self.bgView addSubview:self.searchTipsImageView];
    [self.searchTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    [self.bgView addSubview:self.searTextField];
    [self.searTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTipsImageView.mas_right).offset(10);
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    [self addSubview:self.gotoNewChatCon];
    [self.gotoNewChatCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(@0);
        make.top.equalTo(self.bgView.mas_bottom);
    }];
    [self.gotoNewChatCon addSubview:self.creatLabel];
    [self.creatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.gotoNewChatCon.mas_centerY);
    }];
    [self.gotoNewChatCon addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.gotoNewChatCon.mas_centerY);
        make.width.equalTo(@8);
        make.height.equalTo(@16);
    }];
}
-(UIControl *)gotoNewChatCon{
    if (!_gotoNewChatCon) {
        _gotoNewChatCon=[[UIControl alloc]init];
        [_gotoNewChatCon addTarget:self action:@selector(gotoNewChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoNewChatCon;
}
-(UILabel *)creatLabel{
    if (!_creatLabel) {
        _creatLabel=[UILabel leftLabelWithTitle:@"CreatNewChat".icanlocalized font:16 color:UIColor252730Color];
    }
    return _creatLabel;
}
-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_arrow_right_line")];
    }
    return _arrowImageView;
}
-(UIImageView *)searchTipsImageView{
    if (!_searchTipsImageView) {
        _searchTipsImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_search")];
    }
    return _searchTipsImageView;
}
-(QMUITextField *)searTextField{
    if (!_searTextField) {
        _searTextField=[[QMUITextField alloc]init];
        _searTextField.backgroundColor=[UIColor clearColor];
        _searTextField.textColor=UIColor252730Color;
        _searTextField.delegate =self;
        _searTextField.font=[UIFont systemFontOfSize:15];
        _searTextField.placeholder=[@"friend.search.tipText" icanlocalized:@"搜索联系人"];
        _searTextField.placeholderColor=UIColor153Color;
    }
    return _searTextField;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        [_bgView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
        _bgView.backgroundColor=UIColorBg243Color;
    }
    return _bgView;
}
-(void)gotoNewChat{
    if (self.gotoNewChatBlock) {
        self.gotoNewChatBlock();
    }
}
@end

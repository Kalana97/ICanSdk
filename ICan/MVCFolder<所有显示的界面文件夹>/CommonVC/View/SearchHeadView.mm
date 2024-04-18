//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 5/11/2019
 - File name:  SearchHeadView.m
 - Description:
 - Function List:
 */


#import "SearchHeadView.h"
@interface SearchHeadView()<QMUITextFieldDelegate>


@end
@implementation SearchHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor= UIColorViewBgColor;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
    
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
        make.right.bottom.equalTo(@-10);
    }];
    [self.bgView addSubview:self.searchTipsImageView];
    [self.searchTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.bgView addSubview:self.searTextField];
    [self.searTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTipsImageView.mas_right).offset(10);
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@-10);
    }];
}
-(void)updateConstraint{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@0);
        make.right.bottom.equalTo(@-10);
    }];
    
    [self.searchTipsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY).offset(-5);
    }];
    
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
        _searTextField.textColor=UIColorThemeMainTitleColor;
        _searTextField.delegate =self;
        _searTextField.font=[UIFont systemFontOfSize:15];
        _searTextField.placeholder=[@"friend.search.tipText" icanlocalized:@"搜索联系人"];
        _searTextField.placeholderColor=UIColorThemeMainSubTitleColor;
        _searTextField.returnKeyType = UIReturnKeySearch;
    }
    return _searTextField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchBlock) {
        self.searchBlock();
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.tapBlock) {
        self.tapBlock();
    }
    
    return self.shouShowKeybord;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        [_bgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        _bgView.backgroundColor=UIColorSearchBgColor;
    }
    return _bgView;
}
@end

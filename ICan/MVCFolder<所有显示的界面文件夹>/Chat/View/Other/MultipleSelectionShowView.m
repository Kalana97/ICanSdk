//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  multipleSelectionShowView.m
- Description:
- Function List:
*/
        

#import "MultipleSelectionShowView.h"
@interface MultipleSelectionShowView()
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIButton *collectButton;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *transpondButton;
@property(nonatomic, strong) UIButton *deleteButton;

@end
@implementation MultipleSelectionShowView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}
-(void)setAuthorityType:(NSString *)authorityType{
    _authorityType=authorityType;
    if ([authorityType isEqualToString:AuthorityType_circle]) {
        self.transpondButton.hidden=YES;
        [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.left.equalTo(self.mas_centerX).offset(10);
            make.top.equalTo(@15);
        }];
        [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.right.equalTo(self.mas_centerX).offset(-10);
            make.top.equalTo(@15);
        }];
    }
}
-(void)setEnable:(BOOL)enable{
    _enable=enable;
    self.collectButton.selected=self.transpondButton.selected=self.deleteButton.selected=enable;
    self.collectButton.enabled=self.transpondButton.enabled=self.deleteButton.enabled=enable;
}
-(void)setUpView{
    self.backgroundColor=UIColorBg243Color;
    [self addSubview:self.collectButton];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@15);
    }];
    [self addSubview:self.transpondButton];
    [self.transpondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.right.equalTo(self.collectButton.mas_left).offset(-50);
        make.top.equalTo(@15);
    }];
   
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.left.equalTo(self.collectButton.mas_right).offset(50);
        make.top.equalTo(@15);
    }];
}
-(UIView *)topView{
    if (!_topView) {
        _topView=[[UIView alloc]init];
        _topView.backgroundColor=UIColorBg243Color;
    }
    return _topView;
}
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(deleteButtonAction)];
        [_deleteButton setBackgroundImage:UIImageMake(@"icon_chat_delete") forState:UIControlStateSelected];
        [_deleteButton setBackgroundImage:UIImageMake(@"icon_chat_delete_g") forState:UIControlStateNormal];
        _deleteButton.enabled=NO;
        
    }
    return _deleteButton;
}
-(void)deleteButtonAction{
    !self.deleteButtonActionBlock?:self.deleteButtonActionBlock();
}

-(UIButton *)transpondButton{
    if (!_transpondButton) {
        _transpondButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(transpondButtonAction)];
        [_transpondButton setBackgroundImage:UIImageMake(@"icon_chat_forward") forState:UIControlStateSelected];
        [_transpondButton setBackgroundImage:UIImageMake(@"icon_chat_forward_g") forState:UIControlStateNormal];
        _transpondButton.enabled=NO;
    }
    return _transpondButton;
}
-(void)transpondButtonAction{
    !self.transpondButtonActionBlock?:self.transpondButtonActionBlock();
}
-(UIButton *)collectButton{
    if (!_collectButton) {
        _collectButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(collectButtonAction)];
        [_collectButton setBackgroundImage:UIImageMake(@"icon_chat_Collect") forState:UIControlStateSelected];
        [_collectButton setBackgroundImage:UIImageMake(@"icon_chat_Collect_g") forState:UIControlStateNormal];
        _collectButton.enabled=NO;
        
    }
    return _collectButton;
}
-(void)collectButtonAction{
    !self.collectButtonActionBlock?:self.collectButtonActionBlock();
}
@end

//
//  TranslatorViewMenue.m
//  ICan
//
//  Created by Sathsara on 2023-02-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "TranslatorViewMenue.h"

@interface TranslatorViewMenue()<TranslatorViewMenueDelegate>
@property(nonatomic, strong) UIView *mainView;
@property(nonatomic, strong) UIImageView *translateIcon;
@property(nonatomic, strong) UIImageView *arrowIcon;
@property(nonatomic, strong) UILabel *useButton;
@property(nonatomic, strong) UIImageView *useButtonIcon;
@property(nonatomic, strong) UIButton *useConvertedTextButton;
@property(nonatomic, strong) UIButton *changeLanguageButton;
@end

@implementation TranslatorViewMenue
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    [self addSubview:self.mainView];
    //Translate Icon
    [self.mainView addSubview:self.translateIcon];
    [self.translateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.width.height.equalTo(@15);
    }];
    //Translate Language
    [self.mainView addSubview:self.languageNameLabel];
    [self.languageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.translateIcon.mas_right).offset(15);
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.height.equalTo(@26);
    }];
    //ArrowIcon
    [self.mainView addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.languageNameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.height.width.equalTo(@15);
    }];
    //TranslatedTextLabel
    [self.mainView addSubview:self.translatedTextLabel];
    [self.translatedTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowIcon.mas_right).offset(5);
        make.centerY.equalTo(self.mainView.mas_centerY);
        make.height.equalTo(@26);
    }];
    //Use button icon ----> hide the use button but keep it for future uses
//    [self.mainView addSubview:self.useButtonIcon];
//    [self.useButtonIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mainView.mas_right).inset(10);
//        make.centerY.equalTo(self.mainView.mas_centerY);
//        make.height.width.equalTo(@15);
//    }];
    //Use btn text----> hide the use button but keep it for future uses
//    [self.mainView addSubview:self.useButton];
//    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.useButtonIcon.mas_left).inset(10);
//        make.centerY.equalTo(self.mainView.mas_centerY);
//        make.left.greaterThanOrEqualTo(self.translatedTextLabel.mas_right).offset(10);
//        make.height.equalTo(@26);
//    }];
    //Use converted text
    [self.mainView addSubview:self.changeLanguageButton];
    [self.changeLanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(self.arrowIcon.mas_right);
        make.top.equalTo(self.mainView.mas_top);
        make.bottom.equalTo(self.mainView.mas_bottom);
    }];
    //Use converted text----> hide the use button but keep it for future uses
//    [self.mainView addSubview:self.useConvertedTextButton];
//    [self.useConvertedTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.useButton.mas_left);
//        make.right.equalTo(self.useButtonIcon.mas_right);
//        make.top.equalTo(self.useButtonIcon.mas_top);
//        make.height.equalTo(@26);
//    }];
}

-(void)addTopBoarder:(BOOL) shouldAdd{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    if(shouldAdd == YES){
        [self.mainView addSubview:lineView];
    }
}

- (UIView *)mainView {
    if(!_mainView){
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _mainView.backgroundColor = UIColorViewBgColor;
    }
    return _mainView;
}

-(UIImageView *)translateIcon{
    if (!_translateIcon) {
        _translateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [_translateIcon setImage:[UIImage imageNamed:@"1xtranslation"]];
        [_translateIcon setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _translateIcon;
}

-(UILabel *)languageNameLabel{
    if (!_languageNameLabel) {
        _languageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        _languageNameLabel.text = @"";
        _languageNameLabel.textColor = UIColorGray;
    }
    return _languageNameLabel;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [_arrowIcon setImage:[UIImage imageNamed:@"cheveron-right"]];
        [_arrowIcon setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _arrowIcon;
}

-(UILabel *)translatedTextLabel{
    if (!_translatedTextLabel) {
        _translatedTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        _translatedTextLabel.text = @"";
    }
    return _translatedTextLabel;
}

-(UILabel *)useButton{
    if (!_useButton) {
        _useButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        _useButton.text = @"Use".icanlocalized;
        _useButton.textColor = UIColorBlue;
    }
    return _useButton;
}

-(UIImageView *)useButtonIcon{
    if (!_useButtonIcon) {
        _useButtonIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [_useButtonIcon setImage:[UIImage imageNamed:@"trans"]];
        [_useButtonIcon setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _useButtonIcon;
}

-(UIButton *)changeLanguageButton{
    if (!_changeLanguageButton) {
        _changeLanguageButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(didSelectChangeLanguage)];
    }return _changeLanguageButton;
}

-(UIButton *)useConvertedTextButton{
    if (!_useConvertedTextButton) {
        _useConvertedTextButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(didSelectUseConvertedText)];
    }return _useConvertedTextButton;
}

-(void)didSelectChangeLanguage{
    NSLog(@"Clicked");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChangeLanguage)]) {
        [self.delegate clickChangeLanguage];
    }
}

-(void)didSelectUseConvertedText{
    NSLog(@"Clicked Change");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickUseConvertedTextLanguage)]) {
        NSString * valDaya = [self.delegate clickUseConvertedTextLanguage];
        NSLog(@"%@",valDaya);
    }
}

-(void)translateTextString:(NSString *) langCode{

    [[NetworkRequestManager shareManager]translateGoogleTextString:langCode text:@"Dog" success:^(NSString *translateText) {
        NSLog(@"%@",translateText);
    } failure:^(NSError *error) {
        NSLog(@"Fail");
    }];
    
}

-(void)hideTranslateView{
    self.hidden = YES;
    [self addTopBoarder:NO];
}

-(void)showTranslateView{
    self.hidden = NO;
    [self addTopBoarder:YES];
}

@end

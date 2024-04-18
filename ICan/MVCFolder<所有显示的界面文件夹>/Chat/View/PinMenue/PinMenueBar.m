//
//  PinMenueBar.m
//  ICan
//
//  Created by MAC on 2023-03-13.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "PinMenueBar.h"
#import "PinMessageTableViewController.h"

@interface PinMenueBar()
@property(nonatomic, strong) UIView *mainView;
@property(nonatomic,strong) UIView *leftBorder;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *pinButton;
@property(nonatomic,strong) UIButton *tabButton;
@end

@implementation PinMenueBar

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    [self addSubview:self.mainView];
    [self addTopBoarder:YES];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.messageLabel];
    [self.mainView addSubview:self.pinButton];
    [self.mainView addSubview:self.tabButton];
    [self.pinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-5);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [self.mainView addSubview:self.leftBorder];
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.height.equalTo(@(self.frame.size.height - 2));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.leftBorder.left)).offset(20);
        make.top.equalTo(@(self.top)).offset(7);

    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.leftBorder.left)).offset(20);
        make.top.equalTo(@(self.titleLabel.bottom)).offset(27);
        make.right.equalTo(@(self.right)).offset(-90);
    }];
    [self.tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.left));
        make.right.equalTo(@(self.right)).offset(-80);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
}

- (UIView *)mainView {
    if(!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        [_mainView setBackgroundColor:UIColorMakeHEXCOLOR(0xF8F3FF)];
    }
    return _mainView;
}

- (UIView *)leftBorder {
    if(!_leftBorder) {
        _leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_leftBorder setBackgroundColor:UIColorMakeHEXCOLOR(0x9B51E0)];
    }
    return _leftBorder;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-15, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = UIColorMakeHEXCOLOR(0x9B51E0);
        _titleLabel.text = @"PinMsg".icanlocalized;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 30)];
        _messageLabel.numberOfLines = 1;
        _messageLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _messageLabel;
}

- (UIButton*)pinButton {
    if(!_pinButton) {
        _pinButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(pinButtonAction)];
        UIImage *namedImage = [UIImage imageNamed:@"pin_icon_chatView"];
        [_pinButton setImage:namedImage forState:UIControlStateNormal];
        _pinButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _pinButton;
}

- (UIButton *)tabButton {
    if(!_tabButton) {
        _tabButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.clearColor target:self action:@selector(tabButtonAction)];
    }
    return _tabButton;
}

- (void)addTopBoarder:(BOOL) shouldAdd {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    if(shouldAdd == YES){
        [self.mainView addSubview:lineView];
    }
}

- (void)pinButtonAction {
    PinMessageTableViewController *nav =[[PinMessageTableViewController alloc]init];
    nav.messagesArray = self.messagesArray;
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentViewController presentViewController:nav animated:YES completion:nil];
}

- (void)tabButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapOnPinMenueButton)]) {
        [self.delegate tapOnPinMenueButton];
    }
}

- (void)hiddenView {
    self.hidden = YES;
    [self addTopBoarder:NO];
}

- (void)showView {
    self.hidden = NO;
    [self addTopBoarder:YES];
}

- (NSArray *)messagesArray {
    if(!_messagesArray) {
        _messagesArray = [[NSArray alloc]init];
    }
    return _messagesArray;
}

@end

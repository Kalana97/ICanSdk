//
//  RedEnvelopPayInPutView.m
//  OneChatAPP
//
//  Created by mac on 2017/2/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import "RedEnvelopPayInPutView.h"

// 中心符号圆点的大小
CGFloat const kWXInputViewSymbolWH = 8;

@interface RedEnvelopPayInPutView ()
// 装着所有格子中间的那个占位圆点
@property (nonatomic,strong) NSMutableArray *symbolArr;

@property (nonatomic, strong) id observer;

@end

@implementation RedEnvelopPayInPutView

#pragma mark - 视图创建方法
-(void)awakeFromNib{
    [super awakeFromNib];
    self.places=6;
    [self addTarget:self action:@selector(becomfi) forControlEvents:UIControlEventTouchUpInside];
}

-(void)becomfi{
    [self.textField becomeFirstResponder];
}

// 代码创建输入框视图
- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.places=6;
    }
    return self;
}

- (void)addNotification{

    // 回调键盘输入内容变化的通知
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * note) {
        NSUInteger length = self.textField.text.length;
        if (length == 1) {
            [self retrySetupContents:6];
        }
        
        if (length >= self.places && self.RedEnvelopPayInPutViewDidCompletion) {
            self.RedEnvelopPayInPutViewDidCompletion(self.textField.text);
        }

        if (length > self.places) {
            self.textField.text = [self.textField.text substringToIndex:self.places];
        }
        [self.symbolArr enumerateObjectsUsingBlock:^(CAShapeLayer *symbol, NSUInteger idx, BOOL * stop) {
            symbol.hidden = idx < length ? NO : YES;
        }];
    }];
}

- (void)setPlaces:(NSInteger)places{
    _places = places;
    if (places > 0) {
        [self setupContents:places];
    }
}

#pragma mark - 视图内部布局相关
- (void)setupContents:(NSInteger)pages{
    self.layer.borderWidth = 1;
    if ([UserInfoManager sharedManager].attemptCount != nil || [UserInfoManager sharedManager].isPayBlocked == YES){
        self.layer.borderColor = UIColorPasswordBoarder.CGColor;
        self.layer.backgroundColor = UIColorPasswordBg.CGColor;
    } else {
        self.layer.borderColor = UIColorSeparator.CGColor;
        self.layer.backgroundColor =  UIColorClear.CGColor;
    }
    
    // 创建分割线
    for (int i = 0; i < pages - 1; i++) {
        UIView *line = [[UIView alloc] init];
        if ([UserInfoManager sharedManager].attemptCount != nil || [UserInfoManager sharedManager].isPayBlocked == YES){
            line.backgroundColor = UIColorPasswordBoarder;
        } else {
            line.backgroundColor = UIColorSeparator;
        }
        [self addSubview:line];
    }
    
    // 创建中心原点
    for (int i = 0; i < pages; i++) {
        CAShapeLayer *symbol = [CAShapeLayer layer];
        symbol.fillColor = [UIColor blackColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kWXInputViewSymbolWH, kWXInputViewSymbolWH)];
        symbol.path = path.CGPath;
        symbol.hidden = YES;
        [self.layer addSublayer:symbol];
        
        // 将所有中心原点添加到数组中
        [self.symbolArr addObject:symbol];
    }
}

- (void)retrySetupContents:(NSInteger)pages{
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColorSeparator.CGColor;
    self.layer.backgroundColor =  UIColorClear.CGColor;
    
    // 创建分割线
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            subview.backgroundColor = UIColorSeparator;
        }
    }
    
    // 创建中心原点
    for (int i = 0; i < pages; i++) {
        CAShapeLayer *symbol = [CAShapeLayer layer];
        symbol.fillColor = [UIColor blackColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kWXInputViewSymbolWH, kWXInputViewSymbolWH)];
        symbol.path = path.CGPath;
        symbol.hidden = YES;
        [self.layer addSublayer:symbol];
        
        // 将所有中心原点添加到数组中
        [self.symbolArr addObject:symbol];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineX = 0;
    CGFloat lineY = 0;
    CGFloat lineW = 1;
    CGFloat lineH = self.frame.size.height;
    CGFloat margin = kWXInputViewSymbolWH * 0.5;
    
    CGFloat w = self.frame.size.width / self.places;
    
    for (int i = 0; i < self.places - 1; i++) {
        UIView *line = self.subviews[i];
        lineX = w * (i + 1);
        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    }
    
    for (int i = 0; i < self.symbolArr.count; i++) {
        CAShapeLayer *circle = self.symbolArr[i];
        circle.position = CGPointMake(w * (0.5 + i) - margin, self.frame.size.height * 0.5 - margin);
    }
}

#pragma mark - 共有方法
- (void)beginInput{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.secureTextEntry=YES;
        _textField.hidden = YES;
        _textField.textColor = UIColor102Color;
        [self addSubview:_textField];
        
    }
    [self.textField becomeFirstResponder];
    [self addNotification];
    
}

- (void)endInput{
    [self clearInputInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil;
    
}

- (void)clearInputInfo {
    self.textField.text =nil;
    [self.textField resignFirstResponder];
    [self.symbolArr enumerateObjectsUsingBlock:^(CAShapeLayer *symbol, NSUInteger idx, BOOL * stop) {
        
        symbol.hidden = YES;
    }];
}


#pragma mark - 懒加载
- (NSMutableArray *)symbolArr{
    if (_symbolArr == nil) {
        _symbolArr = [NSMutableArray array];
    }
    return _symbolArr;
}

+ (instancetype)inputView{
    return [[self alloc] init];
}
@end

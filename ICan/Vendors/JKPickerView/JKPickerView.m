//
//  JKPickerView.m
//  OneChatAPP
//
//  Created by mac on 2017/2/14.
//  Copyright © 2017年 DW. All rights reserved.
//

#import "JKPickerView.h"


@interface JKPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@end
#define KSuperHeight 260
@implementation JKPickerView

static UIButton *__cover;
static UIView *__superView;
static NSArray *__dataArray;
static id   __obj;
static void(^__dataBlock)(NSString *title);
static UIPickerView *__pickerView;

+(instancetype)sharedJKPickerView{
    static JKPickerView * jKPickerView;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        jKPickerView = [[JKPickerView alloc]init];
    });
    return jKPickerView;
    
}

#pragma mark -- 设置pickView --
- (UIPickerView *)setPickViewWithTarget:(id)target title:(NSString *)title leftItemTitle:(NSString *)leftTitle rightItemTitle:(NSString *)rightTitle leftAction:(SEL)leftAction rightAction:(SEL)rightAction dataArray:(NSArray *)dataArray dataBlock:(void(^)(id obj))dataBlock {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
//    if (@available(iOS 13.0, *)) {
//           [window setOverrideUserInterfaceStyle:(UIUserInterfaceStyleLight)];
//       } else {
//
//       }
    window.backgroundColor = [UIColor whiteColor];
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor clearColor];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [window addSubview:cover];
    __cover = cover;
    CGFloat bottomMagin=isIPhoneX?20:0;
   
    UIView *superView = [[UIView alloc] initWithFrame:(CGRectMake(0, ScreenHeight, ScreenWidth, KSuperHeight+bottomMagin))];
    [superView setBackgroundColor:[UIColor whiteColor]];
    [window addSubview:superView];
    
    [UIView animateWithDuration:0.3 animations:^{
        superView.frame = CGRectMake(0, ScreenHeight - KSuperHeight-bottomMagin, ScreenWidth, KSuperHeight+bottomMagin);
    }];
    __superView = superView;
    __dataArray = dataArray;
    __dataBlock = [dataBlock copy];
    if (__dataArray.count != 0) {
        __obj = __dataArray[0];
    }
    UIPickerView *pickview = [[UIPickerView alloc] initWithFrame:(CGRectMake(0, 44, ScreenWidth, 216))];
    pickview.backgroundColor = [UIColor clearColor];
    pickview.delegate = self;
    pickview.dataSource = self;
    [superView addSubview:pickview];
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    topView.backgroundColor=[UIColor whiteColor];
    UIButton * leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(15, 0, 60, 44);
    [leftButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [leftButton addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
    CGFloat rightWidth=[NSString widthForString:rightTitle withFont:[UIFont systemFontOfSize:17] height:20]+5;
    UIButton * rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(ScreenWidth-rightWidth-15, 0, rightWidth, 44);
    [rightButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [rightButton addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [topView addSubview:leftButton];
    [topView addSubview:rightButton];
    [superView addSubview:topView];
    UIView * bottomLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
    bottomLineView.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0  blue:235/255.0  alpha:1.0];
    [topView addSubview:bottomLineView];
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-128, 44)];
    titleLabel.text=title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=UIColor252730Color;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.centerX=superView.centerX;
    titleLabel.centerY=rightButton.centerY;
    [superView addSubview:titleLabel];
    __pickerView=pickview;
    return pickview;
}

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)inComponent animated:(BOOL)animated{
    [__pickerView selectRow:row  inComponent:inComponent animated:animated];
}
#pragma mark -- 点击遮盖 -
- (void)coverClick {
    
    [self removePickView];
}

#pragma mark -- 移除pickView --
- (void)removePickView {
    [__cover removeFromSuperview];
    __cover = nil;
    [UIView animateWithDuration:0.3 animations:^{
        __superView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
       
    }];
    __superView = nil;
    __dataArray = nil;
    __obj = nil;
    [__superView removeFromSuperview];
    
}

- (void)sureAction {
    if (__dataBlock) {
        __dataBlock(__obj);
        __dataBlock = nil;
    }
    
    [self removePickView];
}

#pragma mark -- pickViewDelegate -- pickViewDatasource --
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return __dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    return __dataArray[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    __obj = __dataArray[row];
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = (NSString *)__dataArray[row];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:title];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    return attributedString;
    
}

@end

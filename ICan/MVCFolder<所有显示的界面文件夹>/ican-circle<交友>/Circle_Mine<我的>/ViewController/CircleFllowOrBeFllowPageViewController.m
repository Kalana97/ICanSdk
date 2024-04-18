
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 13/7/2021
- File name:  CircleFllowOrBeFllowPageViewController.m
- Description:
- Function List:
*/
        

#import "CircleFllowOrBeFllowPageViewController.h"

@interface CircleFllowOrBeFllowPageViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>
@property(nonatomic, strong) NSArray *titleItems;
@property(nonatomic, strong) UIView *navBarView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@end

@implementation CircleFllowOrBeFllowPageViewController
-(instancetype)initWithCircleListType:(CircleListType)type{
    if (self=[super init]) {
        self.titleItems =@[@"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized,@"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized];
        self.titleColorSelected = UIColor252730Color;
        self.titleColorNormal = UIColor153Color;
        self.titleSizeNormal=15;
        self.titleSizeSelected=15;
        self.pageAnimatable=YES;
        self.menuItemWidth=ScreenWidth/2;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressWidth = 45;
        self.progressColor = UIColorMake(36, 127, 248);
        self.type=type;
        if (type==CircleListType_ILike) {
            self.selectIndex=0;
        }else{
            self.selectIndex=1;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=[NSString stringWithFormat:@"%@/%@",@"CircleMineShowUserImgTableViewCell.iLikeTipLabel".icanlocalized,@"CircleMineShowUserImgTableViewCell.likeMeTipLabel".icanlocalized];
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(NavBarHeight));
    }];
    [self.navBarView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    [self.navBarView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.centerX.equalTo(self.navBarView);
    }];
    
    
  
}
-(BOOL)preferredNavigationBarHidden{
    return NO;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.titleItems objectAtIndex:index];
}
 
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleItems.count;
}
 
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    CircleFllowOrBeFllowListViewController * vc = [[CircleFllowOrBeFllowListViewController alloc]init];
    if (index==0) {
        vc.circleListType=CircleListType_ILike;
    }else{
        vc.circleListType=CircleListType_LikeMe;
    }
    
    return vc;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, NavBarHeight, self.view.frame.size.width , 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0,originY , self.view.frame.size.width, self.view.frame.size.height - originY);
}


-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc]init];
        _navBarView.backgroundColor=UIColor.clearColor;
    }
    return _navBarView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel centerLabelWithTitle:@"CircleHomeListViewController.title".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}
-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.clearColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}
@end

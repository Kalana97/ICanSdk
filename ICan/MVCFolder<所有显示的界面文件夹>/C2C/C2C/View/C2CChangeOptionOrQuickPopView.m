//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/12/2021
- File name:  C2CChangeOptionOrQuickPopView.m
- Description:
- Function List:
*/
        

#import "C2CChangeOptionOrQuickPopView.h"
@interface C2CChangeOptionOrQuickPopView ()
/** 显示当前选择的自选还是快捷 */
@property (weak, nonatomic) IBOutlet UIControl *optionBgCon;
@property (weak, nonatomic) IBOutlet UILabel *selectPatternOptionalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectPatternImageView;
@property (weak, nonatomic) IBOutlet UIControl *quickBgCon;
@property (weak, nonatomic) IBOutlet UILabel *selectPatternQuickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectQuickImageView;
@end
@implementation C2CChangeOptionOrQuickPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer * optiontap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(optionAction)];
    [self.optionBgCon addGestureRecognizer:optiontap];
    
    UITapGestureRecognizer * quicktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quickAction)];
    [self.quickBgCon addGestureRecognizer:quicktap];
    //    "C2CMainViewControllerOption"="自选";
    //    "C2CMainViewControllerQuick"="快捷";
    self.selectPatternOptionalLabel.text = @"C2CMainViewControllerOption".icanlocalized;
    self.selectPatternQuickLabel.text = @"C2CMainViewControllerQuick".icanlocalized;
    [self optionAction];
}
-(IBAction)optionAction{
    self.selectPatternOptionalLabel.textColor = UIColorThemeMainColor;
    self.selectPatternImageView.hidden = NO;
    self.selectPatternQuickLabel.textColor = UIColor252730Color;
    self.selectQuickImageView.hidden = YES;
    [self hiddenView];
    !self.optionBlock?:self.optionBlock();
}
-(IBAction)quickAction{
    self.selectPatternOptionalLabel.textColor = UIColor252730Color;
    self.selectPatternImageView.hidden = YES;
    self.selectPatternQuickLabel.textColor = UIColorThemeMainColor;
    self.selectQuickImageView.hidden = NO;
    [self hiddenView];
    !self.quickBlock?:self.quickBlock();
}
-(void)hiddenView{
    self.hidden = YES;
    [self removeFromSuperview];
}

-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end

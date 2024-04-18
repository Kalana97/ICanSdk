
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 7/6/2021
- File name:  SureChatTipsView.m
- Description:
- Function List:
*/
        

#import "SureChatTipsView.h"

@interface SureChatTipsView ()


@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SureChatTipsView
-(void)awakeFromNib{
    [super awakeFromNib];
//    "SureChatTipsView.tipsLabel"="是否消耗一个名额向对方打招呼";
//    "SureChatTipsView.countLabel.tip1"="套餐剩余";
//    "SureChatTipsView.countLabel.tiptimes"="次";
    [self.iconImageView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    self.tipsLabel.text=@"SureChatTipsView.tipsLabel".icanlocalized;
//    "UIAlertController.sure.title"="确定";
//    "UIAlertController.cancel.title"="取消";
    [self.cancelButton setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
    [self.sureButton setTitle:@"UIAlertController.sure.title".icanlocalized forState:UIControlStateNormal];
    
    [self.cancelButton layerWithCornerRadius:22.5 borderWidth:1 borderColor:UIColorThemeMainColor];
    [self.sureButton layerWithCornerRadius:22.5 borderWidth:0 borderColor:nil];
    
    [self.bgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
}
#pragma mark - Setter

#pragma mark - Public
#pragma mark - Private
-(void)showSureChatTipsView{
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)sureAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self removeFromSuperview];
}
#pragma mark - Lazy
#pragma mark - Event

@end

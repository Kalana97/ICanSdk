
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/6/2021
- File name:  ShowSendUserCarSureView.m
- Description:
- Function List:
*/
        

#import "ShowSendUserCarSureView.h"

@interface ShowSendUserCarSureView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ShowSendUserCarSureView

-(void)awakeFromNib{
    [super awakeFromNib];
//    "UIAlertController.sure.title"="确定";
//    "UIAlertController.cancel.title"="取消";
    self.tipsLabel.text=@"SendTo".icanlocalized;
    [self.cancelBtn setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"UIAlertController.sure.title".icanlocalized forState:UIControlStateNormal];
    [self.iconImgView layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    [self.bgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
}
#pragma mark - Setter
-(void)setInfo:(UserMessageInfo *)info{
    _info=info;
    [self.iconImgView setImageWithString:info.headImgUrl placeholder:BoyDefault];
    self.nameLabel.text=[@"ContactCardTips".icanlocalized stringByAppendingString:info.nickname];;
}
#pragma mark - Public
#pragma mark - Private
-(void)showView{
    [kKeyWindow addSubview:self];
}
-(void)hiddenView{
    [self removeFromSuperview];
    
}
#pragma mark - Lazy
#pragma mark - Event
- (IBAction)sureAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self hiddenView];
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
@end

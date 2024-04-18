
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 30/8/2021
- File name:  SurePushPostView.m
- Description:
- Function List:
*/
        

#import "SurePushPostView.h"

@interface SurePushPostView ()
@property (weak, nonatomic) IBOutlet UILabel *tiltle;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *yueTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIControl *bgView;

@end

@implementation SurePushPostView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.cancelBtn setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"UIAlertController.sure.title".icanlocalized forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_circle_unSelect") forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_circle_select") forState:UIControlStateSelected];
    self.tiltle.text=@"Post".icanlocalized;
//    Wouldyouliketodate
    self.yueTipsLabel.text=@"Wouldyouliketodate".icanlocalized;
    [self.bgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    
}
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event
-(void)showPostView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hiddenPostView{
    [self removeFromSuperview];
}
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected=!self.selectBtn.selected;
}
- (IBAction)cancelAction:(id)sender {
    [self hiddenPostView];
}
- (IBAction)sureAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self hiddenPostView];
    if (self.selectBtn.isSelected) {
        PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
        request.yue=@(self.selectBtn.selected);
        request.parameters=[request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            CircleUserInfoManager.shared.yue=self.selectBtn.isSelected;
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }
}

@end

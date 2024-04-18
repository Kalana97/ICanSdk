//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleUserDetailImgeCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "CircleUserDetailImgeCollectionViewCell.h"
#import "UploadImgModel.h"
@interface CircleUserDetailImgeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@end
@implementation CircleUserDetailImgeCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.selectBtn setBackgroundImage:UIImageMake(@"mine_Photo_choice_no") forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:UIImageMake(@"mine_Photo_choice") forState:UIControlStateSelected];
    self.selectBtn.hidden = YES;
    [self.addBgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    
}
-(void)setCanSelect:(BOOL)canSelect{
    self.selectBtn.hidden = !canSelect;
}
- (IBAction)selectBtnAction {
    self.wallInfo.select = !self.wallInfo.select;
    self.selectBtn.selected = self.wallInfo.select;
    if (self.selectBlock) {
        self.selectBlock(self.wallInfo);
    }
}
-(void)setWallInfo:(PhotoWallInfo *)wallInfo{
    _wallInfo = wallInfo;
    self.selectBtn.selected = self.wallInfo.select;
//    [self.userImageView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.userImageView setImageWithString:wallInfo.url placeholder:DefaultImg];
}
-(void)setModel:(UploadImgModel *)model{
    _model=model;
    if (model.image) {
        self.userImageView.image=model.image;
    }else{
        [self.userImageView setImageWithString:model.ossImgUrl placeholder:DefaultImg];
    }
    if (model.isAdd) {
        self.deletBtn.hidden=YES;
        self.userImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.addBgView.hidden=NO;
    }else{
        self.addBgView.hidden=YES;
        self.deletBtn.hidden=NO;
        self.userImageView.contentMode=UIViewContentModeScaleAspectFill;
    }
}
- (IBAction)deleteBtnAction {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}

// 实现cell抖动方法
- (void)beginShake
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 0.2;
    anim.repeatCount = MAXFLOAT;
    anim.values = @[@(-0.03),@(0.03),@(-0.03)];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"shake"];
}
// 实现cell停止抖动方法
- (void)stopShake
{
    [self.layer removeAllAnimations];
}

@end

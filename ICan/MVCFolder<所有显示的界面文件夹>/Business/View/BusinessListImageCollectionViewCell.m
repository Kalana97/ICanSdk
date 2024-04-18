//
//  BusinessListImageCollectionViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-08.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessListImageCollectionViewCell.h"
#import "UploadImgModel.h"

@implementation BusinessListImageCollectionViewCell
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

-(void)setWallInfo:(BusinessPhotoWallList *)wallInfo{
    _wallInfo = wallInfo;
    [self.userImageView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    if(wallInfo.photo){
        [self.userImageView setImageWithString:wallInfo.photo placeholder:DefaultImg];
    }else{
        if(wallInfo.checkPhoto && self.isMine){
            [self.userImageView setImageWithString:wallInfo.checkPhoto placeholder:DefaultImg];
        }else{
            self.contentView.hidden = YES;
        }
    }
}

-(void)setModel:(UploadImgModel *)model{
    _model = model;
    if (model.image) {
        self.userImageView.image = model.image;
    }else{
        [self.userImageView setImageWithString:model.ossImgUrl placeholder:DefaultImg];
    }
    if (model.isAdd) {
        self.deletBtn.hidden = YES;
        self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.addBgView.hidden = NO;
    }else{
        self.addBgView.hidden = YES;
        self.deletBtn.hidden = NO;
        self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (IBAction)deleteBtnAction {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}

- (void)beginShake{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 0.2;
    anim.repeatCount = MAXFLOAT;
    anim.values = @[@(-0.03),@(0.03),@(-0.03)];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"shake"];
}

- (void)stopShake{
    [self.layer removeAllAnimations];
}

@end

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/5/2021
- File name:  CircleHomeConditionCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "CircleHomeConditionCollectionViewCell.h"
#import "ConditionModel.h"
@interface CircleHomeConditionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation CircleHomeConditionCollectionViewCell
-(void)setConditionModel:(ConditionModel *)conditionModel{
    _conditionModel=conditionModel;
    self.titleLabel.text=conditionModel.title;
    self.tipsImageView.hidden=conditionModel.hiddenImg;
    self.lineView.hidden=conditionModel.hiddenImg;
    if (conditionModel.isSelect) {
//        self.contentView.backgroundColor=UIColorThemeMainColor;
        self.titleLabel.textColor=UIColor252730Color;
//        self.tipsImageView.image=UIImageMake(@"icon_drop_down_w");
    }else{
//        self.contentView.backgroundColor=UIColorBg243Color;
        self.titleLabel.textColor=UIColor153Color;
//        self.tipsImageView.image=UIImageMake(@"icon_drop_down_g");
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorMake(240, 242, 245);
    [self.contentView layerWithCornerRadius:11 borderWidth:0 borderColor:nil];
}

@end

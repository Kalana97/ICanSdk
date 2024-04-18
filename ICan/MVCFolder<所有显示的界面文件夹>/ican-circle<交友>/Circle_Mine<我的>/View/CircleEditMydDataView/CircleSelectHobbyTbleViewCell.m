//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleSelectHobbyTbleViewCell.m
- Description:
- Function List:
*/
        

#import "CircleSelectHobbyTbleViewCell.h"
@interface CircleSelectHobbyTbleViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgeView;

@end
@implementation CircleSelectHobbyTbleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //icon_circle_unSelect
//    icon_circle_unSelect
   
    self.lineView.hidden=YES;
    
}
-(void)setHobbyInfo:(HobbyTagsInfo *)hobbyInfo{
    _hobbyInfo=hobbyInfo;
    
    self.hobbyLabel.text=hobbyInfo.showName;
    if (hobbyInfo.select) {
        self.selectImgeView.image=UIImageMake(@"icon_circle_select");
        [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColorThemeMainColor];
        self.hobbyLabel.textColor=UIColorThemeMainColor;
    }else{
        self.selectImgeView.image=UIImageMake(@"icon_circle_unSelect");
        [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColorMake(219, 221, 223)];
        self.hobbyLabel.textColor=UIColor252730Color;
    }
}


@end

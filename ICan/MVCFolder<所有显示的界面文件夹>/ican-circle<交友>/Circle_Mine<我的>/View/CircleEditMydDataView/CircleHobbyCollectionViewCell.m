//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleHobbyCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "CircleHobbyCollectionViewCell.h"
@interface CircleHobbyCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@end
@implementation CircleHobbyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorMake(240, 242, 245);
    [self.contentView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
}
- (IBAction)closeButtonAction {
    !self.deleteBlock?:self.deleteBlock();
    
}
-(void)setTagsInfo:(HobbyTagsInfo *)tagsInfo{
    _tagsInfo=tagsInfo;
    self.tagLabel.text=tagsInfo.showName;
}
@end

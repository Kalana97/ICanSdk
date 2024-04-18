//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MessageMenuCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "MessageMenuCollectionViewCell.h"
#import "MenuItem.h"
@interface MessageMenuCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *menuImgView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@end
@implementation MessageMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setMenuItem:(MenuItem *)menuItem{
    _menuItem=menuItem;
    self.menuImgView.image=UIImageMake(menuItem.img);
    self.menuTitleLabel.text=menuItem.title;
}
@end

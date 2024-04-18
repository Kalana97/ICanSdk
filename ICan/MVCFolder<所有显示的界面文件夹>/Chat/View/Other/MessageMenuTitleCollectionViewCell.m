//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MessageMenuCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "MessageMenuTitleCollectionViewCell.h"
#import "MenuItem.h"
@interface MessageMenuTitleCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@end
@implementation MessageMenuTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setMenuItem:(MenuItem *)menuItem{
    _menuItem=menuItem;
    self.menuTitleLabel.text=menuItem.title;
}
@end

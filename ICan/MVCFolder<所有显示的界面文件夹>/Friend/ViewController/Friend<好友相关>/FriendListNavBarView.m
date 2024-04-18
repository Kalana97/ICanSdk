//
/*
- TimeLineNavBarView.m
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/12/10
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "FriendListNavBarView.h"

@interface FriendListNavBarView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addHeight;

@end
@implementation FriendListNavBarView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = UIColorNavBarBarTintColor;
    self.titleLabel.textColor = UIColorThemeMainTitleColor;
    
}
-(IBAction)messageNoticeAction{
    !self.messageBlock?:self.messageBlock();
}
-(IBAction)publishAction{
    !self.publishBlock?:self.publishBlock();
}
@end

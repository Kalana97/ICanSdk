
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- Editor: Edited  by RSJayasekara on 15/12/2022
- File name:  FaseMessageTableViewCell.m
- Description:
- Function List:
*/
        

#import "FaseMessageTableViewCell.h"
#import "EditFastMessageViewController.h"

@interface FaseMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation FaseMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    self.backgroundColor = UIColorMake(248, 248, 248);
    self.contentView.backgroundColor = UIColorMake(248, 248, 248);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setMsgInfo:(QuickMessageInfo *)msgInfo {
    _msgInfo = msgInfo;
    self.titleLabel.text = msgInfo.value;
}

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - Setter
- (IBAction)editBtnAction:(id)sender {
    EditFastMessageViewController *vc = [[EditFastMessageViewController alloc]init];
    vc.directionInt = @"Exist";
    vc.info = self.msgInfo;
    [[AppDelegate shared]pushViewController:vc animated:YES];
}

@end

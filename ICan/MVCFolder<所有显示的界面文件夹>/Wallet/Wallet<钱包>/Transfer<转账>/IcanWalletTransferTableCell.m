//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletTransferTableCell.m
- Description:
- Function List:
*/
        

#import "IcanWalletTransferTableCell.h"
@interface IcanWalletTransferTableCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *realNameLbl;
@property(nonatomic, weak) IBOutlet UIButton *addFriendBtn;
@property(nonatomic,strong) UserMessageInfo* userData;
@end
@implementation IcanWalletTransferTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.addFriendBtn, 14);
    self.addFriendBtn.backgroundColor = UIColorThemeMainColor;
    [self.addFriendBtn setTitle:@"chatlist.menu.list.addfriend".icanlocalized forState:UIControlStateNormal];
}

-(void)setHistoryInfo:(UserMessageInfo *)historyInfo{
    _historyInfo = historyInfo;
    if(self.recentTransactions == true){
        self.realNameLbl.hidden = false;
        [self getUserInfoRequestByAccuracyRequest:historyInfo];
    }else{
        self.realNameLbl.hidden = true;
    }
    self.idLabel.text = historyInfo.numberId;
    [self.iconImgView setDZIconImageViewWithUrl:historyInfo.headImgUrl gender:@"1"];
    self.nicknameLab.text = historyInfo.nickname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)getUserInfoRequestByAccuracyRequest:(UserMessageInfo*)response{
    if(self.shoulShowAddFriend == true && response.isFriend == false){
        self.addFriendBtn.hidden  = false;
    }else{
        self.addFriendBtn.hidden  = true;
    }
    NSString *firstName = response.firstName;
    self.userData = response;
    if(firstName != nil && ![firstName  isEqual: @""]){
        for (int i = firstName.length / 2; i < firstName.length ; i++) {
            if (![[firstName substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                NSRange range = NSMakeRange(i, 1);
                firstName = [firstName stringByReplacingCharactersInRange:range withString:@"*"];
            }
        }
        self.realNameLbl.text = [NSString stringWithFormat:@"(%@)",firstName];
    }else{
        self.realNameLbl.hidden = YES;
    }
}

- (IBAction)addFriendAction:(id)sender {
    if (self.addBlock) {
        self.addBlock(self.userData);
    }
}

@end




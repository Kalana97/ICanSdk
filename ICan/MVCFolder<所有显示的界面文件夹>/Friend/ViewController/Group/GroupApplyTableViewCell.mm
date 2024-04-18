//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyTableViewCell.m
- Description:
- Function List:
*/
        

#import "GroupApplyTableViewCell.h"
#import "GroupApplyInfo.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
@interface GroupApplyTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
@implementation GroupApplyTableViewCell
- (IBAction)agreeAction:(id)sender {
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}
- (IBAction)cancelAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
-(void)setInfo:(GroupApplyInfo *)info{
    _info = info;
    if (info.isAgree) {
        self.cancelBtn.hidden = YES;
        [self.agreeBtn setBackgroundColor:UIColorBg243Color];
        [self.agreeBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
        [self.agreeBtn setTitle:@"approved".icanlocalized forState:UIControlStateNormal];
    }else{
        self.cancelBtn.hidden = NO;
        [self.agreeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.agreeBtn setBackgroundColor:UIColorThemeMainColor];
        [self.agreeBtn setTitle:@"Agree".icanlocalized forState:UIControlStateNormal];
    }
//    dispatch_queue_t globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//      dispatch_group_t group = dispatch_group_create();
//    //任务1
//    dispatch_group_enter(group);
//    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.userId successBlock:^(UserMessageInfo * _Nonnull info) {
//        self.nicknameLabel.text = info.nickname;
//        [self.iconImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
//        dispatch_group_leave(group);
//    }];
//    dispatch_group_enter(group);
//    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.inviterId successBlock:^(UserMessageInfo * _Nonnull info) {
//        self.nicknameLabel.text = info.nickname;
//        [self.iconImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
//        dispatch_group_leave(group);
//    }];
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//
//    });
    NSMutableString*content=[[NSMutableString alloc]init];
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.inviterId successBlock:^(UserMessageInfo * _Nonnull uinfo) {
       
        [content appendFormat:@"\"%@\"",uinfo.nickname];
        [content appendString:@"Invite".icanlocalized];
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.userId successBlock:^(UserMessageInfo * _Nonnull udinfo) {
            self.nicknameLabel.text = udinfo.nickname;
            [self.iconImgView setDZIconImageViewWithUrl:udinfo.headImgUrl gender:udinfo.gender];
            [content appendFormat:@"\"%@\"",udinfo.nickname];
            [content appendString:@"joinIn".icanlocalized];
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:info.groupId successBlock:^(GroupListInfo * _Nonnull listInfo) {
                [content appendFormat:@"\"%@\"",listInfo.name];
                [content appendString:@"applyJoinGroup".icanlocalized];
                [content appendString:@"ToConfirm".icanlocalized];
                self.tipsLabel.text = content;
            }];
        }];
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    [self.iconImgView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    [self.agreeBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.cancelBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    
    [self.agreeBtn setTitle:@"Agree".icanlocalized forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"Delete".icanlocalized forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

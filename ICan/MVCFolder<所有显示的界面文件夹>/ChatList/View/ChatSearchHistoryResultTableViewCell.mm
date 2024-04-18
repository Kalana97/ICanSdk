//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/1/2021
- File name:  ChatSearchHistoryResultTableViewCell.m
- Description:
- Function List:
*/
        

#import "ChatSearchHistoryResultTableViewCell.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "ChatListModel.h"
#import "ChatModel.h"
@interface ChatSearchHistoryResultTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@end
@implementation ChatSearchHistoryResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =UIColorViewBgColor;
    [self.iconImageView layerWithCornerRadius:25 borderWidth:0 borderColor:nil];
    self.topNameLabel.textColor = UIColorThemeMainTitleColor;
    self.desLabel.textColor = UIColorThemeMainSubTitleColor;
    self.centerLabel.textColor =UIColorThemeMainTitleColor;

}
-(NSMutableAttributedString*)getShowString:(NSString*)oldString{
    NSMutableAttributedString*newString=[[NSMutableAttributedString alloc]initWithString:oldString];
    NSRange rang=[oldString rangeOfString:self.searchText];
    [newString addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:rang];
    return newString;
}
-(void)setChatListModel:(ChatListModel *)chatListModel{
    if (chatListModel) {
        _chatListModel=chatListModel;
        self.topNameLabel.hidden=YES;
        self.desLabel.hidden=YES;
        self.centerLabel.hidden=NO;
        if ([chatListModel.chatType isEqualToString:GroupChat]) {
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatListModel.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
                self.centerLabel.attributedText = [self getShowString:info.name];
            }];
        }else{
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatListModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
                self.centerLabel.attributedText = [self getShowString:info.remarkName?:info.nickname];
            }];
        }
    }
    
    
}
-(void)setGroupListInfo:(GroupListInfo *)groupListInfo{
    if (groupListInfo) {
        _groupListInfo=groupListInfo;
        self.topNameLabel.hidden=YES;
        self.desLabel.hidden=YES;
        self.centerLabel.hidden=NO;
        [self.iconImageView setImageWithString:groupListInfo.headImgUrl placeholder:GroupDefault];
        self.centerLabel.attributedText =[self getShowString:groupListInfo.name] ;
    }
}
-(void)setGroupMemberItems:(NSArray<GroupMemberInfo *> *)groupMemberItems{
    if (groupMemberItems) {
        _groupMemberItems=groupMemberItems;
        self.topNameLabel.hidden=NO;
        self.desLabel.hidden=NO;
        self.centerLabel.hidden=YES;
        GroupMemberInfo*memberInfo=groupMemberItems.firstObject;
        [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:memberInfo.groupId successBlock:^(GroupListInfo * _Nonnull info) {
            [self.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
            self.topNameLabel.attributedText =[self getShowString:info.name] ;
        }];
        if ([memberInfo.groupRemark containsString:self.searchText]) {
            NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",@"Contain".icanlocalized]];
            [string appendAttributedString:[self getShowString:memberInfo.groupRemark]];
            self.desLabel.attributedText =string;
        }else if ([memberInfo.nickname containsString:self.searchText]){
            NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",@"Contain".icanlocalized]];
            [string appendAttributedString:[self getShowString:memberInfo.nickname]];
            self.desLabel.attributedText =string;
        }else if([memberInfo.numberId containsString:self.searchText]){
            NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",@"Contain".icanlocalized]];
            [string appendAttributedString:[[NSAttributedString alloc]initWithString:memberInfo.groupRemark?:memberInfo.nickname]];
            [string appendAttributedString:[self getShowString:[NSString stringWithFormat:@"(%@)",memberInfo.numberId]]];
            self.desLabel.attributedText =string;
        }
        
    }
   
}
-(void)setUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    if (userMessageInfo) {
        [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
        self.topNameLabel.hidden=YES;
        self.desLabel.hidden=YES;
        self.centerLabel.hidden=NO;
        if ([userMessageInfo.remarkName containsString:self.searchText]) {
            self.topNameLabel.hidden=YES;
            self.desLabel.hidden=YES;
            self.centerLabel.hidden=NO;
            self.centerLabel.attributedText =[self getShowString:userMessageInfo.remarkName] ;
        }else if ([userMessageInfo.nickname containsString:self.searchText]){
            self.topNameLabel.hidden=YES;
            self.desLabel.hidden=YES;
            self.centerLabel.hidden=YES;
            if (userMessageInfo.remarkName.length>0) {
                self.topNameLabel.hidden=NO;
                self.desLabel.hidden=NO;
                self.centerLabel.hidden=YES;
                self.topNameLabel.attributedText =[self getShowString:userMessageInfo.remarkName] ;
                NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",[@"mine.profile.title.nickname" icanlocalized:@"昵称"]]];
                [string appendAttributedString:[self getShowString:userMessageInfo.nickname]];
                self.desLabel.attributedText =string;
            }else{
                self.topNameLabel.hidden=YES;
                self.desLabel.hidden=YES;
                self.centerLabel.hidden=NO;
                self.centerLabel.attributedText =[self getShowString:userMessageInfo.nickname] ;
            }
           
        }
        else if([userMessageInfo.numberId containsString:self.searchText]){
            self.topNameLabel.hidden=NO;
            self.desLabel.hidden=NO;
            self.centerLabel.hidden=YES;
            self.topNameLabel.attributedText =[self getShowString:userMessageInfo.remarkName?:userMessageInfo.nickname] ;
            NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:@"ID："];
            [string appendAttributedString:[self getShowString:userMessageInfo.numberId]];
            self.desLabel.attributedText =string;
        }else{
            self.centerLabel.attributedText =[self getShowString:userMessageInfo.remarkName?:userMessageInfo.nickname] ;
        }
       
       
    }
    
    
}
-(void)setChatModel:(ChatModel *)chatModel{
    if (chatModel) {
        _chatModel=chatModel;
        self.topNameLabel.hidden=NO;
        self.desLabel.hidden=NO;
        self.centerLabel.hidden=YES;
        self.desLabel.attributedText =[self getShowString:chatModel.showMessage] ;
        if ([chatModel.chatType isEqualToString:GroupChat]) {
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatModel.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                self.topNameLabel.attributedText=[self getShowString:info.name];
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
            }];
        }else{
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                self.topNameLabel.attributedText=[self getShowString:info.remarkName?:info.nickname];
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
            }];
        }
    }
}
-(void)setHistoryItems:(NSArray<ChatModel *> *)historyItems{
   
    if (historyItems) {
        _historyItems=historyItems;
        self.topNameLabel.hidden=NO;
        self.desLabel.hidden=NO;
        self.centerLabel.hidden=YES;
        ChatModel*model=historyItems.firstObject;
        if (historyItems.count==1) {
           
            self.desLabel.attributedText =[self getShowString:model.showMessage] ;
            
        }else{
            self.desLabel.text=[NSString stringWithFormat:@"%zd%@",historyItems.count,@"related message".icanlocalized];
        }
        if ([model.chatType isEqualToString:GroupChat]) {
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:model.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                self.topNameLabel.attributedText=[self getShowString:info.name];
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
            }];
        }else{
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                self.topNameLabel.attributedText=[self getShowString:info.remarkName?:info.nickname];
                [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
            }];
        }
        
       
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end

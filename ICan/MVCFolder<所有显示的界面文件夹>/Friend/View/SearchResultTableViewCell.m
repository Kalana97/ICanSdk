//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 16/10/2019
- File name:  SearchResultTableViewCell.m
- Description:
- Function List:
*/
        

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor=UIColor252730Color;
    [self.iconImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
}
-(void)setUserMessageInfo:(UserMessageInfo *)userMessageInfo{
    _userMessageInfo=userMessageInfo;
    [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
    self.nameLabel.text=userMessageInfo.remarkName?:userMessageInfo.nickname;
}
-(void)setGroupListInfo:(GroupListInfo *)groupListInfo{
    _groupListInfo=groupListInfo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:groupListInfo.headImgUrl] placeholderImage:UIImageMake(GroupDefault)];
    self.nameLabel.text=groupListInfo.name;
    
}
@end

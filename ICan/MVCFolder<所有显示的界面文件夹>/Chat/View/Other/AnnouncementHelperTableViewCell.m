//
//  AnnouncementHelperTableViewCell.m
//  ICan
//
//  Created by Sathsara on 2022-10-04.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "AnnouncementHelperTableViewCell.h"
#import "ChatModel.h"
#import "MesageContentModel.h"
//  MesageContentModel.h


@implementation AnnouncementHelperTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorBg243Color;
    self.radousView.backgroundColor=UIColor.whiteColor;
    [self.radousView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.radousView.userInteractionEnabled=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setChatModel:(ChatModel *)chatModel{
    
    _chatModel=chatModel;
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    self.timeLbl.text=[GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];;
    
    self.titleLbl.text = [NSString stringWithFormat:@"%@", removeChatInfo.title];
    self.contentLbl.text = [NSString stringWithFormat:@"%@", removeChatInfo.content];
    
}





@end

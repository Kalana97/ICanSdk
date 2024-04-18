//
//  RecommendUserInfoCardTableViewCell.h
//  OneChatAPP
//  用户名片 按钮
//  Created by mac on 2017/11/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;

@interface UserCardButton : UIButton

@property (nonatomic, strong) ChatModel *chatModel;


@end

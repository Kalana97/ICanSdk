//
//  GroupMemberCollectionViewCell.h
//  OneChatAPP
//  群详情的群成员的collectViewcell
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDBManager+UserMessageInfo.h"
static NSString * const  KGroupMemberCollectionViewCell = @"GroupMemberCollectionViewCell";

@interface GroupMemberCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImage *image;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconView;

@property (nonatomic,strong)GroupMemberInfo * memberInfo;
@end


//
//  ItemTableViewCell.h
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
static NSString * const KChatListMenuCell=@"ChatListMenuCell";
static CGFloat const KHeightChatListMenuCell=50;
@interface ChatListMenuCell :BaseCell
@property (weak, nonatomic) IBOutlet UILabel *cirecleLabel;

- (void)setIconName:(NSString *)iconName title:(NSString *)title isShow:(BOOL)show;

@end

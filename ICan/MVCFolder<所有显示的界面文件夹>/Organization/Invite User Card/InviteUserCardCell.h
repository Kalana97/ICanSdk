//
//  InviteUserCardCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteUserCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgCellView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgLogo;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (nonatomic, strong) UserMessageInfo *UserInfoModel;
-(void)setDataForCell:(UserMessageInfo*)userModel;
-(void)setContact:(MemebersResponseInfo *)userModel;
@property(nonatomic, copy) void (^inviteBlock)(void);
@end

NS_ASSUME_NONNULL_END

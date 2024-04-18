//
//  ReinviteCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReinviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgCell;
@property (weak, nonatomic) IBOutlet DZIconImageView *userImgIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *refreshImg;
@property (weak, nonatomic) IBOutlet UIView *btnBoarderResend;
@property (weak, nonatomic) IBOutlet UILabel *reinviteLbl;
@property(nonatomic, copy) void (^inviteBlock)(void);
-(void)setDataForCell:(MemebersResponseInfo *)userModel;
@end

NS_ASSUME_NONNULL_END

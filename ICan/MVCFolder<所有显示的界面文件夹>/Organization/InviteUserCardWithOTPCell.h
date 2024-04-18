//
//  InviteUserCardWithOTPCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-23.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteUserCardWithOTPCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *userImgIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UITextField *otpTxt;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (nonatomic, copy) void (^tapBlock)(NSString *);
-(void)setDataForCell:(MemebersResponseInfo *)userModel;
@end

NS_ASSUME_NONNULL_END

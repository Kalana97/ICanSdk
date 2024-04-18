//
//  RechargeChannelTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KRechargeChannelTableViewCell = @"RechargeChannelTableViewCell";
static CGFloat const KHeightRechargeChannelTableViewCell=50.0;

@interface RechargeChannelTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIButton *swtitchBtn;
@property (weak, nonatomic) IBOutlet UIStackView *stackSwitch;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *secondTopic;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (nonatomic,assign)BOOL isSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (nonatomic,strong)RechargeChannelInfo *rechargeChannelInfo;
@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property(nonatomic, strong) C2CBalanceListInfo *currentInfo;
@property(nonatomic, copy) void (^sureBlock)(void);
@end

NS_ASSUME_NONNULL_END

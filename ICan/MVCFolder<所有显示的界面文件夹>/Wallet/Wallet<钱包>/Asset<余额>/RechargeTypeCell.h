//
//  RechargeTypeCell.h
//  ICan
//
//  Created by Sathsara on 2023-02-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const RechargeTypeCellListTableViewCell = @"RechargeTypeCell";
@interface RechargeTypeCell : BaseCell
@property (weak, nonatomic) IBOutlet UIView *outerBoarderView;
@property (weak, nonatomic) IBOutlet DZIconImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn;
@property(nonatomic, copy) void (^selectRechargeInfo)(RechargeChannelInfo *info);
@property (nonatomic,strong)RechargeChannelInfo *rechargeChannelInfoData;
-(void)setData:(RechargeChannelInfo *)channelInfo;
@end

NS_ASSUME_NONNULL_END

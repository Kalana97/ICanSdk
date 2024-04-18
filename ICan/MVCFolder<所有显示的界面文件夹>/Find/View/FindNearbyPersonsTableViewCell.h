//
//  FindNearbyPersonsTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/31.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KFindNearbyPersonsTableViewCell =@"FindNearbyPersonsTableViewCell";
static CGFloat const KHeightFindNearbyPersonsTableViewCell =80;

@interface FindNearbyPersonsTableViewCell : BaseCell

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *edgeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;


@property(nonatomic,strong)UserLocationNearbyInfo *userLocationNearbyInfo;
@property(nonatomic, copy) void (^addBlock)(void);
@property(nonatomic, copy) void (^chatBlock)(void);
@end

NS_ASSUME_NONNULL_END

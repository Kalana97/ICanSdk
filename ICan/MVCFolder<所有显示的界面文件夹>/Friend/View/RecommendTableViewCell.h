//
//  RecommendTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KRecommendTableViewCell =@"RecommendTableViewCell";
static CGFloat const KHeightRecommendTableViewCell = 56.0;
@interface RecommendTableViewCell : BaseCell
@property(nonatomic,strong)UserRecommendListInfo * userRecommendListInfo;

@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *singaLabel;
@property (weak, nonatomic) IBOutlet UIView *recommendBgView;


@end

NS_ASSUME_NONNULL_END

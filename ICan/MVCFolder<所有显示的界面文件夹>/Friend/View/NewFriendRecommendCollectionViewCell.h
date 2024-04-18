//
//  NewFriendRecommendCollectionViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const KNewFriendRecommendCollectionViewCell =@"NewFriendRecommendCollectionViewCell";

@interface NewFriendRecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)UserRecommendListInfo * userRecommendListInfo;
@end

NS_ASSUME_NONNULL_END

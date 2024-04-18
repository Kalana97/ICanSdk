//
//  FavoriteContactTableViewCell.h
//  ICan
//
//  Created by Kalana Rathnayaka on 26/02/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const KFavoriteContactTableViewCell = @"FavoriteContactTableViewCell";
@interface FavoriteContactTableViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END

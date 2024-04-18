//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  BuyPackageCollectionViewCell.h
- Description:购买套餐的cell
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kBuyPackageCollectionViewCell = @"BuyPackageCollectionViewCell";
@interface BuyPackageCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) PackagesInfo *packagesInfo;
@end

NS_ASSUME_NONNULL_END

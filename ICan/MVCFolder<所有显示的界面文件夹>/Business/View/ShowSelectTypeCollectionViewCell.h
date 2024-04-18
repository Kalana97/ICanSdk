//
//  ShowSelectTypeCollectionViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kShowSelectTypeCollectionViewCell = @"ShowSelectTypeCollectionViewCell";
@interface ShowSelectTypeCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) NSArray *typeItems;
@property(nonatomic, copy) void (^selectBlock)(BusinessTypeInfo *typeInfo);
@end

NS_ASSUME_NONNULL_END

//
//  SelectTypeCollectionViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kSelectTypeCollectionViewCell = @"SelectTypeCollectionViewCell";
@interface SelectTypeCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) NSArray *currentTypes;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

NS_ASSUME_NONNULL_END

//
//  AmountViewCollectionViewCell.h
//  ICan
//
//  Created by Kalana Rathnayaka on 20/10/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const KIDAmountCollectionCell = @"AmountViewCollectionViewCell";
@interface AmountViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *badgeImg;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) NSDictionary *infor;

@end



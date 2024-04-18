//
//  RechargeAmountCollectionCell.h
//  fortune
//
//  Created by lidazhi on 2019/1/17.
//  Copyright © 2019 DW. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * const KIDRechargeAmountCollectionCell=@"RechargeAmountCollectionCell";
@interface RechargeAmountCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end



//
//  TransactionCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *toUserLbl;
@property (weak, nonatomic) IBOutlet UILabel *transTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amtLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
-(void)setData:(TransactionDataContentResponse *) model;
@end

NS_ASSUME_NONNULL_END

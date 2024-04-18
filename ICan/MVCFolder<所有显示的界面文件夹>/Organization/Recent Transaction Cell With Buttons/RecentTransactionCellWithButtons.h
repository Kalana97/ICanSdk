//
//  RecentTransactionCellWithButtons.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecentTransactionCellWithButtons : UITableViewCell
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amtLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *tolbl;
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
-(void)setData:(TransactionDataContentResponse *) model;
@property(nonatomic, copy) void (^acceptBlock)(void);
@property (weak, nonatomic) IBOutlet UIStackView *btnStack;
@property(nonatomic, copy) void (^rejectBlock)(void);
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END

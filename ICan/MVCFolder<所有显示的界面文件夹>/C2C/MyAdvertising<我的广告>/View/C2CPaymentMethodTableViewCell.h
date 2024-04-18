//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CPaymentMethodTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CPaymentMethodTableViewCell = @"C2CPaymentMethodTableViewCell";
typedef NS_ENUM(NSInteger,C2CPaymentMethodTableViewCellType){
    C2CPaymentMethodTableViewCellTypeMineList,
    C2CPaymentMethodTableViewCellTypeSelectMethodPopView,
    C2CPaymentMethodTableViewCellTypePublishAdvert
};
@interface C2CPaymentMethodTableViewCell : BaseCell
@property (nonatomic, strong) C2CPaymentMethodInfo *paymentMethodInfo;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property(nonatomic, copy) void (^rightBtnBlock)(void);
@property(nonatomic, assign) C2CPaymentMethodTableViewCellType cellType;
@property(nonatomic, assign) BOOL isHashShows;
@end

NS_ASSUME_NONNULL_END

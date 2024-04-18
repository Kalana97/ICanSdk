//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 2/12/2021
- File name:  C2CUserReceiveEvaluateTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CUserReceiveEvaluateTableViewCell = @"C2CUserReceiveEvaluateTableViewCell";
@interface C2CUserReceiveEvaluateTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContraint;
@property(nonatomic, strong) C2COrderInfo *c2cOrderInfo;
@property(nonatomic, strong) C2COrderInfo *c2cUserDetailEvluateOrderInfo;
@end

NS_ASSUME_NONNULL_END

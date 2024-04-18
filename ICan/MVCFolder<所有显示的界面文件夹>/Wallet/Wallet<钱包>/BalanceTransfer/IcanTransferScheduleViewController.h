//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 21/2/2022
- File name:  IcanTransferScheduleViewController.h
- Description:转账进度
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanTransferScheduleViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *fee;
@end

NS_ASSUME_NONNULL_END

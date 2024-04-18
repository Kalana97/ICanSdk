//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2020
- File name:  PayMentAgreementViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kPayMentAgreementViewCell = @"PayMentAgreementViewCell";
@interface PayMentAgreementViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END

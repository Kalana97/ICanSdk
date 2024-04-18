//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2021
- File name:  MemberCenterVIPCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kMemberCenterVIPCollectionViewCell = @"MemberCenterVIPCollectionViewCell";
@interface MemberCenterVIPCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) MemberCentreVipInfo *vipInfo;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eachLab;
@end

NS_ASSUME_NONNULL_END

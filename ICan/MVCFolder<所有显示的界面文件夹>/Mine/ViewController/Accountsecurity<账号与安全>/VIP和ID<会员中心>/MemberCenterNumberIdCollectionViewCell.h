//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2021
- File name:  MemberCenterNumberIdCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kMemberCenterNumberIdCollectionViewCell = @"MemberCenterNumberIdCollectionViewCell";
@interface MemberCenterNumberIdCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) MemberCentreNumberIdSellInfo *idInfo;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

NS_ASSUME_NONNULL_END

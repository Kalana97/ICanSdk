//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  ShowSelectAddressCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const kShowSelectAddressCollectionViewCell = @"ShowSelectAddressCollectionViewCell";
@interface ShowSelectAddressCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) NSArray *areaItems;
@property(nonatomic, assign) AddressViewType addressViewType;
@property(nonatomic, copy) void (^selectBlock)(AreaInfo*areaInfo);
@end

NS_ASSUME_NONNULL_END

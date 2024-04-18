//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MessageMenuCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class MenuItem;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kMessageMenuCollectionViewCell = @"MessageMenuCollectionViewCell";
@interface MessageMenuCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) MenuItem *menuItem;
@end

NS_ASSUME_NONNULL_END

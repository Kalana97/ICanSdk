//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/12/2019
- File name:  UICollectionView+DZExtension.h
- Description:
- Function List:
*/
        



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (DZExtension)
/**
 *  注册 Nib cell
 */
- (void)registNibWithNibName:(NSString *)nibName;

- (void)registClassWithClassName:(NSString *)className;
@end

NS_ASSUME_NONNULL_END

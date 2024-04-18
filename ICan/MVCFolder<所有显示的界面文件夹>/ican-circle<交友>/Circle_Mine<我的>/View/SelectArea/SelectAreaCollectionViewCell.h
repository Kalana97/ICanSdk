//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  SelectAreaCollectionViewCell.h
- Description:显示已经选择的地区的名字 或者如果没有选中 显示成请选择样式
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const kSelectAreaCollectionViewCell = @"SelectAreaCollectionViewCell";
@interface SelectAreaCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) NSArray *currentAreaitems;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

NS_ASSUME_NONNULL_END

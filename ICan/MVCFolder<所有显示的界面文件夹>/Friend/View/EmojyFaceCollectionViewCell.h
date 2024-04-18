//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  EmojyFaceCollectionViewCell.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojyFaceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *faceLabel;
@property(nonatomic, copy) void (^selectEmojyBlock)(NSString*text);
@end

NS_ASSUME_NONNULL_END

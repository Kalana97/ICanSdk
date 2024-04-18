//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 30/8/2021
- File name:  SurePushPostView.h
- Description:购买帖子 准备发布
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SurePushPostView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic, copy) void (^sureBlock)(void);
-(void)showPostView;
-(void)hiddenPostView;
@end

NS_ASSUME_NONNULL_END

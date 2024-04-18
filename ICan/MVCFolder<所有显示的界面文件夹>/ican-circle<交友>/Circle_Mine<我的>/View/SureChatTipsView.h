//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 7/6/2021
- File name:  SureChatTipsView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SureChatTipsView : UIView
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
-(void)showSureChatTipsView;
@property(nonatomic, strong) MyPackagesInfo *myPackagesInfo;
@property(nonatomic, copy) void (^sureBlock)(void);
@end

NS_ASSUME_NONNULL_END

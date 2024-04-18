//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 29/6/2021
- File name:  ShowUtilityFavoritesView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowUtilityFavoritesView : UIView
@property(nonatomic, strong) DialogListInfo *info;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property(nonatomic, copy) void (^sureBlock)(void);
@property(nonatomic, copy) void (^cancelBlock)(void);
-(void)showFavoritesView;
-(void)hiddenFavoritesView;
@end

NS_ASSUME_NONNULL_END

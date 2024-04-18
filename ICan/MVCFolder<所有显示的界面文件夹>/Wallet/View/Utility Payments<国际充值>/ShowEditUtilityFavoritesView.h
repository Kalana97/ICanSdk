//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 29/6/2021
- File name:  ShowEditUtilityFavoritesView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowEditUtilityFavoritesView : UIView
@property(nonatomic, strong) DialogListInfo *info;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;
@property(nonatomic, copy) void (^sureBlock)(void);
@property(nonatomic, copy) void (^cancelBlock)(void);
-(void)showEditUtilityFavoritesView;
-(void)hiddenEditUtilityFavoritesView;
@end

NS_ASSUME_NONNULL_END

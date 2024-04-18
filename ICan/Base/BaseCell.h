//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 29/9/2019
- File name:  BaseCell.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "QMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCell : QMUITableViewCell
@property(nonatomic, strong) IBInspectable UIView *lineView;
-(void)setUpUI;
@end

NS_ASSUME_NONNULL_END

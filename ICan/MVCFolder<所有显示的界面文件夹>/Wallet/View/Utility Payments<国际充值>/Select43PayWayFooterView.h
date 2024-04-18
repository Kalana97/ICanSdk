//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayFooterView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const kSelect43PayWayFooterView = @"Select43PayWayFooterView";
@interface Select43PayWayFooterView : UITableViewHeaderFooterView
@property(nonatomic, copy) void (^payBlock)(void);
@property(nonatomic, copy) void (^clearBlock)(void);
@end

NS_ASSUME_NONNULL_END

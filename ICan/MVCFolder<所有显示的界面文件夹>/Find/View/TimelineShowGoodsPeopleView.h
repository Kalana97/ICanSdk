//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 28/4/2020
- File name:  TimelineShowGoodsPeopleView.h
- Description: 显示点赞的人
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimelineShowGoodsPeopleView : UIView
@property(nonatomic, strong) NSArray *goodsPeopleItems;
-(void)showSurePaymentView;
-(void)hiddenSurePaymentView;

@end

NS_ASSUME_NONNULL_END

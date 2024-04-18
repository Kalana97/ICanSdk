//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 5/11/2019
- File name:  SearchHeadView.h
- Description:搜索头部通用的view
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranspondHeadView : UIView
@property(nonatomic, copy)     void (^searchDidChangeBlock)(NSString*search);
@property(nonatomic, copy)     NSString *searchTextFiledPlaceholderString;
@property(nonatomic, copy) void (^gotoNewChatBlock)(void);
-(void)addNotification;
@end


NS_ASSUME_NONNULL_END

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

@interface SearchHeadView : UIView
@property(nonatomic, copy)     void (^searchDidChangeBlock)(NSString*search);
@property(nonatomic, copy)     NSString *searchTextFiledPlaceholderString;
@property(nonatomic, copy)     void(^tapBlock)(void);
@property(nonatomic,assign)    BOOL shouShowKeybord;
@property(nonatomic, strong)   UIImageView *searchTipsImageView;
@property(nonatomic, strong)   QMUITextField *searTextField;
@property(nonatomic, strong)   UIView *bgView;
@property(nonatomic,copy)      void(^searchBlock)(void);
//这个方法是为了应付UI问题，以后很大可能会废弃
-(void)updateConstraint;
-(void)addNotification;
-(void)removeNotification;
@end


NS_ASSUME_NONNULL_END

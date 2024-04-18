//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/2
- ICan
- File name:  DZIconImageView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZIconImageView : UIImageView
-(void)addTap;
-(void)setDZIconImageViewWithUrl:(NSString*)headImageUrl gender:(NSString*)gender;
-(void)setCircleIconImageViewWithUrl:(NSString*)headImageUrl gender:(NSString*)gender;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END

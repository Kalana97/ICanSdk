//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/5/2021
- File name:  ConditionModel.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConditionModel : NSObject
@property(nonatomic, assign) BOOL isSelect;
@property(nonatomic, copy)   NSString *title;
@property(nonatomic, assign) BOOL hiddenImg;
@property(nonatomic, assign) CGFloat width;
+(instancetype)initConditionModelWithTitle:(NSString*)title isSelect:(BOOL)isSelect hiddenImg:(BOOL)hiddenImg;

@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/5/2021
- File name:  CircleBaseResponse.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleBaseResponse : NSObject

@end
@interface CircleListInfo : NSObject
@property(nonatomic, assign) NSInteger current;
/** 一共有多少页 */
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray  *records;
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) NSInteger total;

@end
NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 3/1/2020
- File name:  YBImageToolViewHandler.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
#import "YBIBToolViewHandler.h"
NS_ASSUME_NONNULL_BEGIN

@interface YBImageToolViewHandler : NSObject<YBIBToolViewHandler>
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *operationButton;
@property(nonatomic, copy) void (^deleImgeBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END

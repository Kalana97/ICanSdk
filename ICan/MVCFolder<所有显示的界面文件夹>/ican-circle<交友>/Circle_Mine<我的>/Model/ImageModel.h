//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  ImageModel.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) BOOL isAdd;
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MenuItem.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, assign) SelectMessageType selectMessageType;
+(instancetype)menuItemWithTitle:(NSString*)title img:(NSString*)img selectMessageType:(SelectMessageType)type;
@end

NS_ASSUME_NONNULL_END

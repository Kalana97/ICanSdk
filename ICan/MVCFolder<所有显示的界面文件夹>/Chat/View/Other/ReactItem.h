//
//  ReactItem.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-04.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReactItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *reactImg;
@property(nonatomic, copy) UIColor *bgColor;
+(instancetype)menuWithReactItem:(NSString *)title reactImg:(NSString *)reactImg bgColor:(UIColor *)bgColor;
@end

NS_ASSUME_NONNULL_END

//
//  BusinessBaseResponse.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessBaseResponse : NSObject

@end

@interface BusinessListInfo : NSObject
@property(nonatomic, assign) NSInteger current;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray *records;
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, strong) NSArray *images;
@end

NS_ASSUME_NONNULL_END

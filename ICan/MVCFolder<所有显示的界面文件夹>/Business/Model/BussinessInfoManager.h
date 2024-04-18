//
//  BussinessInfoManager.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-08.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BussinessInfoManager : NSObject
+ (instancetype)shared;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *areaEn;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, copy) NSString *checkAvatar;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, assign) NSInteger icanId;
- (void)removeObjectWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END

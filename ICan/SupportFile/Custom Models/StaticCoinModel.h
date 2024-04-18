//
//  StaticCoinModel.h
//  LinearObjC
//
//  Created by Sathsara Dharmarathna on 2023-03-30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaticCoinModel : NSObject

@property(nonatomic, strong) NSString *priceUsd;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *circulatingSupply;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

//
//  StaticCoinModel.m
//  LinearObjC
//
//  Created by Sathsara Dharmarathna on 2023-03-30.
//

#import "StaticCoinModel.h"

@implementation StaticCoinModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _date = dictionary[@"date"];
        _time = dictionary[@"time"];
        _priceUsd = dictionary[@"priceUsd"];
        _circulatingSupply = dictionary[@"circulatingSupply"];
    }
    return self;
}

@end

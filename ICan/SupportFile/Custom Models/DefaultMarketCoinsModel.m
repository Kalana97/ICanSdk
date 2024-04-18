//
//  DefaultMarketCoinsModel.m
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "DefaultMarketCoinsModel.h"

@implementation DefaultMarketCoinsModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _idCode = dictionary[@"id"];
        _name = dictionary[@"name"];
        _symbol = dictionary[@"symbol"];
        _priceUsd = dictionary[@"priceUsd"];
        _changePercent24Hr = dictionary[@"changePercent24Hr"];
        _explorer = dictionary[@"explorer"];
        _marketCapUsd = dictionary[@"marketCapUsd"];
        _maxSupply = dictionary[@"maxSupply"];
        _rank = dictionary[@"rank"];
        _volumeUsd24Hr = dictionary[@"volumeUsd24Hr"];
        _vwap24Hr = dictionary[@"vwap24Hr"];
        _supply = dictionary[@"supply"]; 
    }
    return self;
}

@end

//
//  DefaultMarketCoinsModel.h
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultMarketCoinsModel : NSObject
@property(nonatomic, strong) NSString *changePercent24Hr;
@property(nonatomic, strong) NSString *explorer;
@property(nonatomic, strong) NSString *idCode;
@property(nonatomic, strong) NSString *marketCapUsd;
@property(nonatomic, strong) NSString *maxSupply;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *priceUsd;
@property(nonatomic, strong) NSString *rank;
@property(nonatomic, strong) NSString *supply;
@property(nonatomic, strong) NSString *symbol;
@property(nonatomic, strong) NSString *volumeUsd24Hr;
@property(nonatomic, strong) NSString *vwap24Hr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

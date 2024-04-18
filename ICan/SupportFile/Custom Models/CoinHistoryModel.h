//
//  CoinHistoryModel.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-03-29.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoinHistoryModel : NSObject
@property (nonatomic, strong) NSString *priceUsd;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *circulatingSupply;
@property (nonatomic, strong) NSString *date;
@end

NS_ASSUME_NONNULL_END

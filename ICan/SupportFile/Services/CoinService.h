//
//  CoinService.h
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultMarketCoinsModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoinService : NSObject
- (void)getCoinsWithCompletion:(void (^)(NSMutableArray<DefaultMarketCoinsModel*> *coins))completion;
@end

NS_ASSUME_NONNULL_END

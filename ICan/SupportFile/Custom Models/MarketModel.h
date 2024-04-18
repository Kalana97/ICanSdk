//
//  MarketModel.h
//  ICan
//
//  Created by Sathsara on 2023-03-18.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketModel : NSObject
@property(nonatomic, strong) NSString *coindId;
@property(nonatomic, strong) NSString *coinName;
@property(nonatomic, strong) NSString *coinCode;
@property(nonatomic, strong) NSString *coinImageName;
@property(nonatomic, strong) NSString *coinPrice;
@property(nonatomic, assign) BOOL isUp;
@property(nonatomic, strong) NSString *coinPercentage;
@property(nonatomic, strong) UIColor *cellChangeColor;

@end

NS_ASSUME_NONNULL_END

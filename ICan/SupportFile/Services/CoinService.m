//
//  CoinService.m
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CoinService.h"
#import "DefaultMarketCoinsModel.h"

@implementation CoinService

- (void)getCoinsWithCompletion:(void (^)(NSMutableArray<DefaultMarketCoinsModel*> *coins))completion{
    NSURL *url = [NSURL URLWithString:@"https://api.coincap.io/v2/assets"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completion(nil);
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError);
            completion(nil);
            return;
        }
        NSArray *coinsJson = json[@"data"];
        NSMutableArray<DefaultMarketCoinsModel *> *coins = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *coinJson in coinsJson) {
                DefaultMarketCoinsModel *coin = [[DefaultMarketCoinsModel alloc] initWithDictionary:coinJson];
                [coins addObject:coin];
            }
            completion(coins);
        });
    }];
    [task resume];
}

@end

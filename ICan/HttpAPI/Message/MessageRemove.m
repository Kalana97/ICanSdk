//
//  MessageRemove.m
//  ICan
//
//  Created by MAC on 2023-08-04.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "MessageRemove.h"

@implementation MessageRemove
- (RequestMethod)requestMethod {
    return RequestMethod_Post;
}

- (NSString *)requestName {
    return @"Message_Remove";
}

- (NSString *)pathUrlString {
    return  [self.baseUrlString stringByAppendingString:@"/message/remove"];
}
@end

//
//  CollectionRequest.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/26.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "CollectionRequest.h"

@implementation PoiInfo



@end

@implementation CollectionMoreRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"收藏多个";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/favorites/batch"];
    
}


@end
@implementation CollectionRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"收藏";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/favorites"];
    
}


@end

@implementation CollectionListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收藏列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/favorites"];
    
}

@end

@implementation DeleteCollectionRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除收藏";
}


@end

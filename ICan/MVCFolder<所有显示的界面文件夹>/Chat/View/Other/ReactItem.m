//
//  ReactItem.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-04.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ReactItem.h"

@implementation ReactItem

+(instancetype)menuWithReactItem:(NSString *)title reactImg:(NSString *)reactImg bgColor:(UIColor *)bgColor{
    ReactItem *item = [[ReactItem alloc]init];
    item.title = title;
    item.reactImg = reactImg;
    item.bgColor = bgColor;
    return item;
}

@end

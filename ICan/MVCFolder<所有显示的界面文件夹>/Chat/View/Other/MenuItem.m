//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 26/10/2020
- File name:  MenuItem.m
- Description:
- Function List:
*/
        

#import "MenuItem.h"

@implementation MenuItem
+(instancetype)menuItemWithTitle:(NSString*)title img:(NSString*)img selectMessageType:(SelectMessageType)type{
    MenuItem*item=[[MenuItem alloc]init];
    item.title=title;
    item.img=img;
    item.selectMessageType=type;
    return item;
}

@end

//
//  ChatMoreTagItem.m
//  fortune
//
//  Created by lidazhi on 2018/11/14.
//  Copyright © 2018 DW. All rights reserved.
//

#import "ChatMoreTagItem.h"

@implementation ChatMoreTagItem
+(instancetype)chatMoreItemWithTitle:(NSString*)title imageStr:(NSString*)imageStr tag:(NSInteger)tag{
    ChatMoreTagItem*item=[[ChatMoreTagItem alloc]init];
    item.title=title;
    item.imageStr=imageStr;
    item.tag=tag;
    return item;
}
@end

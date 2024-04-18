//
//  ImageSettingItem.m
//  fortune
//
//  Created by 李达志 on 2018/8/27.
//  Copyright © 2018年 DW. All rights reserved.
//

#import "ImageSettingItem.h"

@implementation ImageSettingItem

-(instancetype)initWithLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle imgUrl:(NSString*)imgUrl{
    ImageSettingItem *item = [[ImageSettingItem alloc]init];
    item.leftTitle = leftTitle;
    item.rightTitle = rightTitle;
    item.imgUrl = imgUrl;
    return item;
    
}
@end

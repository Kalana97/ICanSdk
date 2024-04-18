//
//  ImageSettingItem.h
//  fortune
//
//  Created by 李达志 on 2018/8/27.
//  Copyright © 2018年 DW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSettingItem : NSObject
/** 图片url, 为 null 时不显示 */
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *leftTitle;
/** title */
@property (nonatomic,copy) NSString *rightTitle;
-(instancetype)initWithLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle imgUrl:(NSString*)imgUrl;


@end

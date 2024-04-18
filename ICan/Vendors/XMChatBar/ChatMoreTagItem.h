//
//  ChatMoreTagItem.h
//  fortune
//
//  Created by lidazhi on 2018/11/14.
//  Copyright © 2018 DW. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ChatMoreTagItem : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * imageStr;
@property (nonatomic,assign) NSInteger tag;
+(instancetype)chatMoreItemWithTitle:(NSString*)title imageStr:(NSString*)imageStr tag:(NSInteger)tag;
@end



//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/5/2021
- File name:  ConditionModel.m
- Description:
- Function List:
*/
        

#import "ConditionModel.h"

@implementation ConditionModel
+(instancetype)initConditionModelWithTitle:(NSString*)title isSelect:(BOOL)isSelect hiddenImg:(BOOL)hiddenImg{
    ConditionModel*model=[[ConditionModel alloc]init];
    model.title=title;
    model.isSelect=isSelect;
    model.hiddenImg=hiddenImg;
    return model;
}
-(CGFloat)width{
    CGFloat sizeWidth=[NSString widthForString:self.title withFont:[UIFont systemFontOfSize:12] height:20]+5;
    sizeWidth+=38;
    if (self.hiddenImg) {
        sizeWidth-=18;
    }
    return sizeWidth;
}
@end

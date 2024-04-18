//
//  CollectionResponse.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/26.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "CollectionResponse.h"
#import "XMFaceManager.h"
@implementation CollectionResponse

@end



@implementation CollectionListDetailResponse
-(NSMutableAttributedString *)nameLabelText{
    NSMutableAttributedString*att;
    if ([self.favoriteType isEqualToString:@"TimeLine"]) {
        att=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@·%@",@"ChatViewController.replyText".icanlocalized,self.originNickname]];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainSubTitleColor range:NSMakeRange(0, @"ChatViewController.replyText".icanlocalized.length+1)];
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorThemeMainTitleColor} range:NSMakeRange(@"ChatViewController.replyText".icanlocalized.length+1, self.originNickname.length)];
    }else {
        NSString*name=self.originGroupId?self.originGroupName:self.originNickname;
        att=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@·%@",@"From".icanlocalized,name]];
        [att addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainSubTitleColor range:NSMakeRange(0, @"From".icanlocalized.length+1)];
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorThemeMainTitleColor} range:NSMakeRange(@"From".icanlocalized.length+1, name.length)];
        
    }
    return att;
}
-(NSMutableAttributedString *)contentLabelText{
    NSMutableAttributedString*contentAtt;
    
    if ([self.favoriteType isEqualToString:@"TimeLine"]||[self.favoriteType isEqualToString:@"Txt"]) {
        contentAtt=[XMFaceManager emotionStrWithString:self.content];
        [contentAtt addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainTitleColor range:NSMakeRange(0, contentAtt.length)];
        [contentAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, contentAtt.length)];
    }
    return contentAtt;
}
+(NSMutableArray *)mj_totalIgnoredPropertyNames{
    return [NSMutableArray arrayWithObjects:@"contentLabelText",@"nameLabelText",nil];
}
@end

@implementation CollectionListResponse
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[CollectionListDetailResponse class]};
}

@end

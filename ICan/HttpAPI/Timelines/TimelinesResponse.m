//
//  TimelinesResponse.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/9.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesResponse.h"
#import "XMFaceManager.h"
#import "TimelinesCommentInfo.h"
@implementation TimelinesResponse

@end

@implementation SharedMessageInfo



@end

@implementation TimelinesListDetailInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+(NSMutableArray *)mj_totalIgnoredPropertyNames{
    return [NSMutableArray arrayWithObjects:@"textAttributedString",nil];
}
-(void)cacheTimeLineDetailHeight{
    NSMutableAttributedString*attrStr = [XMFaceManager getEmotionStrWithString:self.content fontSize:16 color:UIColor252730Color];
    CGFloat originHeight = [NSString heightWithAttrbuteString:attrStr width:ScreenWidth-20 cgflotTextFont:16];;
    self.originContentHeight = originHeight;
    NSString * shareMessageNickName = self.sharedMessage.nickName;
    NSString * appdenString = [NSString stringWithFormat:@"%@:%@",shareMessageNickName,self.sharedMessage.content?self.sharedMessage.content:@""];
    NSMutableAttributedString *shareattrStr = [XMFaceManager getEmotionStrWithString:appdenString fontSize:16 color:UIColor252730Color];
    CGFloat shareContentHeight ;
    CGFloat originShareContentHeight;
    //文字的总高度
    originShareContentHeight = [NSString heightWithAttrbuteString:attrStr width:ScreenWidth-20 cgflotTextFont:16];;
    if (shareattrStr.string.length<=0) {
        shareContentHeight=0;
        originShareContentHeight=0;
    }
    self.originShareContentHeight = originShareContentHeight;
    if (self.sharedMessage) {
        if (self.imageUrls.count == 1) {
            CGFloat oneImageHeight=320;
            if (self.sharedMessage.width>0) {
                oneImageHeight=(self.sharedMessage. height/(self.sharedMessage.width*1.0f))*ScreenWidth;
                if (oneImageHeight>=ScreenHeight-NavBarHeight-TabBarHeight) {
                    oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
                }
            }
            self.oneImageHeight=oneImageHeight;
        }

    }else{
        //不是分享的
        if (self.imageUrls.count == 1) {
            CGFloat oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
            if (self.width>0) {
                oneImageHeight=(self.height/(self.width*1.0f))*ScreenWidth;
                if (oneImageHeight>=ScreenHeight-NavBarHeight-TabBarHeight) {
                    oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
                }
            }
            self.oneImageHeight=oneImageHeight;
        }
    }
    [self settextAttributedString];
}

-(void)cacheCellHeightWith{
    NSMutableAttributedString*attrStr = [XMFaceManager getEmotionStrWithString:self.content fontSize:16 color:UIColor252730Color];
    CGFloat contentHeight = 0;
    CGFloat originHeight = [NSString getHeightWithAttrbuteString:attrStr width:ScreenWidth-20 cgflotTextFont:16.0 numberOfLines:0];
    self.originContentHeight = originHeight+10;
    if (attrStr.string.length>0) {
        if (self.videoUrl.length==0&&self.imageUrls.count==0) {
            contentHeight = [NSString getHeightWithAttrbuteString:attrStr width:ScreenWidth-20 cgflotTextFont:16.0 numberOfLines:7];
        }else{
            contentHeight = [NSString getHeightWithAttrbuteString:attrStr width:ScreenWidth-20 cgflotTextFont:16.0 numberOfLines:7];
        }
        self.showAllButton=originHeight>contentHeight;
    }
    NSString * shareMessageNickName = self.sharedMessage.nickName;
    NSString * appdenString = [NSString stringWithFormat:@"%@:%@",shareMessageNickName,self.sharedMessage.content?self.sharedMessage.content:@""];
    NSMutableAttributedString *shareattrStr = [XMFaceManager getEmotionStrWithString:appdenString fontSize:16 color:UIColor252730Color];
    CGFloat shareContentHeight ;
    CGFloat originShareContentHeight;
    //7行文字的高度
    shareContentHeight =[NSString getHeightWithAttrbuteString:shareattrStr width:ScreenWidth-20 cgflotTextFont:16.0 numberOfLines:7];
    //文字的总高度
    originShareContentHeight=[NSString getHeightWithAttrbuteString:shareattrStr width:ScreenWidth-20 cgflotTextFont:16.0 numberOfLines:0];
    if (shareattrStr.string.length<=0) {
        shareContentHeight=0;
        originShareContentHeight=0;
    }
    self.showShareAllButton = originShareContentHeight>shareContentHeight;
    self.originShareContentHeight = originShareContentHeight+10;
    self.contentHeight = contentHeight+10;
    self.shareContentHeight = shareContentHeight+10;
    if (self.sharedMessage) {
        if (self.imageUrls.count == 1) {
            CGFloat oneImageHeight=320;
            if (self.sharedMessage.width>0) {
                oneImageHeight=(self.sharedMessage. height/(self.sharedMessage.width*1.0f))*ScreenWidth;
                if (oneImageHeight>=ScreenHeight-NavBarHeight-TabBarHeight) {
                    oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
                }
            }
            self.oneImageHeight=oneImageHeight;
        }

    }else{
        //不是分享的
        if (self.imageUrls.count == 1) {
            CGFloat oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
            if (self.width>0) {
                oneImageHeight=(self.height/(self.width*1.0f))*ScreenWidth;
                if (oneImageHeight>=ScreenHeight-NavBarHeight-TabBarHeight) {
                    oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-50;
                }
            }
            self.oneImageHeight=oneImageHeight;
        }
    }
    [self setTimeLineContentLabelText];

}
-(void)setTimeLineContentLabelText{
    if (self.content) {
        NSMutableAttributedString *textAttributedString = [XMFaceManager getEmotionStrWithString:self.content fontSize:16 color:UIColor252730Color];
        NSArray*atItems=[self.ext mj_JSONObject];
        NSMutableArray*atNicknameites=[NSMutableArray array];
        NSMutableArray*allDictItem=[NSMutableArray array];
        for (NSDictionary*dict in atItems) {
            NSString*tap=[NSString stringWithFormat:@"@%@",dict[@"v"]];
            [atNicknameites addObject:tap];
            [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorMake(29, 129, 245) range:[textAttributedString.string rangeOfString:tap]];
            [allDictItem addObject:@{dict[@"k"]:tap}];
        }
        
        NSArray*urlArray=[NSString getTimeLineUrlStringFromNSMutableAttributedString:textAttributedString];
        for (NSString*url in urlArray) {
            [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorMake(29, 129, 245) range:[textAttributedString.string rangeOfString:url]];
        }
        [atNicknameites addObjectsFromArray:urlArray];
        self.atDictItems = allDictItem;
        self.atPeopleItems = atNicknameites;
        self.contentLabelAttString = textAttributedString;
    }
    if (self.sharedMessage) {
        NSString * shareContent = self.sharedMessage.content?self.sharedMessage.content:@"";
        NSString * shareMessageNickName = self.sharedMessage.nickName;
        NSString * appdenString = [NSString stringWithFormat:@"%@:%@",shareMessageNickName,shareContent];
        NSMutableAttributedString *textAttributedString = [XMFaceManager getEmotionStrWithString:appdenString fontSize:16 color:UIColor252730Color];
        NSArray*extItems=[self.sharedMessage.ext mj_JSONObject];
        //这里把原始帖子的名字，id，设置成字典添加进去。
        NSDictionary * shareDic = @{@"v":shareMessageNickName,@"k":self.sharedMessage.belongsId};
        NSMutableArray * atItems = [NSMutableArray array];
        //先添加原始帖子的
        [atItems addObject:shareDic];
        if (extItems.count>0) {
            [atItems addObjectsFromArray:extItems];
        }
        NSMutableArray*atNicknameites=[NSMutableArray array];
        NSMutableArray*allDictItem=[NSMutableArray array];
        for (int i = 0; i<atItems.count; i++) {
            NSDictionary * dict = atItems[i];
            if (i==0) {
                NSString*tap=[NSString stringWithFormat:@"%@",dict[@"v"]];
                [atNicknameites addObject:tap];
                [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorMake(29, 129, 245) range:[textAttributedString.string rangeOfString:tap]];
                [allDictItem addObject:@{self.sharedMessage.belongsId:tap}];
            }else{
                NSString*tap=[NSString stringWithFormat:@"@%@",dict[@"v"]];
                [atNicknameites addObject:tap];
                [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorMake(29, 129, 245) range:[textAttributedString.string rangeOfString:tap]];
                [allDictItem addObject:@{dict[@"k"]:tap}];
            }
        }
        
        NSArray*urlArray = [NSString getTimeLineUrlStringFromNSMutableAttributedString:textAttributedString];
        for (NSString*url in urlArray) {
            [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColorMake(29, 129, 245) range:[textAttributedString.string rangeOfString:url]];
        }
        [atNicknameites addObjectsFromArray:urlArray];
        
        self.shareContentLabelAttString = textAttributedString;
        self.atShareDictItems = allDictItem;
        self.atSharePeopleItems = atNicknameites;
    }
}
-(void)settextAttributedString{
    NSMutableAttributedString *textAttributedString = [[NSMutableAttributedString alloc]init];
    NSString * shareContent = self.sharedMessage.content?self.sharedMessage.content:@"";
    if (self.sharedMessage) {
        NSString * shareMessageNickName = self.sharedMessage.nickName;
        NSString * appdenString = [NSString stringWithFormat:@"%@:%@",shareMessageNickName,shareContent];
        textAttributedString = [XMFaceManager getEmotionStrWithString:appdenString fontSize:16 color:UIColor252730Color];
        NSArray*extItems=[self.sharedMessage.ext mj_JSONObject];
        //这里把原始帖子的名字，id，设置成字典添加进去。
        NSDictionary * shareDic = @{@"v":shareMessageNickName,@"k":self.sharedMessage.belongsId};
        NSMutableArray * atItems = [NSMutableArray array];
        //先添加原始帖子的
        [atItems addObject:shareDic];
        if (extItems.count>0) {
            [atItems addObjectsFromArray:extItems];
        }
        NSMutableArray*atNicknameites=[NSMutableArray array];
        for (int i = 0; i<atItems.count; i++) {
            NSDictionary * dict = atItems[i];
            if (i==0) {
                NSString*tap=[NSString stringWithFormat:@"%@",dict[@"v"]];
                [atNicknameites addObject:tap];
               
                [textAttributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"http://icanuseid_%@",dict[@"k"]] range:[textAttributedString.string rangeOfString:tap]];
            }else{
                NSString*tap=[NSString stringWithFormat:@"@%@",dict[@"v"]];
                [atNicknameites addObject:tap];
                [textAttributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"http://icanuseid_%@",dict[@"k"]] range:[textAttributedString.string rangeOfString:tap]];
            }
        }
        self.shareContenttextAttributedString = [NSString getUrl:textAttributedString];
    }
    textAttributedString = [XMFaceManager getEmotionStrWithString:self.content fontSize:16 color:UIColor252730Color];
    NSArray*atItems=[self.ext mj_JSONObject];
    NSMutableArray*atNicknameites=[NSMutableArray array];
    for (NSDictionary*dict in atItems) {
        NSString*tap=[NSString stringWithFormat:@"@%@",dict[@"v"]];
        [textAttributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"http://icanuseid_%@",dict[@"k"]] range:[textAttributedString.string rangeOfString:tap]];
        [atNicknameites addObject:tap];

    }
    self.contenttextAttributedString = [NSString getUrl:textAttributedString];
}
-(NSString *)visibleRangeImgStr{
    if ([self.visibleRange isEqualToString:@"Open"]) {
        return @"icon_timeline_post_setting_open";
    }else if ([self.visibleRange isEqualToString:@"OnlyMyself"]){
        return @"icon_timeline_post_setting_myself";
    }else if ([self.visibleRange isEqualToString:@"AllFriend"]){
        return @"icon_timeline_post_setting_friend";
    }else if ([self.visibleRange isEqualToString:@"SomeFriends"]){
        return @"icon_timeline_post_setting_appoint";
    }else{
        return @"icon_timeline_post_setting_except";
    }
}
@end

@implementation TimelineContentInfo

@end

@implementation TimelinesListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[TimelineContentInfo class]};
}

@end

@implementation TimeLinesNonDynamicListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[TimelinesListDetailInfo class]};
}
@end


@implementation ReplyVOsInfo



@end

@implementation TimelinesDetailInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"comments":[TimelinesCommentInfo class]};
}
@end

@implementation TimelineLoveInfo


@end

@implementation TimelinesReportInfo

@end

@implementation DynamicMessageDataList
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"identifier": @"id",
        @"imageURL": @"imageUrl",
        @"onclickData": @"onclickData",
        @"onclickFunction": @"onclickFunction",
        @"title": @"title",
    };
}
@end

@implementation DynamicMessageLanguage
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"code": @"code",
        @"enabled": @"isEnabled",
        @"name": @"name",
        @"nameCn": @"nameCN",
        @"nameEn": @"nameEn",
    };
}
@end

@implementation TimeLineDynamicMessage
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"dataList": @"dataList",
        @"headerImgURL": @"headerImgUrl",
        @"identifier": @"id",
        @"merchantId": @"merchantId",
        @"language": @"language",
        @"messageData": @"messageData",
        @"messageType": @"messageType",
        @"onclickData": @"onclickData",
        @"onclickFunction": @"onclickFunction",
        @"sender": @"sender",
        @"senderImgURL": @"senderImgUrl",
        @"showType": @"showType",
        @"showTime": @"showTime",
        @"title": @"title"
    };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"dataList":[DynamicMessageDataList class]};
}
@end

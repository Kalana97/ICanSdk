//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/10
 - ICan
 - File name:  WCDBManager+ChatSetting.m
 - Description:
 - Function List:
 */


#import "WCDBManager+ChatSetting.h"
#import "ChatSetting+WCTTableCoding.h"
#import "ChatModel.h"
@implementation WCDBManager (ChatSetting)
-(ChatSetting*)fetchChatSettingWith:(ChatModel*)config{
    return [self.wctDatabase getObjectsOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==config.chatID&&ChatSetting.chatType==config.chatType&&ChatSetting.authorityType==config.authorityType}].firstObject;
}

-(void)updateChatSettingIsStick:(BOOL)isStick chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType{
    ChatSetting*lsetting=[self.wctDatabase getOneObjectOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType}];
    if (lsetting) {
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.isStick} withValue:@(isStick) where:ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType];
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.isStick=isStick;
        model.chatId=chatId;
        model.chatType=chatType;
        model.authorityType=authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}
-(void)updateChatSettingIsNoDisturbing:(BOOL)isNoDisturbing chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType{
    ChatSetting*lsetting=[self.wctDatabase getOneObjectOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType}];
    if (lsetting) {
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.isNoDisturbing} withValue:@(isNoDisturbing) where:ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType];
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.isNoDisturbing=isNoDisturbing;
        model.chatId=chatId;
        model.chatType=chatType;
        model.authorityType=authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}
/// 本地的截屏通知
-(void)updateChatSettingScreencast:(BOOL)isOpenScreencast chatId:(NSString *)chatId isGroup:(BOOL)isGroup chatType:(NSString*)chatType authorityType:(NSString*)authorityType{
    NSArray*array=[self.wctDatabase getObjectsOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType}];
    if (array.count>0) {
        
        ChatSetting*model=array.firstObject;
        if (isGroup) {
            model.towardsisOpenTaskScreenNotice=isOpenScreencast;
            NSArray*row=@[@(model.towardsisOpenTaskScreenNotice)];
            [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperties:{ChatSetting.towardsisOpenTaskScreenNotice} withRow:row where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType}];
        }else{
            model.isOpenTaskScreenNotice=isOpenScreencast;
            NSArray*row=@[@(model.isOpenTaskScreenNotice)];
            [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperties:{ChatSetting.isOpenTaskScreenNotice} withRow:row where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType}];
            
        }
        
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.isOpenTaskScreenNotice=isOpenScreencast;
        model.chatId=chatId;
        model.chatType=chatType;
        model.authorityType=authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}
-(void)updateChatSettingIsShowNickname:(BOOL)isShowNickname chatId:(NSString*)chatId chatType:(NSString*)chatType{
    NSArray*array=[self.wctDatabase getObjectsOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId}];
    if (array.count>0) {
        ChatSetting*model=array.firstObject;
        model.isShowNickName=isShowNickname;
        NSArray*row=@[@(model.isShowNickName)];
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperties:{ChatSetting.isShowNickName} withRow:row where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType}];
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.isShowNickName=isShowNickname;
        model.chatId=chatId;
        model.chatType=chatType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}

-(void)updateChatSettingTowardsisOpenTaskScreenNotice:(BOOL)isOpenTaskScreenNotice chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType{
    ChatSetting*lsetting=[self.wctDatabase getOneObjectOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType}];
    if (lsetting) {
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.towardsisOpenTaskScreenNotice} withValue:@(isOpenTaskScreenNotice) where:ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType];
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.towardsisOpenTaskScreenNotice=isOpenTaskScreenNotice;
        model.chatId=chatId;
        model.chatType=chatType;
        model.authorityType=authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}
-(void)updateChatSettingDestoryTime:(NSString *)destoryTime chatId:(NSString *)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType{
    ChatSetting*lsetting=[self.wctDatabase getOneObjectOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType}];
    if (lsetting) {
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.destoryTime} withValue:destoryTime where:ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType];
    }else{
        ChatSetting*model=[[ChatSetting alloc]init];
        model.destoryTime=destoryTime;
        model.chatId=chatId;
        model.chatType=chatType;
        model.authorityType=authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}

-(void)updateTranslationSettingStates:(NSString *)translateLanguage translateLanguageCode:(NSString *)translateLanguageCode chatId:(NSString *)chatId chatType:(NSString *)chatType authorityType:(NSString *)authorityType{
    ChatSetting *lsetting = [self.wctDatabase getOneObjectOfClass:[ChatSetting class] fromTable:KWCChatSettingTable where:{ChatSetting.chatId == chatId && ChatSetting.chatType == chatType && ChatSetting.authorityType == authorityType}];
    if (lsetting) {
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.translateLanguage} withValue:translateLanguage where:ChatSetting.chatId == chatId && ChatSetting.chatType == chatType];
        [self.wctDatabase updateRowsInTable:KWCChatSettingTable onProperty:{ChatSetting.translateLanguageCode} withValue:translateLanguageCode where:ChatSetting.chatId == chatId && ChatSetting.chatType == chatType];
    }else {
        ChatSetting *model = [[ChatSetting alloc]init];
        model.translateLanguage = translateLanguage;
        model.translateLanguageCode = translateLanguageCode;
        model.chatId = chatId;
        model.chatType = chatType;
        model.authorityType = authorityType;
        [self.wctDatabase insertObject:model into:KWCChatSettingTable];
    }
}

-(void)deleteOneChatSettingWithChatId:(NSString *)chatId chatType:(NSString *)chatType authorityType:(NSString*)authorityType{
   BOOL b= [self.wctDatabase deleteObjectsFromTable:KWCChatSettingTable where:ChatSetting.chatId==chatId&&ChatSetting.chatType==chatType&&ChatSetting.authorityType==authorityType];
    if (!b) {
        [self.wctDatabase deleteObjectsFromTable:KWCChatSettingTable where:ChatSetting.chatId==chatId];
    }
}
@end

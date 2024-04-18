//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 26/3/2020
 - File name:  TranslateTool.m
 - Description:
 - Function List:
 */


#import "TranslateTool.h"
#import "Firebase.h"
@implementation TranslateTool
bool downloading;
+ (void)identifyLanguageForText:(NSString*)text block:(void (^)(NSString * _Nonnull))identifyBlock{
    FIRNaturalLanguage *naturalLanguage = [FIRNaturalLanguage naturalLanguage];
    FIRLanguageIdentification *languageId = [naturalLanguage languageIdentification];
    [languageId identifyLanguageForText:text
                             completion:^(NSString * _Nullable languageCode,
                                          NSError * _Nullable error) {
        if (error) {
            identifyBlock(@"false");
        }else{
            if (languageCode != nil
                && ![languageCode isEqualToString:@"und"] ) {
                identifyBlock(languageCode);
                
            } else {
                //无法识别，默认是翻译成功
                identifyBlock(@"und");
            }
        }
//        [self ddd];
        
        
    }];
}
+(void)translateLanguageForText:(NSString *)text translateFailBlock:(void (^)(void))translateFailBlock translateSuccessBlock:(void (^)(NSString * _Nonnull))translateSuccessBlock{
    FIRNaturalLanguage *naturalLanguage = [FIRNaturalLanguage naturalLanguage];
    FIRLanguageIdentification *languageId = [naturalLanguage languageIdentification];
    [languageId identifyLanguageForText:text
                             completion:^(NSString * _Nullable languageCode,
                                          NSError * _Nullable error) {
        if (error) {
            translateFailBlock();
        }else{
            if (languageCode != nil
                && ![languageCode isEqualToString:@"und"] ) {
                [self startTranslateLanguageForText:text originLanguageCode:languageCode translateFailBlock:translateFailBlock translateSuccessBlock:translateSuccessBlock];
                
            } else {
                //无法识别，默认是翻译成功 并且翻译的文字就是原文字
                translateSuccessBlock(text);
            }
        }
      
        
        
    }];
}
+(void)startTranslateLanguageForText:(NSString *)text originLanguageCode:(NSString*)originLanguageCode translateFailBlock:(void (^)(void))translateFailBlock translateSuccessBlock:(void (^)(NSString * _Nonnull))translateSuccessBlock{
    NSArray *arLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *localLanguae = [arLanguages objectAtIndex:0];
    if ([localLanguae containsString:@"zh"]) {
        localLanguae=@"zh";
    }
    if ([localLanguae containsString:@"en"]) {
        localLanguae=@"en";
    }
    //手机的系统语言 对应的谷歌翻译序号
    FIRTranslateLanguage targetLanguage=  FIRTranslateLanguageForLanguageCode(localLanguae);
    FIRTranslateLanguage originLanguage=  FIRTranslateLanguageForLanguageCode(originLanguageCode);
    // Create an English-German translator:
    //创建一个 Translator 对象，并使用源语言和目标语言对其进行配置：
    FIRTranslatorOptions *options =
    [[FIRTranslatorOptions alloc] initWithSourceLanguage:originLanguage
                                          targetLanguage:targetLanguage];
    
    FIRTranslator *englishGermanTranslator =
    [[FIRNaturalLanguage naturalLanguage] translatorWithOptions:options];
    //2.确保已将所需的翻译模型下载到设备中。了解到模型可用之后，再调用 translate(_:completion:)。
    FIRModelDownloadConditions *conditions =
    [[FIRModelDownloadConditions alloc] initWithAllowsCellularAccess:YES
                                         allowsBackgroundDownloading:YES];
    //获取本地已经下载的语言包
    NSSet<FIRTranslateRemoteModel *> *localModels =
    [FIRModelManager modelManager].downloadedTranslateModels;
    NSMutableArray*array=[NSMutableArray array];
    for (FIRTranslateRemoteModel*model in localModels) {
        [array addObject:@(model.language)];
    }
    BOOL contain=YES;
    if (downloading) {
        [QMUITipsTool showLoadingWihtMessage:@"语言包下载中..." inView:nil];
        return;
    }
    if (![array containsObject:@(originLanguage)]||![array containsObject:@(targetLanguage)]) {
        contain=NO;
        downloading=YES;
        [QMUITipsTool showLoadingWihtMessage:@"语言包下载中..." inView:nil];
    }
//    [englishGermanTranslator ]
    [englishGermanTranslator downloadModelIfNeededWithConditions:conditions
                                                      completion:^(NSError *_Nullable error) {
        if (error != nil) {
            translateFailBlock();
            return;
        }
        
        // Model downloaded successfully. Okay to start translating.
        //根据设置的语言开始翻译
        [englishGermanTranslator translateText:text
                                    completion:^(NSString *_Nullable translatedText,
                                                 NSError *_Nullable error) {
            if (error != nil || translatedText == nil) {
                translateFailBlock();
                return;
            }
            translateSuccessBlock(translatedText);
            
            // Translation succeeded.
        }];
    }];
////    __block MyViewController *weakSelf = self;
//
//    [NSNotificationCenter.defaultCenter
//     addObserverForName:FIRModelDownloadDidSucceedNotification
//     object:nil
//     queue:nil
//     usingBlock:^(NSNotification * _Nonnull note) {
//         if ( note.userInfo == nil) {
//             return;
//         }
//
//         FIRTranslateRemoteModel *model = note.userInfo[FIRModelDownloadUserInfoKeyRemoteModel];
//         if ([model isKindOfClass:[FIRTranslateRemoteModel class]]) {
//             NSLog(@"下载成功");
//         }
//     }];
//
//    [NSNotificationCenter.defaultCenter
//     addObserverForName:FIRModelDownloadDidFailNotification
//     object:nil
//     queue:nil
//     usingBlock:^(NSNotification * _Nonnull note) {
////         if (weakSelf == nil | note.userInfo == nil) {
////             return;
////         }
//        NSLog(@"下载失败");
//         NSError *error = note.userInfo[FIRModelDownloadUserInfoKeyError];
//     }];
    
}







+(void)getDownloadedTranslateModels{
    NSSet<FIRTranslateRemoteModel *> *localModels =
    [FIRModelManager modelManager].downloadedTranslateModels;
    for (FIRTranslateRemoteModel*model in localModels) {
        NSLog(@"model=%ld",model.language);
    }
    NSLog(@"");
}
@end

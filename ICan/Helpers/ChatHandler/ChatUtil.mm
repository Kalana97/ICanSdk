

#import "ChatUtil.h"
#import "ChatModel.h"
#import "ChatAlbumModel.h"
#import <Photos/Photos.h>
#import "WCDBManager.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+UserMessageInfo.h"
#import "SDImageCache.h"
@implementation ChatUtil
+(ChatModel*)creatChatMessageModelWithConfig:(ChatModel*)configModel{
    ChatModel * chatModel = [[ChatModel alloc]init];
    chatModel.messageFrom     = [UserInfoManager sharedManager].userId;
    chatModel.messageTo       = configModel.chatID;
    chatModel.chatType        = configModel.chatType;
    chatModel.chatID  = configModel.chatID;;
    if ([WebSocketManager sharedManager].connectStatus==SocketConnectStatus_Connected) {
         chatModel.sendState=2;
    }else{
         chatModel.sendState=0;
    }
    chatModel.authorityType = configModel.authorityType;;
    chatModel.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
    chatModel.messageID=[NSString getCFUUID];
    chatModel.isOutGoing        = YES;
    chatModel.hasRead         = YES;
    if (configModel.circleUserId) {
        chatModel.circleUserId = configModel.circleUserId;
    }
    if (configModel.c2cUserId&&configModel.c2cOrderId) {
        chatModel.c2cUserId = configModel.c2cUserId;
        chatModel.c2cOrderId = configModel.c2cOrderId;
    }
    ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:configModel];
    if ([configModel.authorityType isEqualToString:AuthorityType_secret]) {
        chatModel.destoryTime = @"7200";
    }else if ([configModel.authorityType isEqualToString:AuthorityType_friend]){
        chatModel.destoryTime = setting.destoryTime?:@"0";
    }else if ([configModel.authorityType isEqualToString:AuthorityType_circle]){
        chatModel.destoryTime = setting.destoryTime?:@"0";
    }else if ([configModel.authorityType isEqualToString:AuthorityType_c2c]){
        chatModel.destoryTime = @"0";
    }
    return chatModel;
}
+(ChatModel*)creatChatMessageModelWithChatId:(NSString*)chatId chatType:(NSString*)chatType authorityType:(NSString*)authorityType circleUserId:(NSString*)circleUserId{
    ChatModel * chatModel = [[ChatModel alloc]init];
    chatModel.messageFrom     = [UserInfoManager sharedManager].userId;
    chatModel.messageTo         = chatId;
    chatModel.chatType        = chatType;
    chatModel.chatID  =chatId;
    if ([WebSocketManager sharedManager].connectStatus==SocketConnectStatus_Connected) {
         chatModel.sendState=2;
    }else{
         chatModel.sendState=0;
    }
    chatModel.authorityType=authorityType;
    chatModel.messageTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
    chatModel.messageID=[NSString getCFUUID];
    chatModel.isOutGoing        = YES;
    chatModel.hasRead         = YES;
    if (circleUserId) {
        chatModel.circleUserId=circleUserId;
    }
    ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
    if ([authorityType isEqualToString:AuthorityType_secret]) {
        chatModel.destoryTime = @"7200";
    }else if ([authorityType isEqualToString:AuthorityType_friend]){
        chatModel.destoryTime = setting.destoryTime?:@"0";
    }else if ([authorityType isEqualToString:AuthorityType_circle]){
        chatModel.destoryTime = setting.destoryTime?:@"0";
    }else if ([authorityType isEqualToString:AuthorityType_c2c]){
        chatModel.destoryTime = @"0";
    }
    
    return chatModel;
}


//初始化文本消息模型
+ (ChatModel *)initTextMessage:(NSString *)text config:(ChatModel *)config{
    ChatModel *textModel = [self creatChatMessageModelWithConfig:config];
    textModel.messageType = TextMessageType;
    textModel.showMessage = text;
    textModel.messageContent = [@{@"content":text} mj_JSONString];
    return textModel;
}
+ (ChatModel *)initUrlMessage:(NSString *)text config:(ChatModel *)config{
    ChatModel *textModel =[self creatChatMessageModelWithConfig:config];
    textModel.messageType = URLMessageType;
    textModel.showMessage = text;
    textModel.messageContent  = [@{@"content":text} mj_JSONString];
    return textModel;
}
+ (ChatModel *)initGamifyTextMessage:(NSString *)text config:(ChatModel *)config{
    ChatModel *textModel =[self creatChatMessageModelWithConfig:config];
    textModel.messageType = GamifyMessageType;
    textModel.showMessage = text;
    textModel.messageContent  = [@{@"content":text} mj_JSONString];
    return textModel;
}
+(ChatModel *)initScreenNotice:(ChatModel *)config{
    ChatModel*screenModel=[self creatChatMessageModelWithConfig:config];
    screenModel.messageType=Notice_ScreencastType;
    return screenModel;
}
+(ChatModel*)initAddFriendWithChatId:(NSString*)chatId authorityType:(NSString*)authorityType{
    ChatModel *textModel =[self creatChatMessageModelWithChatId:chatId chatType:UserChat authorityType:authorityType circleUserId:nil];
    textModel.messageType =Add_friend_successType;
    Add_friend_successInfo*info=[[Add_friend_successInfo alloc]init];
    info.beInvited=@(chatId.integerValue);
    info.invite=@(UserInfoManager.sharedManager.userId.integerValue);
    textModel.messageContent=[info mj_JSONString];
    if (BaseSettingManager.isChinaLanguages) {
        textModel.showMessage=@"You are become friends each other".icanlocalized;
        return textModel;
    }
    UserMessageInfo*uinfo=[[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatId];
    textModel.showMessage=[NSString stringWithFormat:@"You  added %@ as a friend, say hi!",uinfo.remarkName?:uinfo.nickname];
    return textModel;
    
    
}
//初始化名片消息模型
+(ChatModel *)initUserCardModelWithConfig:(ChatModel *)config{
    ChatModel *transModel =  [self creatChatMessageModelWithConfig:config];
    transModel.messageType =UserCardMessageType;
    return transModel;
    
}

//初始化语音消息模型
+ (ChatModel *)initAudioMessage:(ChatAlbumModel *)audio config:(ChatModel *)config{
    ChatModel *audioModel =  [self creatChatMessageModelWithConfig:config];
    audioModel.messageType = VoiceMessageType;
    audioModel.mediaSeconds = [audio.duration integerValue];
    audioModel.fileCacheName = audio.name;
    audioModel.voiceHasRead = YES;
    return audioModel;
}
+(ChatModel*)creatVideoChatModelWith:(ChatModel*)config saveUrl:(NSURL*)saveUrl firstImage:(UIImage*)firstImage{
    ChatModel*videoModel=[self creatChatMessageModelWithConfig:config];
    NSString * fileName=[saveUrl absoluteString].lastPathComponent;
    //注意是上传的文件名 带有.mp4
    videoModel.fileCacheName=fileName;
    videoModel.uploadState=2;
    videoModel.messageType=VideoMessageType;
    //这里用来传递一下本地的视频路径方便上传
    videoModel.showFileName=saveUrl.absoluteString;
    videoModel.orignalImageData = UIImageJPEGRepresentation(firstImage, 0.8);
    NSString *basePath = MessageVideoCache(config.chatID);
    //缓存第一帧图片路径
    NSString *detailPath = [basePath stringByAppendingPathComponent:[videoModel.fileCacheName componentsSeparatedByString:@"."].firstObject];
    [DZFileManager saveFile:detailPath withData:videoModel.orignalImageData];
    return videoModel;
}
//初始化图片消息模型
+ (NSArray<ChatModel *> *)initPicMessage:(NSArray<ChatAlbumModel *> *)pics config:(ChatModel *)config isGif:(BOOL)isGif {
    NSMutableArray *tmpArray = [NSMutableArray array];
    if (!isGif) {
        for (ChatAlbumModel *chatAlbumModel in pics) {
            //创建图片模型
            ChatModel *picModel =  [self creatChatMessageModelWithConfig:config];
            picModel.messageType = ImageMessageType;
            picModel.fileCacheName = chatAlbumModel.name;
            picModel.uploadState=2;
            picModel.sendState=2;
            picModel.isOrignal=chatAlbumModel.isOrignal;
            picModel.compressImageData=chatAlbumModel.compressImageData;
            picModel.orignalImageData=chatAlbumModel.orignalImageData;
            picModel.chatType=config.chatType;
            [tmpArray addObject:picModel];
            NSString *basePath = MessageImageCache(config.chatID);
            //小图缓存路径
            NSString *smallDetailPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",picModel.fileCacheName]];
            //原图缓存路径
            NSString *detailPath = [basePath stringByAppendingPathComponent:picModel.fileCacheName];
            [DZFileManager saveFile:smallDetailPath withData:chatAlbumModel.compressImageData];
            [DZFileManager saveFile:detailPath withData:chatAlbumModel.orignalImageData];
        }
    }else{
        //创建图片模型
        ChatAlbumModel *chatAlbumModel =pics.lastObject;
        ChatModel *picModel =  [self creatChatMessageModelWithConfig:config];
        picModel.messageType = ImageMessageType;
        picModel.fileCacheName = chatAlbumModel.name;
        picModel.uploadState=2;
        picModel.sendState=2;
        picModel.isOrignal=chatAlbumModel.isOrignal;
        picModel.compressImageData=chatAlbumModel.orignalImageData;
        picModel.orignalImageData=chatAlbumModel.orignalImageData;
        picModel.chatType=config.chatType;
        NSString *basePath = MessageImageCache(config.chatID);
        //小图缓存路径
        NSString *smallDetailPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",picModel.fileCacheName]];
        //原图缓存路径
        NSString *detailPath = [basePath stringByAppendingPathComponent:picModel.fileCacheName];
        [DZFileManager saveFile:smallDetailPath withData:chatAlbumModel.orignalImageData];
        [DZFileManager saveFile:detailPath withData:chatAlbumModel.orignalImageData];
        [tmpArray addObject:picModel];
    }
    
    return tmpArray;
}
+(ChatModel*)creatTranspondFileWithChatModel:(ChatModel*)model{
    ChatModel *fileModel =  [self creatChatMessageModelWithConfig:model];
    fileModel.messageType = FileMessageType;
    fileModel.showFileName = model.showFileName;
    fileModel.fileCacheName=[NSString stringWithFormat:@"%@.%@",[NSString getCFUUID],model.showFileName.pathExtension];
    fileModel.uploadState=2;
    fileModel.totalUnitCount=model.fileData.length;
    fileModel.sendState=2;
    if (model.fileData) {
        fileModel.fileData=model.fileData;
        NSString *basePath = MessageFileCache(model.chatID);
        NSString *detailPath = [basePath stringByAppendingPathComponent:fileModel.fileCacheName];
        [DZFileManager saveFile:detailPath withData:model.fileData];
    }
    return fileModel;
}
+(ChatModel*)initFileWithChatModel:(ChatModel*)model{
    if (![model.fileData isKindOfClass:[NSData class]]) {
        [QMUITipsTool showOnlyTextWithMessage:@"notSupport0KBfiles".icanlocalized inView:nil];
        return nil;
    }
    ChatModel *fileModel =  [self creatChatMessageModelWithConfig:model];
    fileModel.messageType = FileMessageType;
    fileModel.showFileName = model.showFileName;
    fileModel.fileCacheName=[NSString stringWithFormat:@"%@.%@",[NSString getCFUUID],model.showFileName.pathExtension];
    fileModel.uploadState=2;
    fileModel.fileData=model.fileData;
    fileModel.totalUnitCount=model.fileData.length;
    fileModel.sendState=2;
    NSString *basePath = MessageFileCache(model.chatID);
    NSString *detailPath = [basePath stringByAppendingPathComponent:fileModel.fileCacheName];
    [DZFileManager saveFile:detailPath withData:model.fileData];
    return fileModel;
}

//初始化定位消息
+(ChatModel*)initLocationWithChatModel:(ChatModel*)config{
    ChatModel *transModel =  [self creatChatMessageModelWithConfig:config];
    transModel.messageType =LocationMessageType;
    return transModel;
    
}
+(ChatModel*)initClickOpenScreenNoticeWithModel:(ChatModel*)configModel  isOpen:(BOOL)isOpen{
    ChatModel*chatModel=[self creatChatMessageModelWithConfig:configModel];
    chatModel.messageType=Notice_ScreencastType;
    NoticeScreencastInfo*info=[[NoticeScreencastInfo alloc]init];
    info.operatore=[UserInfoManager sharedManager].userId;
    info.screencastMode=isOpen?Notice_ScreencastTypeOPEN:Notice_ScreencastTypeCLOSE;
    chatModel.messageContent=[info mj_JSONString];
    if (BaseSettingManager.isChinaLanguages) {
        chatModel.showMessage=isOpen?[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"You",你),NSLocalizedString(@"Turn on screenshot notifications", 开启了截屏通知)] : [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"You",你),NSLocalizedString(@"Turned off screenshot notifications", 你关闭了截屏通知) ];
    }else{
        chatModel.showMessage=isOpen?[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You",你),NSLocalizedString(@"Turn on screenshot notifications", 开启了截屏通知)] : [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You",你),NSLocalizedString(@"Turned off screenshot notifications", 你关闭了截屏通知) ];
    }
    
    ChatSetting*setting=[[WCDBManager sharedManager]fetchChatSettingWith:configModel];
    chatModel.destoryTime=setting.destoryTime?:@"0";
    return chatModel;
}
+(ChatModel*)creatDestroyTimeMessageModelWithConfig:(ChatModel*)configModel  destoryTime:(int)destoryTime{
    ChatModel * chatModel=[ChatUtil creatChatMessageModelWithConfig:configModel];
    chatModel.messageType=Notice_DestroyTimeType;
    NoticeDestroyTimeInfo*timeInfo=[[NoticeDestroyTimeInfo alloc]init];
    timeInfo.operatore=[UserInfoManager sharedManager].userId;
    timeInfo.destroyTime=@(destoryTime);
    chatModel.messageContent=[timeInfo mj_JSONString];
    chatModel.destoryTime=[NSString stringWithFormat:@"%d",destoryTime];
    NSString * contenStr=nil;
    if (destoryTime ==0) {
        contenStr=@"DisabledBurnAfterReadin".icanlocalized;
    }else if (destoryTime ==35){
        contenStr= @"turn on burn after reading (burn immediately)".icanlocalized;
    }else if (destoryTime ==1800){//30分钟
        contenStr= @"set burn after reading to 30 minutes".icanlocalized;
    }else if (destoryTime ==7200){//120分钟
        contenStr= @"set burn after reading to 120 minutes".icanlocalized;
    }else if (destoryTime ==28800){//8小时
        contenStr= @"set burn after reading to 8 hours".icanlocalized;
   }  else if (destoryTime ==86400){//24小时
       contenStr= @"set burn after reading to 24 hours".icanlocalized;
    }else if (destoryTime ==604800){//7天
        contenStr= @"set burn after reading to 7 days".icanlocalized;
    }else if (destoryTime ==1296000){//15天
        contenStr= @"set burn after reading to 15 days".icanlocalized;
   }else if (destoryTime ==2592000){//30天
       contenStr= @"set burn after reading to 30 days".icanlocalized;
    }else if (destoryTime ==7776000){//90天
        contenStr= @"set burn after reading to 90 days".icanlocalized;
   }
    chatModel.showMessage = [NSString stringWithFormat:@"%@%@",@"You".icanlocalized,contenStr];
    return chatModel;
}
+(ChatModel*)creatTranspondVideoModelWithConfig:(ChatModel*)configModel  transpondModel:(ChatModel*)transpondModel{
    ChatModel*sendModel=[self creatChatMessageModelWithConfig:configModel];
    sendModel.messageType = VideoMessageType;
    sendModel.fileCacheName = transpondModel.fileCacheName;
    sendModel.uploadState=1;
    sendModel.mediaSeconds=transpondModel.mediaSeconds;
    sendModel.messageContent=transpondModel.messageContent;
    sendModel.fileServiceUrl=transpondModel.fileServiceUrl;
    NSString *basePath = MessageVideoCache(transpondModel.chatID);
    //要转发的视频第一帧缓存路径
    NSString *transponrdFirstImagePath = [basePath stringByAppendingPathComponent:[transpondModel.fileCacheName componentsSeparatedByString:@"."].firstObject];
    NSString *cachePath = MessageVideoCache(configModel.chatID);
    NSString *sendFirstIImageCachecachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[transpondModel.fileCacheName componentsSeparatedByString:@"."].firstObject]];
    if (![DZFileManager fileIsExistOfPath:transponrdFirstImagePath]) {
        //保存需要转发的视频第一帧图片在对应的缓存目录下面
        NSData*transpondImageData=[NSData dataWithContentsOfFile:transponrdFirstImagePath];
        [DZFileManager saveFile:sendFirstIImageCachecachePath withData:transpondImageData];
        
    }else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        VideoMessageInfo*info=[VideoMessageInfo mj_objectWithKeyValues:transpondModel.messageContent];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:info.content]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        NSData*imageData = [cache diskImageDataForKey:key];
        [DZFileManager saveFile:sendFirstIImageCachecachePath withData:imageData];
    }
    NSString *transponrdVideoPath = [basePath stringByAppendingPathComponent:transpondModel.fileCacheName];
    NSString *sendVideoCachecachePath = [cachePath stringByAppendingPathComponent:transpondModel.fileCacheName];
    //如果本地存在该视频 那么点击的时候可以直接拿本地的视频播放就可以了 不必再下载
    if ([DZFileManager fileIsExistOfPath:transponrdVideoPath]) {
        NSData*transpondImageData=[NSData dataWithContentsOfFile:transponrdVideoPath];
        [DZFileManager saveFile:sendVideoCachecachePath withData:transpondImageData];
    }
    return sendModel;
}
+(ChatModel*)creatTranspondImageModelWithConfig:(ChatModel*)configModel transpondModel:(ChatModel*)transpondModel{
    ChatModel*sendModel=[self creatChatMessageModelWithConfig:configModel];
    sendModel.messageType = ImageMessageType;
    sendModel.fileCacheName = transpondModel.fileCacheName;
    sendModel.uploadState=1;
    sendModel.messageContent=transpondModel.messageContent;
    NSString *basePath = MessageImageCache(transpondModel.chatID);
    //原图缓存路径
    NSString *detailPath = [basePath stringByAppendingPathComponent:transpondModel.fileCacheName];
    NSString *cachePath = MessageImageCache(configModel.chatID);
    //小图缓存路径
    NSString *cacheSmallDetailPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",transpondModel.fileCacheName]];
    //原图缓存路径
    NSString *cacheDetailPath = [cachePath stringByAppendingPathComponent:transpondModel.fileCacheName];
    if (transpondModel.isOutGoing) {
        NSData*transpondImageData=[NSData dataWithContentsOfFile:detailPath];
        [DZFileManager saveFile:cacheSmallDetailPath withData:transpondImageData];
        [DZFileManager saveFile:cacheDetailPath withData:transpondImageData];
        
    }else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        ImageMessageInfo*info=[ImageMessageInfo mj_objectWithKeyValues:transpondModel.messageContent];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:info.thumbnails]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        NSData*imageData = [cache diskImageDataForKey:key];
        [DZFileManager saveFile:cacheSmallDetailPath withData:imageData];
        [DZFileManager saveFile:cacheDetailPath withData:imageData];
        
    }
    return sendModel;
}
+(ChatModel*)creatAtAllMessageInfoWithConfig:(ChatModel*)config announce:(NSString*)announce{
    ChatModel * chatModel = [self creatChatMessageModelWithConfig:config];
    chatModel.messageType=AtAllMessageType;
    AtAllMessageInfo*info=[[AtAllMessageInfo alloc]init];
    chatModel.showMessage=[NSString stringWithFormat:@"@%@\n%@",NSLocalizedString(@"All the people", 所有人),announce];
    info.content=chatModel.showMessage;
    chatModel.messageContent=[info mj_JSONString];
    chatModel.authorityType=AuthorityType_friend;
    return chatModel;
}
+(ChatModel *)creatAtSingleMessageInfoWithChatId:(NSString *)chatId text:(NSString *)text atIds:(NSArray*)atIds{
    ChatModel * chatModel = [self creatChatMessageModelWithChatId:chatId chatType:GroupChat authorityType:AuthorityType_friend circleUserId:nil];
    chatModel.messageType=AtSingleMessageType;
    AtSingleMessageInfo*info=[[AtSingleMessageInfo alloc]init];
    info.content=text;
    info.atIds=atIds;
    chatModel.showMessage=text;
    chatModel.messageContent=[info mj_JSONString];
    chatModel.authorityType=AuthorityType_friend;
    return chatModel;
}
+(ChatModel*)creatAddGroupMessageInfoWithChatId:(NSString*)chatId text:(NSString*)text{
    ChatModel * chatModel = [self creatChatMessageModelWithChatId:chatId chatType:GroupChat authorityType:AuthorityType_friend circleUserId:nil];
    chatModel.messageType=Notice_AddGroupMessageType;
    chatModel.sendState  = 1;
    chatModel.showMessage=text;
    chatModel.authorityType=AuthorityType_friend;
    return chatModel;
    
}

+(ChatModel*)creatTransferMessageInfoWithChatModel:(ChatModel*)config{
    ChatModel * chatModel = [self creatChatMessageModelWithConfig:config];
    chatModel.sendState=2;
    chatModel.messageType=TransFerMessageType;
    return chatModel;
}
+(ChatModel*)creatSingleRedPacketMessageInfoWithConfig:(ChatModel*)configModel messId:(NSString*)messageId{
    ChatModel * chatModel = [self creatChatMessageModelWithConfig:configModel];
    chatModel.messageType=SendSingleRedPacketType;
    chatModel.sendState  = 1;
    return chatModel;
}
+ (ChatModel *)creatMultipleRedPacketMessageInfoWithChatId:(NSString *)chatId messId:(NSString *)messageId{
    ChatModel * chatModel = [self creatChatMessageModelWithChatId:chatId chatType:GroupChat authorityType:AuthorityType_friend circleUserId:nil];
    chatModel.messageType=SendRoomRedPacketType;
    chatModel.sendState  = 1;
    return chatModel;
}
+(ChatModel*)creatGrabSuccessRedPacketWithConfig:(ChatModel*)configModel showMessage:(NSString*)showMessage messageType:(NSString*)messageType{
    ChatModel * chatModel = [self creatChatMessageModelWithConfig:configModel];
    chatModel.messageType=messageType;
    chatModel.showMessage=showMessage;
    chatModel.sendState  = 1;
    return chatModel;
}

@end

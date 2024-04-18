//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 25/8/2020
 - File name:  ChatViewHandleTool.m
 - Description:
 - Function List:
 */


#import "ChatViewHandleTool.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "RedPacketReceiveDetailViewController.h"
#import "FriendDetailViewController.h"
#import "ChatRightFileTableViewCell.h"
#import "DZUIDocument.h"
#import "ChatUtil.h"
#import "OSSWrapper.h"
#import "ShowOpenRedPacketView.h"
#import "VoicePlayerTool.h"
#import "SendVipRedPacketViewController.h"
#import "SendSingleRedTableViewController.h"
#import "SendMultipleRedPacketViewController.h"
#import "ShowReplyTextViewController.h"
#import "ShowAppleMapLocationViewController.h"
#import "TimelinesDetailViewController.h"
#import "YBImageBrowerTool.h"
#import "UIView+Nib.h"
#import "DZAVPlayerViewController.h"
@interface ChatViewHandleTool ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate,UITableViewDelegate>
/**预览文件*/
@property (nonatomic, strong) UIDocumentInteractionController *docVc;
/** 显示文件的界面载体 */
@property(nonatomic, weak) UIViewController *showFileContainerViewController;


@property(nonatomic, strong) ShowOpenRedPacketView *redPacketView;
@property(nonatomic, strong) ChatModel *currentTapChatModel;
@property(nonatomic, strong) ChatModel *currentPlayVideoModel;

@end
@implementation ChatViewHandleTool
+ (instancetype)shareManager{
    static ChatViewHandleTool*tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[ChatViewHandleTool alloc]init];
    });
    return tool;
}
//点击播放视频
-(void)chatViewHandleToolDownloadVideoWithChatModel:(ChatModel *)chatmodel downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure{
    self.currentPlayVideoModel=chatmodel;
    if (chatmodel.localIdentifier) {
        PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[chatmodel.localIdentifier] options:nil];
        if (result.firstObject) {
            [self showDzPlayerViewWithUrl:chatmodel.videoAlbumUrl chatModel:chatmodel];
        }else{
            [self handleVideoMesageWith:chatmodel downloadProgress:downloadProgressBar success:success failure:failure];
        }
    }else{
        [self handleVideoMesageWith:chatmodel downloadProgress:downloadProgressBar success:success failure:failure];
        
    }
}
-(void)handleVideoMesageWith:(ChatModel*)model downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure{
    NSString* playUrl= [MessageVideoCache(model.chatID)stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.fileCacheName]];
    if ([DZFileManager fileIsExistOfPath:playUrl]){
        [self showDzPlayerViewWithUrl:playUrl chatModel:model];
    }else{
        //如果正在下载 那么点击无效
        if (model.downloadState!=2) {
            //下载立即把downloadState赋值为2 表示正在下载
            model.downloadState=2;
            @weakify(self);
            [[NetworkRequestManager shareManager]downloadVideoWithChatModel:model downloadProgress:^(ChatModel *model) {
                downloadProgressBar(model);
            } success:^(ChatModel *model) {
                @strongify(self);
                [[WCDBManager sharedManager]insertChatModel:model];
                success(model);
                [self showDzPlayerViewWithUrl:playUrl chatModel:model];
            } failure:^(NSError *error) {
                failure(error);
            }];
        }
        
    }
}
-(void)showDzPlayerViewWithUrl:(NSString*)playUrl chatModel:(ChatModel*)model{
    if (playUrl) {
        
        DZAVPlayerViewController * vc = [[DZAVPlayerViewController alloc]init];
        [vc setPlayUrl:[NSURL fileURLWithPath:playUrl] aVPlayerViewType:AVPlayerViewNormal];
        [[AppDelegate shared]pushViewController:vc animated:NO];
        @weakify(self);
        vc.transpondBlock = ^{
            @strongify(self);
            if (self.delegete&&[self.delegete respondsToSelector:@selector(chatViewHandleToolTranspondChatModel:)]) {
                [self.delegete chatViewHandleToolTranspondChatModel:model];
            }
        };
    }
    
}
+(void)colletcMoreMessageWithItems:(NSArray*)messageItems{
    NSMutableArray*array=[NSMutableArray array];
    for (ChatModel*collectionModel in messageItems) {
        CollectionRequest * request = [CollectionRequest request];
        request.originUserId =collectionModel.messageFrom;
        NSString*messageType=collectionModel.messageType;
        if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:GamifyMessageType]) {
            //文本
            request.favoriteType = @"Txt";
            TextMessageInfo * messageInfo = [TextMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            request.content =messageInfo.content;
            
        }else if ([messageType isEqualToString:VoiceMessageType]){
            //语音 fileServiceUrl
            request.favoriteType = @"Voice";
            request.voiceUrl = collectionModel.fileServiceUrl;
            
        }else if ([messageType isEqualToString:ImageMessageType]){
            //图片
            request.favoriteType = @"Image";
            ImageMessageInfo * messageInfo = [ImageMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            request.imageUrl = messageInfo.imageUrl;
        }else if ([messageType isEqualToString:LocationMessageType]){
            //地位
            request.favoriteType = @"POI";
            LocationMessageInfo *messageInfo = [LocationMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            
            PoiInfo * poi = [PoiInfo new];
            poi.latitude = [NSString stringWithFormat:@"%f",messageInfo.latitude];
            poi.longitude = [NSString stringWithFormat:@"%f",messageInfo.longitude];
            poi.name = messageInfo.name;
            poi.address = messageInfo.address;
            request.poi= poi;
            
        }else if ([messageType isEqualToString:UserCardMessageType]){
            //名片
            request.favoriteType = @"UserCard";
            UserCardMessageInfo * messageInfo = [UserCardMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            request.userCardId = messageInfo.userId;
            
            
        }else if ([messageType isEqualToString:VideoMessageType]){
            //视频
            request.favoriteType = @"Video";
            VideoMessageInfo * messageInfo = [VideoMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            request.videoUrl = messageInfo.sightUrl;
            request.imageUrl = messageInfo.content;
        }else if ([messageType isEqualToString:FileMessageType]){
            //文件
            request.favoriteType = @"File";
            request.fileUrl = collectionModel.fileServiceUrl;
        }else if ([messageType isEqualToString:kChat_PostShare]){
            ChatPostShareMessageInfo*info=[ChatPostShareMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
            request.favoriteType =@"TimeLine";
            request.busId = [NSString stringWithFormat:@"%zd",info.postId];
            request.originUserId = [NSString stringWithFormat:@"%zd",info.userId];;
        }
        if ([messageType isEqualToString:kChat_PostShare]||[messageType isEqualToString:TextMessageType]|[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:GamifyMessageType]||[messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:ImageMessageType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:UserCardMessageType]||[messageType isEqualToString:VideoMessageType]||[messageType isEqualToString:FileMessageType]) {
            [array addObject: [request mj_JSONObject]];
        }
        
    }
    CollectionMoreRequest*request=[CollectionMoreRequest request];
    request.parameters=[array mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Added".icanlocalized inView:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
+(void)collectMessageWithChatModel:(ChatModel*)collectionModel{
    CollectionRequest * request = [CollectionRequest request];
    request.originUserId =collectionModel.messageFrom;
    request.messageId=collectionModel.messageID;
    NSString*messageType=collectionModel.messageType;
    if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:GamifyMessageType]) {
        //文本
        request.favoriteType = @"Txt";
        TextMessageInfo * messageInfo = [TextMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        request.content =messageInfo.content;
        
    }else if ([messageType isEqualToString:VoiceMessageType]){
        //语音 fileServiceUrl
        request.favoriteType = @"Voice";
        request.voiceUrl = collectionModel.fileServiceUrl;
        
    }else if ([messageType isEqualToString:ImageMessageType]){
        //图片
        request.favoriteType = @"Image";
        ImageMessageInfo * messageInfo = [ImageMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        request.imageUrl = messageInfo.imageUrl;
    }else if ([messageType isEqualToString:LocationMessageType]){
        //地位
        request.favoriteType = @"POI";
        LocationMessageInfo *messageInfo = [LocationMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        
        PoiInfo * poi = [PoiInfo new];
        poi.latitude = [NSString stringWithFormat:@"%f",messageInfo.latitude];
        poi.longitude = [NSString stringWithFormat:@"%f",messageInfo.longitude];
        poi.name = messageInfo.name;
        poi.address = messageInfo.address;
        request.poi= poi;
        
    }else if ([messageType isEqualToString:UserCardMessageType]){
        //名片
        request.favoriteType = @"UserCard";
        UserCardMessageInfo * messageInfo = [UserCardMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        request.userCardId = messageInfo.userId;
        
        
    }else if ([messageType isEqualToString:VideoMessageType]){
        //视频
        request.favoriteType = @"Video";
        VideoMessageInfo * messageInfo = [VideoMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        request.videoUrl = messageInfo.sightUrl;
        request.imageUrl = messageInfo.content;
    }else if ([messageType isEqualToString:FileMessageType]){
        //文件
        request.favoriteType = @"File";
        request.fileUrl = collectionModel.fileServiceUrl;
        request.content=collectionModel.showFileName;
        
    }else if ([messageType isEqualToString:kChat_PostShare]){
        ChatPostShareMessageInfo*info=[ChatPostShareMessageInfo mj_objectWithKeyValues:collectionModel.messageContent];
        request.favoriteType =@"TimeLine";
        request.busId = [NSString stringWithFormat:@"%zd",info.postId];
        request.originUserId = [NSString stringWithFormat:@"%zd",info.userId];;
        request.parameters = [request mj_JSONString];
    }
    if ([messageType isEqualToString:kChat_PostShare]||[messageType isEqualToString:TextMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:GamifyMessageType]||[messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:ImageMessageType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:UserCardMessageType]||[messageType isEqualToString:VideoMessageType]||[messageType isEqualToString:FileMessageType]) {
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            [QMUITipsTool showOnlyTextWithMessage:@"Added".icanlocalized inView:nil];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
    
}
#pragma mark - 显示文件
-(void)chatViewHandleShowFileWithChatModel:(ChatModel*)chatModel container:(UIViewController*)container downloadProgress:(void (^)(ChatModel *))downloadProgressBar success:(void (^)(ChatModel *))success failure:(void (^)(NSError *))failure{
    self.showFileContainerViewController=container;
    NSData*data=[NSData dataWithContentsOfFile:[MessageFileCache(chatModel.chatID) stringByAppendingPathComponent:chatModel.fileCacheName]];
    if (data) {
        self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[MessageFileCache(chatModel.chatID) stringByAppendingPathComponent:chatModel.fileCacheName]]];
        self.docVc.delegate = self;
        self.docVc.name=chatModel.showFileName;
        [self.docVc presentPreviewAnimated:YES];
    }else{
        @weakify(self);
        [[NetworkRequestManager shareManager]downloadFileWithChatModel:chatModel downloadProgress:^(ChatModel *chatModel) {
            downloadProgressBar(chatModel);
        } success:^(ChatModel *chatModel) {
            @strongify(self);
            success(chatModel);
            [[WCDBManager sharedManager]insertChatModel:chatModel];
            self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[MessageFileCache(chatModel.chatID) stringByAppendingPathComponent:chatModel.fileCacheName]]];
            self.docVc.delegate = self;
            self.docVc.name=chatModel.showFileName;
            [self.docVc presentPreviewAnimated:YES];
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

#pragma mark -- UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self.showFileContainerViewController;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller{
    return self.showFileContainerViewController.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.showFileContainerViewController.view.frame;
}
#pragma mark - 点击显示回复的文件
-(void)showReplyFileWithContent:(ReplyMessageInfo*)replyMessageInfo container:(UIViewController*)container{
    self.showFileContainerViewController=container;
    FileMessageInfo*info=[FileMessageInfo mj_objectWithKeyValues:replyMessageInfo.jsonMessage];
    NSString* fileCacheName=[NSString stringWithFormat:@"%@.%@",[info.fileUrl MD5String],info.fileUrl.pathExtension];
    NSString*cacheId=replyMessageInfo.groupId?:replyMessageInfo.userId;
    NSString *downloadFilePath = [MessageFileCache(cacheId) stringByAppendingPathComponent:fileCacheName];
    if ([DZFileManager fileIsExistOfPath:downloadFilePath]) {
        self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:downloadFilePath]];
        self.docVc.delegate = self;
        self.docVc.name=info.name;
        [self.docVc presentPreviewAnimated:YES];
    }else{
        @weakify(self);
        [[NetworkRequestManager shareManager]downloadReplyFileWithReplayMessageInfo:replyMessageInfo downloadProgress:^(NSString *) {
            
        } success:^(ReplyMessageInfo *) {
            @strongify(self);
            self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:downloadFilePath]];
            self.docVc.delegate = self;
            self.docVc.name=info.name;
            [self.docVc presentPreviewAnimated:YES];
        } failure:^(NSError *) {
            
        }];
    }
}
#pragma mark - 发送文件
-(void)chatViewHandleUploadFile{
    /*
     1:跳转选择文件的View
     2:把array和tableView 以及当前View传递进去
     */
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc]initWithDocumentTypes:documentTypes  inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    documentPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AppDelegate shared] presentViewController:documentPickerViewController animated:YES completion:nil];
}
//获取icould文件的 UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    DZUIDocument*document=[[DZUIDocument alloc]initWithFileURL:url];
    @weakify(self);
    [document openWithCompletionHandler:^(BOOL success) {//单位为Byte
        if (success) {
            @strongify(self);
            self.config.showFileName=[document.fileURL.absoluteString.lastPathComponent stringByRemovingPercentEncoding];
            self.config.fileData=document.data;
            ChatModel*model=[ChatUtil initFileWithChatModel:self.config];
            if (!model) {
                return ;
            }
            [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
            [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
            [[WCDBManager sharedManager]insertChatModel:model];
            [self.messageItems addObject:model];
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:YES];
            CheckFileHasExistRequest*request=[CheckFileHasExistRequest request];
            NSString*hashId=[NSString getHasNameData:self.config.fileData];
            request.hashId=hashId;
            request.isHttpResponse=YES;
            request.parameters=[request mj_JSONObject];
            @weakify(self);
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
                @strongify(self);
                if (response.length>0) {
                    model.fileServiceUrl=response;
                    model.uploadProgress=@"100%";
                    model.uploadState=1;
                    model.sendState=2;
                    [self sendFileMessageWithChatModel:model];
                }else{
                    [self uploadFileWithChatModel:model hashId:hashId];
                }
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                @strongify(self);
                [self uploadFileWithChatModel:model hashId:hashId];
            }];
            
        }
    }];
}
-(void)uploadFileWithChatModel:(ChatModel*)chatModel hashId:(NSString*)hashId{
    OSSWrapper*wrapper= [[OSSWrapper alloc] init];
    @weakify(self);
    [wrapper uploadFileWithChatModel:chatModel uploadProgress:^(ChatModel * _Nonnull chatModel) {
        @strongify(self);
        NSInteger index=[self.messageItems indexOfObject:chatModel];
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        ChatRightFileTableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
        cell.fileModel=chatModel;
    } success:^(ChatModel * _Nonnull chatModel) {
        @strongify(self);
        [self sendFileMessageWithChatModel:chatModel];
        [self ossAddHashWihtHash:hashId url:chatModel.fileServiceUrl name:chatModel.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(chatModel.fileData.length/1024)] path:chatModel.thumbnails];
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        
    }];
}
-(void)sendFileMessageWithChatModel:(ChatModel*)chatModel{
    FileMessageInfo*info=[[FileMessageInfo alloc]init];
    info.name=chatModel.showFileName;
    info.fileUrl=chatModel.fileServiceUrl;
    info.type=chatModel.showFileName.pathExtension;
    info.size=chatModel.fileData.length;
    chatModel.messageContent=[info mj_JSONString];
    [[WCDBManager sharedManager]insertChatModel:chatModel];
    [self sendMediaMessageWihtChatModel:chatModel];
    [self scrollTableViewToBottom:YES needScroll:YES];
}
/// 发送消息 主要是发送媒体类型的消息(由于媒体类型的消息都是先保存在数据库 再上传发送)
/// @param chatModel 消息model
-(void)sendMediaMessageWihtChatModel:(ChatModel*)chatModel{
    [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
    [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        self.isScrollViewScroll=YES;
    }else{
        self.isScrollViewScroll=NO;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isScrollViewScroll=NO;
}
- (void)scrollTableViewToBottom:(BOOL)animated needScroll:(BOOL)needScroll{
    if (!needScroll) {
        NSIndexPath*index = self.tableView.indexPathsForVisibleRows.firstObject;
        BOOL shouldScroll = index.row>=20;
        if (self.isScrollViewScroll||!shouldScroll) {
            return;
        }
    }
    if (self.messageItems.count>0) {
        NSIndexPath*index=[NSIndexPath indexPathForRow:self.messageItems.count-1 inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
        });
    }
    
}



-(void)ossAddHashWihtHash:(NSString*)hash url:(NSString*)url name:(NSString*)name size:(NSString*)size path:(NSString*)path{
    OssAddFileRequest*request=[OssAddFileRequest request];
    request.hashId=hash;
    request.url=url;
    request.name=name;
    request.size=size;
    request.path=path;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}


-(void)chatViewHandleShwoSingleRedPacketWithCurrentModel:(ChatModel*)currentModel{
    self.currentTapChatModel=currentModel;
    if ([currentModel.chatType isEqualToString:GroupChat]) {
        if (currentModel.redPacketState) {
            [self getRedPackeDetailRequestWithRedId:currentModel.redId];
        }else{
            self.redPacketView.model=currentModel;
            [self.redPacketView show];
        }
    }else{
        if (currentModel.isOutGoing) {
            //自己发送的单人红包就不需要显示开的页面 //访问红包详情 跳转红包详情界面
            if (currentModel.showRedState) {
                //红包详情
                [self getRedPackeDetailRequestWithRedId:currentModel.redId];
            }else{
                if (currentModel.redPacketState) {
                    currentModel.showRedState=YES;
                    [[WCDBManager sharedManager]updateSingleRedPacketShowRedStateByRedId :currentModel.redId showRedState:YES];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.messageItems indexOfObject:currentModel] inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [self getRedPackeDetailRequestWithRedId:currentModel.redId];
            }
        }else{
            if (currentModel.redPacketState) {
                //如果红包不再是默认状态->访问红包详情-> 跳转红包详情界面
                if (![currentModel.redPacketState isEqualToString:Kexpired]) {
                    [self getRedPackeDetailRequestWithRedId:currentModel.redId];
                }else{
                    self.redPacketView.model=currentModel;
                    [self.redPacketView show];
                }
            }else{
                self.redPacketView.model=currentModel;
                [self.redPacketView show];
            }
        }
    }
    
}
-(ShowOpenRedPacketView *)redPacketView{
    if (!_redPacketView) {
        _redPacketView=[[ShowOpenRedPacketView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _redPacketView.openButtonBlock = ^{
            @strongify(self);
            [self gradRedPacketRequest:self.currentTapChatModel];
        };
        _redPacketView.cancleBlock = ^{
            @strongify(self);
            [self.redPacketView hidden];
            self.redPacketView=nil;
        };
        _redPacketView.showDetailBlock = ^(ChatModel * _Nonnull model) {
            @strongify(self);
            [self.redPacketView hidden];
            self.redPacketView=nil;
            [self getRedPackeDetailRequestWithRedId:model.redId];
        };
        
    }
    return _redPacketView;
}
/** 领取红包 */
-(void)gradRedPacketRequest:(ChatModel*)model{
    GrabRedPacketRequest*request=[GrabRedPacketRequest request];
    SingleRedPacketMessageInfo*redinfo=[SingleRedPacketMessageInfo mj_objectWithKeyValues:model.messageContent];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/redEnvelopes/grab/%@/%@",[self.config.chatType isEqualToString:GroupChat]?@"g":@"s",redinfo.ID];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[SendSingleRedPacketInfo class] contentClass:[SendSingleRedPacketInfo class ] success:^(SendSingleRedPacketInfo* response) {
        @strongify(self);
        //领取成功 跳转到红包详情 并且更新本地红包数据
        model.redPacketState=KRedPacketsuccess;
        model.showRedState=YES;
        model.redPacketAmount=response.amount;
        [[WCDBManager sharedManager]updateSingleRedPacketMessagStateByModel:model];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.messageItems indexOfObject:model] inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([model.chatType isEqualToString:GroupChat]) {
            NSMutableString*tipStr=[[NSMutableString alloc]initWithString:@"You received".icanlocalized];
            if ([model.messageFrom isEqualToString:[UserInfoManager sharedManager].userId]) {
            }else{
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
                    @strongify(self);
                    if (BaseSettingManager.isChinaLanguages) {
                        [tipStr appendString:[NSString stringWithFormat:@"%@的红包",info.remarkName?:info.nickname]];
                    }else{
                        [tipStr appendString:[NSString stringWithFormat:@"%@ %@",info.remarkName?:info.nickname,@"showReceiveRedPacketTip".icanlocalized]];
                    }
                    ChatModel*model = [ChatUtil creatGrabSuccessRedPacketWithConfig:self.config showMessage:tipStr messageType:GrabRoomRedPacketTypeType];
                    model.redId=redinfo.ID;
                    [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:NO];
                    [self.messageItems addObject:model];
                    [self.tableView reloadData];
                    [self scrollTableViewToBottom:YES needScroll:YES];
                }];
            }
        }else{
            NSMutableString*tipStr=[[NSMutableString alloc]initWithString:@"You received".icanlocalized];
            @weakify(self);
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:model.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
                @strongify(self);
                if (BaseSettingManager.isChinaLanguages) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@的红包",info.remarkName?:info.nickname]];
                }else{
                    [tipStr appendString:[NSString stringWithFormat:@"%@ %@",info.remarkName?:info.nickname,@"showReceiveRedPacketTip".icanlocalized]];
                }
                ChatModel*model = [ChatUtil creatGrabSuccessRedPacketWithConfig:self.config showMessage:tipStr messageType:GrabSingleRedPacketType];
                model.redId=redinfo.ID;
                [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:NO];
                [self.messageItems addObject:model];
                [self.tableView reloadData];
                [self scrollTableViewToBottom:YES needScroll:YES];
            }];
        }
        [self.redPacketView hidden];
        self.redPacketView=nil;
        [self getRedPackeDetailRequestWithRedId:response.ID];
        [[VoicePlayerTool sharedManager]playerReceiveGrabRedPackey];
        [QMUITips hideAllTips];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        //领取成功 跳转到红包详情 并且更新本地红包数据
        model.redPacketState=info.code;
        model.showRedState=YES;
        [[WCDBManager sharedManager]updateSingleRedPacketMessagStateByModel:model];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.messageItems indexOfObject:model] inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if ([info.code isEqualToString:Kreceived]) {//已经领过该红包
            [self.redPacketView redHasReceived];
        }else if ([info.code isEqualToString:Kexpired]){
            [self.redPacketView redEnvelopeOverTime:model];
        }else if ([info.code isEqualToString:KEmpty]){
            [self.redPacketView noEnvelope];
        }else{
            [self.redPacketView hidden];
            self.redPacketView=nil;
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
            [self.redPacketView otherError];
        }
    }];
}
-(void)getRedPackeDetailRequestWithRedId:(NSString*)redId{
    RedPacketDetailRequest*request=[RedPacketDetailRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/redEnvelopes/%@/%@",[self.config.chatType isEqualToString:GroupChat]?@"g":@"s",redId];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RedPacketDetailInfo class] contentClass:[RedPacketDetailInfo class] success:^(RedPacketDetailInfo* response) {
        @strongify(self);
        [QMUITips hideAllTips];
        if ([self.config.chatType isEqualToString:UserChat]) {//由于点击自己发送的单人红包的时候不需要显示开红包界面 所以在此需要判断一下开红包界面
            if (response.rejectTime&&self.currentTapChatModel.isOutGoing) {
                if (!self.currentTapChatModel.redPacketState) {
                    self.currentTapChatModel.redPacketState=KRedPacketExpired;
                    self.currentTapChatModel.showRedState=YES;
                    [[WCDBManager sharedManager]updateSingleRedPacketMessagStateByModel:self.currentTapChatModel];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.messageItems indexOfObject:self.currentTapChatModel] inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        RedPacketReceiveDetailViewController*vc=[[RedPacketReceiveDetailViewController alloc]init];
        vc.redPacketDetailInfo=response;
        [[AppDelegate shared] pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
//点击头像
-(void)tapOtherIconWithChatModel:(ChatModel *)model groupDetailInfo:(GroupListInfo *)groupDetailInfo chatModel:(ChatModel*)config{
    if([model.chatMode isEqualToString:ChatModeOtherChat]){
        NSLog(@"ChatModeOtherChat");
    }else{
        self.config = config;
        FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
        NSString *userId=model.isOutGoing?[UserInfoManager sharedManager].userId: model.messageFrom;
        vc.userId = userId;
        if ([self.config.chatType isEqualToString:GroupChat]) {
            vc.friendDetailType = FriendDetailType_pushChatViewNotification;
        }else{
            vc.friendDetailType = FriendDetailType_popChatView;
        }
        if ([self.config.chatType isEqualToString:UserChat]) {
            [[AppDelegate shared] pushViewController:vc animated:YES];
        }else{
            if (groupDetailInfo.isInGroup) {
                //Ordinary member If the identity of the user in the group is an ordinary member, then determine whether the user
                if ([groupDetailInfo.role isEqualToString:@"2"]) {
                    if (groupDetailInfo.showUserInfo) {
                        [[AppDelegate shared] pushViewController:vc animated:YES];
                    }else{
                        ////If the display of group membership is not enabled, then judge if the person clicked is the group owner or administrator and jump directly
                        [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:model.chatID userId:userId successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                            if ([memberInfo.role isEqualToString:@"0"]||[memberInfo.role isEqualToString:@"1"]) {
                                [[AppDelegate shared] pushViewController:vc animated:YES];
                            }
                        }];
                    }
                }else{
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                }
            }
        }
    }
}

-(void)handleWebSocketDidReceiptMessageWithBaseMessageInfo:(BaseMessageInfo*)baseMessageInfo{
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"messageID CONTAINS[c] %@ ",baseMessageInfo.messageId];
    NSArray*  searchFriend= [self.messageItems filteredArrayUsingPredicate:gpredicate];
    if (searchFriend.count>0) {
        ChatModel*model=searchFriend.firstObject;
        if ([self.config.chatType isEqualToString:GroupChat]) {
            if (baseMessageInfo.fromId) {
                model.receiptStatus=@"READ";
                NSMutableArray*userIdItems=[NSMutableArray arrayWithArray:model.hasReadUserInfoItems];
                NSDictionary*newdict=@{@"time":baseMessageInfo.sendTime,@"id":baseMessageInfo.fromId};
                BOOL isContain = NO;
                for (NSDictionary*dict in userIdItems) {
                    if ([[dict objectForKey:@"id"] isEqualToString:baseMessageInfo.fromId]) {
                        isContain=YES;
                        break;
                    }
                }
                if (!isContain) {
                    [userIdItems addObject:newdict];
                }
                model.hasReadUserInfoItems=userIdItems;
                [self.tableView reloadData];
                [self scrollTableViewToBottom:YES needScroll:NO];
                
            }
        }else{
            if (![model.receiptStatus isEqualToString:@"READ"]) {
                ReceiptMessageInfo*info=[ReceiptMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: baseMessageInfo.msgContent]];
                model.receiptStatus=info.receiptStatus;
                if ([info.receiptStatus isEqualToString:@"READ"]) {
                    NSDictionary*newdict=@{
                        @"time":baseMessageInfo.sendTime,
                        @"id":baseMessageInfo.fromId
                    };
                    model.hasReadUserInfoItems=@[newdict];
                }
                [self.tableView reloadData];
                [self scrollTableViewToBottom:YES needScroll:NO];
                
            }
            
            
        }
    }
}
-(void)pushSendHongbaoViewControllerWithGroupDetaiInfo:(GroupListInfo*)groupDetailInfo{
    if ([self.config.chatType isEqualToString:GroupChat]) {
        if ([groupDetailInfo.businessType isEqualToString:@"Vip"]) {
            SendVipRedPacketViewController*vc=[[SendVipRedPacketViewController alloc]init];
            vc.groupId=self.config.chatID;
            vc.groupListInfo=groupDetailInfo;
            @weakify(self);
            vc.sendMultipleRedPacketSuccessBlock = ^(ChatModel * _Nonnull model) {
                @strongify(self);
                [self.messageItems addObject:model];
                [self.tableView reloadData];
                [self scrollTableViewToBottom:YES needScroll:YES];
            };
            [[AppDelegate shared] pushViewController:vc animated:YES];
        }else{
            SendVipRedPacketViewController*vc=[[SendVipRedPacketViewController alloc]init];
            vc.groupId=self.config.chatID;
            vc.groupListInfo=groupDetailInfo;
            @weakify(self);
            vc.sendMultipleRedPacketSuccessBlock = ^(ChatModel * _Nonnull model) {
                @strongify(self);
                [self.messageItems addObject:model];
                [self.tableView reloadData];
                [self scrollTableViewToBottom:YES needScroll:YES];
            };
            [[AppDelegate shared] pushViewController:vc animated:YES];
        }
        
        
    }else{
        SendSingleRedTableViewController*vc=[[SendSingleRedTableViewController alloc]init];
        vc.toUserId=self.config.chatID;
        vc.authorityType=self.config.authorityType;
        vc.sendRedPacketSuccessBlock = ^(ChatModel * _Nonnull model) {
            [self.messageItems addObject:model];
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:YES];
            
        };
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }
}
-(void)clickReplyCellWithContainer:(UIViewController*)container chatModel:(ChatModel*)model{
    self.showFileContainerViewController=container;
    ReplyMessageInfo*info=[ReplyMessageInfo mj_objectWithKeyValues:[model.extra mj_JSONObject]];
    if ([info.originalMessageType isEqualToString:TextMessageType]||[info.originalMessageType isEqualToString:URLMessageType]||[info.originalMessageType isEqualToString:GamifyMessageType]||[info.originalMessageType isEqualToString:AtSingleMessageType]||[info.originalMessageType isEqualToString:AtAllMessageType]) {
        ShowReplyTextViewController*vc=[[ShowReplyTextViewController alloc]init];
        ReplyMessageInfo*info=[ReplyMessageInfo mj_objectWithKeyValues:[model.extra mj_JSONObject]];
        vc.replyMessageInfo=info;
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }else if ([info.originalMessageType isEqualToString:ImageMessageType]){
        YBImageBrowerTool*ybImageBrowerTool=[[YBImageBrowerTool alloc]init];
        [ybImageBrowerTool showReplyImageWithContent:info.jsonMessage];
    }else if ([info.originalMessageType isEqualToString:LocationMessageType]) {
        LocationMessageInfo *linfo = [LocationMessageInfo mj_objectWithKeyValues:info.jsonMessage];
        ShowAppleMapLocationViewController *locatinVC = [ShowAppleMapLocationViewController new];
        locatinVC.locationMessageInfo = linfo;
        [[AppDelegate shared] pushViewController:locatinVC animated:true];
    }else if ([info.originalMessageType isEqualToString:FileMessageType]){
        [self showReplyFileWithContent:info container:container];
    }else if ([info.originalMessageType isEqualToString:VideoMessageType]){
        VideoMessageInfo*dinfo=[VideoMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: info.jsonMessage]];
        DZAVPlayerViewController * vc = [[DZAVPlayerViewController alloc]init];
        [vc setPlayUrl:[NSURL URLWithString:dinfo.sightUrl] aVPlayerViewType:AVPlayerViewNormal];
        [[AppDelegate shared] pushViewController:vc animated:NO];
        @weakify(self);
        vc.transpondBlock = ^{
            @strongify(self);
            if (self.delegete&&[self.delegete respondsToSelector:@selector(chatViewHandleToolTranspondChatModel:)]) {
                ChatModel*cmodel=[[ChatModel alloc]init];
                cmodel.messageContent=info.jsonMessage;
                cmodel.mediaSeconds=dinfo.duration;
                cmodel.fileCacheName=dinfo.name;
                cmodel.chatID=model.chatID;
                cmodel.messageType=VideoMessageType;
                cmodel.fileServiceUrl=dinfo.sightUrl;
                [self.delegete chatViewHandleToolTranspondChatModel:cmodel];
            }
        };
        
    }else if ([info.originalMessageType isEqualToString:UserCardMessageType]){
        FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
        UserCardMessageInfo * uinfo = [UserCardMessageInfo mj_objectWithKeyValues:info.jsonMessage];
        friendDetailVC.userId = uinfo.userId;
        friendDetailVC.friendDetailType=FriendDetailType_push;
        [[AppDelegate shared] pushViewController:friendDetailVC animated:YES];
    }else if ([info.originalMessageType isEqualToString:kChat_PostShare]){
        ChatPostShareMessageInfo*cinfo=[ChatPostShareMessageInfo mj_objectWithKeyValues:info.jsonMessage];
        TimelinesDetailViewController*vc=[[TimelinesDetailViewController alloc]init];
        vc.messageId=[[NSString alloc]initWithFormat:@"%ld",cinfo.postId];;
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }else if ([info.originalMessageType isEqualToString:kChatOtherShareType]){
        ChatOtherUrlInfo*goodsInfo=[ChatOtherUrlInfo mj_objectWithKeyValues:info.jsonMessage];
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:goodsInfo.link]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:goodsInfo.link] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
}
-(void)hiddenPlayerView{
//    [self.playerView hiddenDZAVPlayerView];
//    self.playerView=nil;
}

+(NSString*)getTitleByDestroyTime:(NSString*)destroyTime{
    NSString*rightText=nil;
    
    if ([destroyTime isEqualToString:@"0"]) {
        rightText=@"Close".icanlocalized;
    }else if ([destroyTime isEqualToString:@"35"]){
        rightText=@"Burn immediately".icanlocalized;
    }else if ([destroyTime isEqualToString:@"1800"]){//30分钟
        rightText=@"30minutes".icanlocalized;
    }else if ([destroyTime isEqualToString:@"7200"]){//120分钟
        rightText=@"120minutes".icanlocalized;
    }else if ([destroyTime isEqualToString:@"28800"]){//8小时
        rightText=@"8hours".icanlocalized;
    }  else if ([destroyTime isEqualToString:@"86400"]){//24小时
        rightText=@"24hours".icanlocalized;
    }else if ([destroyTime isEqualToString:@"604800"]){//7天
        rightText=@"7days".icanlocalized;
    }else if ([destroyTime isEqualToString:@"1296000"]){//15天
        rightText=@"15days".icanlocalized;
    }else if ([destroyTime isEqualToString:@"2592000"]){//30天
        rightText=@"30days".icanlocalized;
    }else if ([destroyTime isEqualToString:@"7776000"]){//90天
        rightText=@"90days".icanlocalized;
    }
    return rightText;
}

+(NSString*)getLanguageByLanguageCode:(NSString*)languageCode{
    NSString *rightText = @"None".icanlocalized;
    if ([languageCode isEqualToString:@"en-us"]) {
        rightText = @"English".icanlocalized;
    }else if ([languageCode isEqualToString:@"tr"]){
        rightText = @"Turkish".icanlocalized;
    }else if ([languageCode isEqualToString:@"zh-cn"]){
        rightText = @"Chinese".icanlocalized;
    }else if ([languageCode isEqualToString:@"vi"]){
        rightText = @"Vietnam".icanlocalized;
    }else if ([languageCode isEqualToString:@"ta"]){
        rightText = @"Tamil".icanlocalized;
    }else if ([languageCode isEqualToString:@"km"]){
        rightText = @"Khmer".icanlocalized;
    }  else if ([languageCode isEqualToString:@"th"]){
        rightText = @"Thai".icanlocalized;
    }else if ([languageCode isEqualToString:@"si"]){
        rightText = @"Sinhala".icanlocalized;
    }else if([languageCode isEqualToString:@"None"]){
        return rightText = @"None".icanlocalized;
    }
    return rightText;
}

+(NSString*)getLanguageCodeByLanguage:(NSString*)languageCode{
    NSString *rightText = @"None";
    if ([languageCode isEqualToString:@"English".icanlocalized]) {
        rightText = @"en-us";
    }else if ([languageCode isEqualToString:@"Turkish".icanlocalized]){
        rightText = @"tr";
    }else if ([languageCode isEqualToString:@"Tamil".icanlocalized]){
        rightText = @"ta";
    }else if ([languageCode isEqualToString:@"Chinese".icanlocalized]){
        rightText = @"zh-cn";
    }else if ([languageCode isEqualToString:@"Vietnam".icanlocalized]){
        rightText = @"vi";
    }else if ([languageCode isEqualToString:@"Khmer".icanlocalized]){
        rightText = @"km";
    }  else if ([languageCode isEqualToString:@"Thai".icanlocalized]){
        rightText = @"th";
    }else if ([languageCode isEqualToString:@"Sinhala".icanlocalized]){
        rightText = @"si";
    }else if([languageCode isEqualToString:@"None".icanlocalized]){
        return rightText = @"None";
    }
    return rightText;
}

+(NSInteger)transformDestroyTitleWithTime:(NSString*)destroyTitle{
    NSInteger time=0;
    ////阅后即焚：关闭，即刻焚毁，30分钟，120分钟，8小时，24小时，7天，15天，30天，90天
    if ([destroyTitle isEqualToString:@"Close".icanlocalized]) {
        time=0;
    }else if ([destroyTitle isEqualToString:@"Burn immediately".icanlocalized]){
        time=35;
    }else if ([destroyTitle isEqualToString:@"30minutes".icanlocalized]){
        time=30*60;
    }else if ([destroyTitle isEqualToString:@"120minutes".icanlocalized]){
        time=60*60*2;
    }else if ([destroyTitle isEqualToString:@"8hours".icanlocalized]){
        time=60*60*8;
    }else if ([destroyTitle isEqualToString:@"24hours".icanlocalized]){
        time=60*60*24;
    }else if ([destroyTitle isEqualToString:@"7days".icanlocalized]){
        time=60*60*24*7;
    }else if ([destroyTitle isEqualToString:@"15days".icanlocalized]){
        time=60*60*24*15;
    }else if ([destroyTitle isEqualToString:@"30days".icanlocalized]){
        time=60*60*24*30;
    }else if ([destroyTitle isEqualToString:@"90days".icanlocalized]){
        time=60*60*24*90;
    }
    return time;
}
-(void)deleteMessageConfig:(ChatModel*)config{
    NSArray*allMessageItems=[[WCDBManager sharedManager]fetchAllMessageWihtChatModel:config];
    NSArray* needDeleteMessageIds = @[];
    for (ChatModel*model in allMessageItems) {
        needDeleteMessageIds  = [self deleteMessageByChatModelWhenViewWillDisappear:model configModel:config];
    }
    [self deleteMoreMessageRequestWithMessageIds:needDeleteMessageIds configModel:config deleteAll:NO];
    [[WCDBManager sharedManager]updateShowLastModelWithConfig:config];
}
//删除本地消息
-(void)deleteMessageFromChatModel:(ChatModel*)model config:(ChatModel*)config{
    [[WCDBManager sharedManager]deleteOneChatModelWithMessageId:model.messageID];
    NSString*locachePath;
    if ([model.messageType isEqualToString:ImageMessageType]) {
        locachePath=[MessageImageCache(config.chatID) stringByAppendingPathComponent:model.fileCacheName];
    }else if ([model.messageType isEqualToString:FileMessageType]){
        locachePath=[MessageFileCache(config.chatID) stringByAppendingPathComponent:model.fileCacheName];
    }else if ([model.messageType isEqualToString:VideoMessageType]){
        locachePath=[MessageVideoCache(config.chatID) stringByAppendingPathComponent:model.fileCacheName];
        NSString*localFirstImagePath=[MessageVideoCache(config.chatID) stringByAppendingPathComponent:[model.fileCacheName componentsSeparatedByString:@"."].firstObject];
        [[DZFileManager sharedManager]removeFileOfURL:[NSURL URLWithString:localFirstImagePath]];
    }
    [[DZFileManager sharedManager]removeFileOfURL:[NSURL URLWithString:locachePath]];
    
}
-(NSArray*)deleteMessageByChatModelWhenViewWillDisappear:(ChatModel*)model configModel:(ChatModel*)configModel{
    NSMutableArray*needDeleteMessageIds = [NSMutableArray array];
    //本地缓存的是13位的时间戳
    //如果每条消息的阅后即焚是关闭的时候
    UserConfigurationInfo * userConfigurationInfo = [BaseSettingManager sharedManager].userConfigurationInfo;
    //如果全局的消息保留时间为永久
    //消息的全局保存时间
    NSInteger deleteMessageWholeTime=[userConfigurationInfo.deleteMessageWholeTime integerValue];
    //当前时间
    NSInteger currentTime=[[NSDate date]timeIntervalSince1970];
    //消息时间
    NSInteger messagetime=[model.messageTime integerValue]/1000;
    //阅后即焚时间 为0就是关闭
    NSInteger detoryTime=[model.destoryTime integerValue];
    //用户是VIP会员 并且开启了阻止用户删除消息
    if (UserInfoManager.sharedManager.seniorValid||UserInfoManager.sharedManager.diamondValid) {
        if (UserInfoManager.sharedManager.preventDeleteMessage) {
            if (![userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                if (model.hasRead) {
                    if (currentTime-messagetime>deleteMessageWholeTime) {
                        [self deleteMessageFromChatModel:model config:configModel];
                        [needDeleteMessageIds addObject:model.messageID];
                    }
                }
            }
        }else{
            
            if ([model.destoryTime isEqualToString:@"0"]) {//阅后即焚关闭的情况下
                UserConfigurationInfo * userConfigurationInfo = [BaseSettingManager sharedManager].userConfigurationInfo;
                if (![userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                    if (model.hasRead) {
                        if (currentTime-messagetime>deleteMessageWholeTime) {
                            [self deleteMessageFromChatModel:model config:configModel];
                            [needDeleteMessageIds addObject:model.messageID];
                        }
                    }
                }
            }else if ([model.destoryTime isEqualToString:@"35"]){//如果阅后即焚是立即焚毁
                if (model.hasRead) {
                    [needDeleteMessageIds addObject:model.messageID];
                    [self deleteMessageFromChatModel:model config:configModel];
                }
                
            }else{
                if (currentTime-messagetime>detoryTime) {
                    [needDeleteMessageIds addObject:model.messageID];
                    [self deleteMessageFromChatModel:model config:configModel];
                }
            }
            
        }
    }else{
        if ([model.destoryTime isEqualToString:@"0"]) {//阅后即焚关闭的情况下
            UserConfigurationInfo * userConfigurationInfo = [BaseSettingManager sharedManager].userConfigurationInfo;
            if (![userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                if (model.hasRead) {
                    if (currentTime-messagetime>deleteMessageWholeTime) {
                        [self deleteMessageFromChatModel:model config:configModel];
                        [needDeleteMessageIds addObject:model.messageID];
                    }
                }
            }
        }else if ([model.destoryTime isEqualToString:@"35"]){//如果阅后即焚是立即焚毁
            if (model.hasRead) {
                [needDeleteMessageIds addObject:model.messageID];
                [self deleteMessageFromChatModel:model config:configModel];
            }
            
        }else{
            if (currentTime-messagetime>detoryTime) {
                [needDeleteMessageIds addObject:model.messageID];
                [self deleteMessageFromChatModel:model config:configModel];
            }
        }
    }
    return needDeleteMessageIds;
    
}
/// 删除多条或者一条消息的时候 告诉后台接口
/// @param messageId 需要删除的消息ID
/// @param deleteAll 是否在其他人设备上面删除
-(void)deleteMoreMessageRequestWithMessageIds:(NSArray*)messageId  configModel:(ChatModel*)config deleteAll:(BOOL)deleteAll{
    if (messageId.count>0) {
        UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
        if ([config.chatType isEqualToString:GroupChat]) {
            request.groupId=config.chatID;
            request.type=@"GroupPart";
        }else{
            request.userId=config.chatID;
            request.type=@"UserPart";
        }
        request.deleteAll=deleteAll;
        request.authorityType=config.authorityType;
        request.messageIds=messageId;
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
    
}

+(NSString*)getImageByCurrencyCode:(NSString*)currencyCode{
    NSString *rightText;
    if ([currencyCode isEqualToString:@"USDT"]) {
        rightText = @"USDT Transfer";
    }else if ([currencyCode isEqualToString:@"CNT"]){
        rightText = @"CNT Transfer";
    }else if ([currencyCode isEqualToString:@"TRX"]){
        rightText = @"TRX Transfer";
    }else if ([currencyCode isEqualToString:@"USDC"]){
        rightText = @"USDC Transfer";
    }else if ([currencyCode isEqualToString:@"ETH"]){
        rightText = @"ETH Transfer";
    }else{
        rightText = @"Not_Auth_User";
    }
    return rightText;
}

+(NSString*)getImageByChannelCodeWatchWallet:(NSString*)channelCode{
    NSString *rightText;
    if ([channelCode isEqualToString:@"ERC20"]) {
        rightText = @"card1";
    }else if ([channelCode isEqualToString:@"TRC20"]){
        rightText = @"card5";
    }else{
        rightText = @"card2";
    }
    return rightText;
}

@end

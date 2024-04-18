//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 4/3/2020
 - File name:  ShareExtensionChaltListViewController.m
 - Description:
 - Function List:
 */


#import "ShareExtensionChaltListViewController.h"
#import "ChatListCell.h"
#import "ChatAlbumModel.h"
#import "ChatUtil.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
#import "WCDBManager+ChatModel.h"
#import "OSSWrapper.h"
#import "SearchHeadView.h"
#import "ChatListSearchViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HWProgressView.h"
#import "ChatViewHandleTool.h"

#ifdef ICANTYPE
#define KShareExtensionName @"group.com.shouju.easypay.icanchatshare"
#endif
#ifdef ICANCNTYPE
#define KShareExtensionName @"group.com.easypay.icancn.icancnshare"
#endif

#define KShareExtensionImageKey @"shareExtensionImageKey"

@interface ShareExtensionChaltListViewController()
@property (nonatomic,strong)  NSArray *dataArray;
@property (nonatomic,strong) UIButton *cancleBtn;
@property(nonatomic, strong) SearchHeadView *chatListSearchView;
@end

@implementation ShareExtensionChaltListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select Chat".icanlocalized;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancleBtn];
    self.dataArray=[[WCDBManager sharedManager]getCanTranspondAllChatListModel];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.tableHeaderView=self.chatListSearchView;
    [self.tableView registNibWithNibName:kChatListCell];
}

#pragma mark === tableViewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatListCell];
    cell.chatListModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*****
     1:通过KShareExtensionName 创建NSUserDefaults
     2:通过KShareExtensionImageKey 获取需要分享的图片资源
     3:把图片插入到对应的会话列表中
     3.1: 如果你当前正处于和被分享的用户处于会话中，那么直接插入图片在对应的用户数据中，不需要手动上传图片,因为在聊天界面的coredata的delegate会自动上传
     3.2:
     如果和被分享用户不在同一个会话中，那么需要插入图片并且收到上传图片
     
     4:上传图片
     */
    ChatListModel *list = [self.dataArray objectAtIndex:indexPath.row];
    [self sendDataWithchatId:list.chatID chatType:list.chatType];
}

- (void)sendDataWithchatId:(NSString*)chatId chatType:(NSString*)chatType {
    NSURL *groupURL;
    
    groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:KShareExtensionName];
    //缓存的是文件的类型
    NSURL *typeURL = [groupURL URLByAppendingPathComponent:@"type.txt"];
    NSString * typeStr = [NSString stringWithContentsOfURL:typeURL encoding:NSUTF8StringEncoding error:nil];
    if([typeStr containsString:@"public.image"]) {
        BOOL gif;
        NSURL *imageUrl;
        if([typeStr.uppercaseString containsString:@"GIF"]) {
            gif = YES;
            imageUrl= [groupURL URLByAppendingPathComponent:@"image.gif"];
        }else{
            gif = NO;
            imageUrl= [groupURL URLByAppendingPathComponent:@"image.jpg"];
        }
        
        [self sendImageMessageWithData:[NSData dataWithContentsOfURL:imageUrl] chatId:chatId chatType:chatType gif:gif];
    }else if([typeStr isEqualToString:@"public.file-url"]) {
        //获取分享的文件的完整路径 主要是为了能拿到文件名
        NSURL *pathURL = [groupURL URLByAppendingPathComponent:@"path.txt"];
        NSData *pathData = [NSData dataWithContentsOfURL:pathURL];
        NSURL  *originfileUrl = [NSURL URLWithString:[[NSString alloc]initWithData:pathData encoding:NSUTF8StringEncoding]];
        //根据根据获取到的原文件路径 来拿到需要分享的文件的data路径
        NSURL *groupFileUrl = [groupURL URLByAppendingPathComponent:[originfileUrl.lastPathComponent stringByRemovingPercentEncoding]];
        //通过URL获取需要分享的文件数据
        NSData *fileData = [NSData dataWithContentsOfURL:groupFileUrl];
        [self sendFileMessageWithData:fileData chatId:chatId chatType:chatType fileName:[originfileUrl.lastPathComponent stringByRemovingPercentEncoding]];
        
    }else if([typeStr isEqualToString:@"public.url"]) {
        //分享的链接
        NSURL *pathURL = [groupURL URLByAppendingPathComponent:@"path.txt"];
        NSData *pathData = [NSData dataWithContentsOfURL:pathURL];
        NSURL  *originfileUrl = [NSURL URLWithString:[[NSString alloc]initWithData:pathData encoding:NSUTF8StringEncoding]];
        //链接的标题
        NSURL *contentURL = [groupURL URLByAppendingPathComponent:@"content.txt"];
        NSData *contentData = [NSData dataWithContentsOfURL:contentURL];
        NSString  *originContentUrl = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        if(originContentUrl) {
            [self sendTextWithChatId:chatId content:[NSString stringWithFormat:@"%@%@",originContentUrl,originfileUrl.absoluteString] chatType:chatType];
        }else{
            [self sendTextWithChatId:chatId content:[NSString stringWithFormat:@"%@",originfileUrl.absoluteString] chatType:chatType];
        }
    }else if([typeStr isEqualToString:@"public.plain-text"]) {//文本
        NSURL *contentURL = [groupURL URLByAppendingPathComponent:@"content.txt"];
        NSData *contentData = [NSData dataWithContentsOfURL:contentURL];
        NSString *originContentUrl = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        if(originContentUrl) {
            [self sendTextWithChatId:chatId content:[NSString stringWithFormat:@"%@",originContentUrl] chatType:chatType];
        }
    }else if([typeStr isEqualToString:@"public.mpeg-4"]||[typeStr isEqualToString:@"com.apple.quicktime-movie"]) {//文本
        NSURL *imageUrl = [groupURL URLByAppendingPathComponent:@"first.jpg"];
        NSURL *pathURL = [groupURL URLByAppendingPathComponent:@"path.txt"];
       
        NSData *pathData = [NSData dataWithContentsOfURL:pathURL];
        NSURL  *originfileUrl = [NSURL URLWithString:[[NSString alloc]initWithData:pathData encoding:NSUTF8StringEncoding]];
        //根据根据获取到的原文件路径 来拿到需要分享的文件的data路径
        NSURL *groupFileUrl = [groupURL URLByAppendingPathComponent:[originfileUrl.lastPathComponent stringByRemovingPercentEncoding]];
        //通过URL获取需要分享的文件数据
        NSData *fileData = [NSData dataWithContentsOfURL:groupFileUrl];
       
        NSURL *timeUrl = [groupURL URLByAppendingPathComponent:@"time.txt"];
        NSData *timeData = [NSData dataWithContentsOfURL:timeUrl];
        NSString *time = [[NSString alloc]initWithData:timeData encoding:NSUTF8StringEncoding];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        NSString*videoName = [[NSString getArc4random5:1] stringByAppendingFormat:@".mp4"];
        if(![DZFileManager fileIsExistOfPath:MessageVideoCache(chatId)]) {
            [DZFileManager creatDirectoryWithPath:MessageVideoCache(chatId)];
        }
        NSString *savePath = [MessageVideoCache([WebSocketManager sharedManager].currentChatID)stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videoName]];
        ChatModel *model = [[ChatModel alloc]init];
        model.chatID = chatId;
        model.chatType = chatType;
        model.authorityType = AuthorityType_friend;
        ChatModel*videoModel = [ChatUtil creatVideoChatModelWith:model saveUrl:[NSURL URLWithString:savePath] firstImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]]];
        //本地视频的标志
        videoModel.localIdentifier = @"eoeooeoe";
        videoModel.mediaSeconds = time.integerValue;
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:videoModel];
        [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:videoModel];
        [[WCDBManager sharedManager]insertChatModel:videoModel];
        [DZFileManager saveFile:savePath withData:fileData];
        [self sendPhotoAlbumVideoWithChatModel:videoModel fileServiceUrl:nil originalHash:nil exit:NO];
    }
}

- (void)sendTextWithChatId:(NSString*)chatId content:(NSString*)content chatType:(NSString*)chatType {
    ChatModel *config = [[ChatModel alloc]init];
    config.chatID = chatId;
    config.chatType = chatType;
    config.authorityType = AuthorityType_friend;
    ChatModel *model = [ChatUtil initTextMessage:content config:config];
    [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
    [self cancleAction];
    if ([WebSocketManager.sharedManager.currentChatID containsString:chatId]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kShareExtensionNotification object:model];
    }
    [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
}

- (void)sendFileMessageWithData:(NSData*)fileData chatId:(NSString*)chatId chatType:(NSString*)chatType fileName:(NSString*)fileName {
    ChatModel *config = [[ChatModel alloc]init];
    config.showFileName = fileName;
    config.fileData = fileData;
    config.chatID = chatId;
    config.chatType = chatType;
    config.authorityType = AuthorityType_friend;
    ChatModel*model = [ChatUtil initFileWithChatModel:config];
    if (!model) {
        return ;
    }
    NSString*jsonString = [[WebSocketManager sharedManager]createSendMessageWithChatModel:model];
    model.message = jsonString;
    [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
    [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
    [[WCDBManager sharedManager]insertChatModel:model];
    
    OSSWrapper*wrapper = [[OSSWrapper alloc] init];
    [QMUITipsTool showLoadingWihtMessage:@"Sending".icanlocalized inView:self.view isAutoHidden:NO];
    [wrapper uploadFileWithChatModel:model uploadProgress:^(ChatModel * _Nonnull chatModel) {
        
    } success:^(ChatModel *_Nonnull chatModel) {
        FileMessageInfo *info = [[FileMessageInfo alloc]init];
        info.name = model.showFileName;
        info.fileUrl = model.fileServiceUrl;
        info.type = model.showFileName.pathExtension;
        info.size = model.fileData.length;
        chatModel.messageContent=[info mj_JSONString];
        [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
        [self cancleAction];
        if ([WebSocketManager.sharedManager.currentChatID containsString:chatId]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kShareExtensionNotification object:chatModel];
        }
        [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        [QMUITipsTool showSuccessWithMessage:@"FailedToSend".icanlocalized inView:nil];
    }];
}

- (void)sendImageMessageWithData:(NSData*)imageData chatId:(NSString*)chatId chatType:(NSString*)chatType gif:(BOOL)gif {
    if (imageData) {
        if (gif) {
            [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
            UIImage *image = [UIImage imageWithData:imageData];
            ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
            imageModel.isOrignal = YES;
            imageModel.picSize = image.size;
            imageModel.name = [NSString getArc4random5:0];
            imageModel.isGif = YES;
            imageModel.orignalImageData = imageData;
            ChatModel *config = [[ChatModel alloc]init];
            config.chatID = chatId;
            config.chatType = chatType;
            config.authorityType = AuthorityType_friend;
            NSArray *needUploadImageItems = [ChatUtil initPicMessage:@[imageModel] config:config isGif:YES];
            for (ChatModel *model in needUploadImageItems) {
                NSString*jsonString = [[WebSocketManager sharedManager]createSendMessageWithChatModel:model];
                model.message = jsonString;
                [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
                [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
            }
            [[WCDBManager sharedManager]insertChatModels:needUploadImageItems];
            OSSWrapper *wrapper = [[OSSWrapper alloc] init];
            [wrapper uploadImageWithImages:needUploadImageItems  uploadProgress:^(NSString *_Nonnull progress, ChatModel *_Nonnull chatModel) {
                
            } success:^(ChatModel * _Nonnull chatModel) {
                [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
                [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
                [self cancleAction];
                if ([WebSocketManager.sharedManager.currentChatID containsString:chatId]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kShareExtensionNotification object:chatModel];
                }
                [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
            } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                [QMUITipsTool showSuccessWithMessage:@"FailedToSend".icanlocalized inView:nil];
            }];
        }else{
            [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
            UIImage*image = [UIImage imageWithData:imageData];
            ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
            imageModel.isOrignal = NO;
            imageModel.picSize = image.size;
            imageModel.name = [NSString stringWithFormat:@"%@",[NSString getArc4random5:0]];
            CGFloat compressScale = 1;
            NSData*data= UIImageJPEGRepresentation(image, 0.8);
            if (data.length/1024.0/1024.0 < 3) { //小于3M的
                compressScale = 0.1;  //压缩10倍
            }else{  //大于3M
                compressScale = 0.05; //压缩20倍
            }
            imageModel.isGif = NO;
            imageModel.compressImageData = UIImageJPEGRepresentation(image, compressScale*0.8);
            imageModel.orignalImageData = UIImageJPEGRepresentation(image, 0.8);
            ChatModel*config = [[ChatModel alloc]init];
            config.chatID = chatId;
            config.chatType = chatType;
            config.authorityType = AuthorityType_friend;
            NSArray *needUploadImageItems = [ChatUtil initPicMessage:@[imageModel] config:config isGif:NO];
            for (ChatModel *model in needUploadImageItems) {
                NSString *jsonString = [[WebSocketManager sharedManager]createSendMessageWithChatModel:model];
                model.message = jsonString;
                [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
                [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
            }
            [[WCDBManager sharedManager]insertChatModels:needUploadImageItems];
            OSSWrapper *wrapper = [[OSSWrapper alloc] init];
            [wrapper uploadImageWithImages:needUploadImageItems  uploadProgress:^(NSString *_Nonnull progress, ChatModel *_Nonnull chatModel) {
                
            } success:^(ChatModel *_Nonnull chatModel) {
                [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
                [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
                [self cancleAction];
                if ([WebSocketManager.sharedManager.currentChatID containsString:chatId]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kShareExtensionNotification object:chatModel];
                }
                [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
            } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                [QMUITipsTool showSuccessWithMessage:@"FailedToSend".icanlocalized inView:nil];
            }];
        }
        
        
    }else{
        [self cancleAction];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kChatListCellHeight;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton dzButtonWithTitle:NSLocalizedString(@"Cancel", nil) image:nil backgroundColor:nil titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(cancleAction)];
    }
    return _cancleBtn;
}

- (void)cancleAction {
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (SearchHeadView *)chatListSearchView {
    if (!_chatListSearchView) {
        _chatListSearchView = [[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        _chatListSearchView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search", 搜索);
        _chatListSearchView.shouShowKeybord = NO;
        _chatListSearchView.searchTipsImageView.image = [UIImage imageNamed:@"icon_search"];
        [_chatListSearchView updateConstraint];
        ViewRadius(_chatListSearchView.bgView, 15.0);
        @weakify(self);
        _chatListSearchView.tapBlock = ^{
            @strongify(self);
            ChatListSearchViewController*vc=[ChatListSearchViewController new];
            vc.tapBlock = ^(NSString * _Nonnull chatId, NSString * _Nonnull chatType) {
                [self sendDataWithchatId:chatId chatType:chatType];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _chatListSearchView;
}

- (void)sendPhotoAlbumVideoWithChatModel:(ChatModel*)model  fileServiceUrl:(NSString*)fileServiceUrl originalHash:(NSString*)originalHash exit:(BOOL)exit {
    if (exit) {//存在url
        OSSWrapper *wrapper = [[OSSWrapper alloc]init];
        [wrapper uploadImagesWithImage:[UIImage imageWithData:model.orignalImageData] successHandler:^(NSString * _Nonnull imageimageUrl) {
            model.imageUrl = imageimageUrl;
            model.uploadState = 1;
            model.sendState = 1;
            model.fileServiceUrl = fileServiceUrl;
            [self handleVideoAfterUploadSuccessWithChatModel:model];
            [self.tableView reloadData];
        } failureHandler:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
    }else{
        //先上传
        OSSWrapper *wrapper = [[OSSWrapper alloc]init];
        [QMUITipsTool showLoadingWihtMessage:@"Sending".icanlocalized inView:self.view];
        [wrapper uploadVideoWithChatModel:model imageUploadProgress:^(ChatModel * _Nonnull model) {
            
        } imageUploadSuccess:^(ChatModel * _Nonnull chatModel) {
            if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
                [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
                NSData*data = [NSData dataWithContentsOfFile:model.showFileName];
                [self ossAddHashWihtHash:originalHash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                NSString*hash = [NSString getHasNameData:data];
                [self ossAddHashWihtHash:hash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
            }
        } imagefailure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        } videoUploadProgress:^(ChatModel * _Nonnull model) {
            
        } videoUploadSuccess:^(ChatModel * _Nonnull chatModel) {
            if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
                
                [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
                NSData *data = [NSData dataWithContentsOfFile:model.showFileName];
                [self ossAddHashWihtHash:originalHash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                NSString *hash = [NSString getHasNameData:data];
                [self ossAddHashWihtHash:hash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
            }
        } videofailure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
    }
}

- (void)handleVideoAfterUploadSuccessWithChatModel:(ChatModel*)chatModel {
    UIImage *coverImage = [UIImage imageWithData:chatModel.orignalImageData];
    VideoMessageInfo *info = [[VideoMessageInfo alloc]init];
    info.sightUrl = chatModel.fileServiceUrl;
    info.content = chatModel.imageUrl;
    info.name = [NSString stringWithFormat:@"%@",chatModel.fileCacheName];
    info.duration = chatModel.mediaSeconds;
    info.size = chatModel.totalUnitCount;
    info.width = coverImage.size.width;
    info.height = coverImage.size.height;
    chatModel.messageContent = [info mj_JSONString];
    NSString *jsonString = [[WebSocketManager sharedManager]createSendMessageWithChatModel:chatModel];
    chatModel.message = jsonString;
    [[WCDBManager sharedManager]insertChatModel:chatModel];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
    [QMUITipsTool showSuccessWithMessage:@"Success".icanlocalized inView:nil];
    [self cancleAction];
    if ([WebSocketManager.sharedManager.currentChatID containsString:chatModel.chatID]) {//
        [[NSNotificationCenter defaultCenter]postNotificationName:kShareExtensionNotification object:chatModel];
    }
}

- (void)ossAddHashWihtHash:(NSString*)hash url:(NSString*)url name:(NSString*)name size:(NSString*)size path:(NSString*)path {
    [[ChatViewHandleTool shareManager]ossAddHashWihtHash:hash url:url name:name size:size path:path];
}
@end

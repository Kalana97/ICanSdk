//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 24/9/2019
 - File name:  YBImageBrowerTool.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "YBImageBrowerTool.h"

#import "YBIBVideoData.h"
#import "WCDBManager+ChatModel.h"
#import "ChatModel.h"
#import "ChatMineMessageTableViewCell.h"
#import "SDImageCache.h"
#import "UploadImgModel.h"
@interface YBImageBrowerTool ()

@end
@implementation YBImageBrowerTool
-(void)showYBImageBrowerWithCurrentIndex:(NSInteger )currentIndex currentTableView:(UITableView *)tableView currentChatId:(NSString*)currentChatId{
    //    NSArray*array=[[WCDBManager sharedManager]fetchMediaChatModelWihtChatId:currentChatId ];
    //    NSMutableArray*datas=[NSMutableArray array];
    //    [array enumerateObjectsUsingBlock:^(ChatModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if ([obj.messageType isEqualToString:ImageMessageType] ) {
    //            if (obj.isOutGoing) {
    //                // 本地图片
    //                YBIBImageData *data = [YBIBImageData new];
    //                data.imagePath = [ MessageImageCache(obj.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",obj.fileCacheName]];;
    //                //                data.projectiveView = [self viewAtIndex:idx currentTableView:tableView];
    //                [datas addObject:data];
    //            }else{
    //                // 网络图片
    //                YBIBImageData *data = [YBIBImageData new];
    //                data.imageURL = [NSURL URLWithString:obj.fileServiceUrl];
    //                //                data.projectiveView = [self viewAtIndex:idx currentTableView:tableView];
    //                [datas addObject:data];
    //            }
    //
    //
    //
    //        }
    //    }];
    //
    //    self.browser = [YBImageBrowser new];
    //    self.browser.dataSourceArray = datas;
    //    self.browser.currentPage = currentIndex;
    //
    //    [self.browser show];
}
-(void)showReplyImageWithContent:(NSString*)content{
    NSMutableArray*datas=[NSMutableArray array];
    YBIBImageData *data = [YBIBImageData new];
    ImageMessageInfo*imageInfo=[ImageMessageInfo mj_objectWithKeyValues:content];
    if (!imageInfo.isFull) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imageInfo.imageUrl]];
        BOOL isExit = [[SDImageCache sharedImageCache]diskImageDataExistsWithKey:key];
        //此方法会先从memory中取。
        if (isExit) {
            data.imageURL=[NSURL URLWithString:imageInfo.imageUrl];
        }else{
            data.extraData=[NSURL URLWithString:imageInfo.imageUrl];
            data.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_%.f,w_%.f,limit_1",imageInfo.imageUrl,imageInfo.height*3.0,imageInfo.width*3.0]];
        }
        
    }else{
        data.imageURL = [NSURL URLWithString:imageInfo.imageUrl];
    }
    [datas addObject:data];
    self.browser = [YBImageBrowser new];
    YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
    self.browser.toolViewHandlers = @[toolView];
    toolView.operationButton.hidden=toolView.pageLabel.hidden=YES;
    self.browser.dataSourceArray = datas;
    
    [self.browser show];
}
- (void)showYBImageBrowerWithCurrentIndex:(NSInteger )currentIndex chatModelArray:(NSArray<ChatModel*>*)array{
    NSMutableArray*datas=[NSMutableArray array];
    for (ChatModel*model in array) {
        if ([model.messageType isEqualToString:ImageMessageType] ) {
            if (model.isOutGoing) {
                // 本地图片
                YBIBImageData *data = [YBIBImageData new];
                data.imagePath = [ MessageImageCache(model.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.fileCacheName]];;
                if ([DZFileManager fileIsExistOfPath:data.imagePath]) {
                    [datas addObject:data];
                }else{
                    // 网络图片
                    YBIBImageData *data = [YBIBImageData new];
                    ImageMessageInfo*imageInfo=[ImageMessageInfo mj_objectWithKeyValues:model.messageContent];
                    data.imageURL = [NSURL URLWithString:imageInfo.imageUrl];
                    [datas addObject:data];
                }
                
            }else{
                // 网络图片
                YBIBImageData *data = [YBIBImageData new];
                ImageMessageInfo*imageInfo=[ImageMessageInfo mj_objectWithKeyValues:model.messageContent];
                if (!imageInfo.isFull) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imageInfo.imageUrl]];
                    BOOL isExit = [[SDImageCache sharedImageCache]diskImageDataExistsWithKey:key];
                    //此方法会先从memory中取。
                    if (isExit) {
                        data.imageURL=[NSURL URLWithString:imageInfo.imageUrl];
                    }else{
                        data.extraData=[NSURL URLWithString:imageInfo.imageUrl];
                        data.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_%.f,w_%.f,limit_1",imageInfo.imageUrl,model.layoutHeight*3.0,model.layoutWidth*3.0]];
                    }
                    
                }else{
                    data.imageURL = [NSURL URLWithString:imageInfo.imageUrl];
                }
                [datas addObject:data];
            }
            
        }
    }
    self.browser = [YBImageBrowser new];
    YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
    self.browser.toolViewHandlers = @[toolView];
    toolView.operationButton.hidden=toolView.pageLabel.hidden=YES;
    self.browser.dataSourceArray = datas;
    self.browser.currentPage = currentIndex;
    [self.browser show];
}

-(void)showYBImageBrowerWithCurrentIndex:(NSInteger)currentIndex imageItems:(NSArray*)imageItems{
    NSMutableArray * array = [NSMutableArray array];
    for (UIImage * image in imageItems) {
        YBIBImageData *data = [YBIBImageData new];
        data.image = ^UIImage * _Nullable{
            return image;
        };
        [array addObject:data];
    }
    
    self.browser = [YBImageBrowser new];
    YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
    self.browser.toolViewHandlers = @[toolView];
    toolView.operationButton.hidden=toolView.pageLabel.hidden=NO;
    toolView.deleImgeBlock = ^(NSInteger imageIndex) {
        //"Do you want to delete this picture?"="要删除这张图片吗？";
        [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Do you want to delete this picture?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                [array removeObjectAtIndex:imageIndex];
                if (array.count==0) {
                    [self.browser hide];
                }
                if (self.deleImgeBlock) {
                    self.deleImgeBlock(imageIndex);
                }
                self.browser.dataSourceArray=array;
                [self.browser reloadData];
            }
        }];
    };
    self.browser.dataSourceArray = array;
    self.browser.currentPage = currentIndex;
    //    self.browser.shouldHideStatusBar =false;
    [self.browser show];
    
}


-(void)showTimelinsNetWorkImageBrowerWithCurrentIndex:(NSInteger)currentIndex imageItems:(NSArray*)imageItem{
    NSMutableArray * array = [NSMutableArray array];
    for (NSString * image in imageItem) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:image];
        [array addObject:data];
    }
    self.browser = [YBImageBrowser new];
    YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
    self.browser.toolViewHandlers = @[toolView];
    toolView.operationButton.hidden=toolView.pageLabel.hidden=YES;
    self.browser.dataSourceArray = array;
    self.browser.currentPage = currentIndex;
    [self.browser show];
    
}
- (void)hiddenYBImageBrower{
    if (!self.browser.isHidden) {
        [self.browser hide];
    }
    
}

-(void)showCirclePhotoWallImagesWith:(NSArray<PhotoWallInfo*>*)imageItems urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    NSMutableArray * array = [NSMutableArray array];
    if (urlArray.count>0) {
        for (NSString * url in urlArray) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:url];
            [array addObject:data];
        }
    }else{
        for (PhotoWallInfo * model in imageItems) {
            YBIBImageData *data = [YBIBImageData new];
            if (model.url) {
                data.imageURL = [NSURL URLWithString:model.url];
            }else{
                data.image = ^UIImage * _Nullable{
                    return model.image;
                };
                
            }
            [array addObject:data];
        }
    }
    self.browser = [YBImageBrowser new];
    if (canDelete) {
        YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
        self.browser.toolViewHandlers = @[toolView];
        toolView.operationButton.hidden=toolView.pageLabel.hidden=NO;
        toolView.deleImgeBlock = ^(NSInteger imageIndex) {
            [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Do you want to delete this picture?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    [array removeObjectAtIndex:imageIndex];
                    if (array.count==0) {
                        [self.browser hide];
                    }
                    if (self.deleImgeBlock) {
                        self.deleImgeBlock(imageIndex);
                    }
                    self.browser.dataSourceArray=array;
                    [self.browser reloadData];
                }
            }];
        };
    }
    self.browser.dataSourceArray = array;
    self.browser.currentPage = index;
    [self.browser show];
}
-(void)showCircleUserImagesWith:(NSArray<UploadImgModel*>*)imageItems urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    NSMutableArray * array = [NSMutableArray array];
    if (urlArray.count>0) {
        for (NSString * url in urlArray) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:url];
            [array addObject:data];
        }
    }else{
        for (UploadImgModel * model in imageItems) {
            YBIBImageData *data = [YBIBImageData new];
            if (model.ossImgUrl) {
                data.imageURL = [NSURL URLWithString:model.ossImgUrl];
            }else{
                data.image = ^UIImage * _Nullable{
                    return model.image;
                };
                
            }
            [array addObject:data];
        }
    }
    self.browser = [YBImageBrowser new];
    if (canDelete) {
        YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
        self.browser.toolViewHandlers = @[toolView];
        toolView.operationButton.hidden=toolView.pageLabel.hidden=NO;
        toolView.deleImgeBlock = ^(NSInteger imageIndex) {
            [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Do you want to delete this picture?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    [array removeObjectAtIndex:imageIndex];
                    if (array.count==0) {
                        [self.browser hide];
                    }
                    if (self.deleImgeBlock) {
                        self.deleImgeBlock(imageIndex);
                    }
                    self.browser.dataSourceArray=array;
                    [self.browser reloadData];
                }
            }];
        };
    }
    self.browser.dataSourceArray = array;
    self.browser.currentPage = index;
    [self.browser show];
}
-(void)showC2CQrCodeImageWith:(NSString*)imageStr{
    self.browser = [YBImageBrowser new];
    YBIBImageData *data = [YBIBImageData new];
    data.imageURL = [NSURL URLWithString:imageStr];
    self.browser.dataSourceArray = @[data];
    [self.browser show];
    
}

-(void)showBusinessPhotoWallImagesWith:(NSArray<BusinessPhotoWallList*>*)imageItems urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    NSMutableArray * array = [NSMutableArray array];
    if (urlArray.count>0) {
        for (NSString * url in urlArray) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:url];
            [array addObject:data];
        }
    }else{
        for (BusinessPhotoWallList *model in imageItems) {
            YBIBImageData *data = [YBIBImageData new];
            if(model.photo){
                data.imageURL = [NSURL URLWithString:model.photo];
            }else{
                if(model.checkPhoto){
                    data.imageURL = [NSURL URLWithString:model.checkPhoto];
                }else{
                    return;
                }
            }
            [array addObject:data];
        }
    }
    self.browser = [YBImageBrowser new];
    if (canDelete) {
        YBImageToolViewHandler*toolView=[[YBImageToolViewHandler alloc]init];
        self.browser.toolViewHandlers = @[toolView];
        toolView.operationButton.hidden=toolView.pageLabel.hidden=NO;
        toolView.deleImgeBlock = ^(NSInteger imageIndex) {
            [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Do you want to delete this picture?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    [array removeObjectAtIndex:imageIndex];
                    if (array.count==0) {
                        [self.browser hide];
                    }
                    if (self.deleImgeBlock) {
                        self.deleImgeBlock(imageIndex);
                    }
                    self.browser.dataSourceArray=array;
                    [self.browser reloadData];
                }
            }];
        };
    }
    self.browser.dataSourceArray = array;
    self.browser.currentPage = index;
    [self.browser show];
}

@end


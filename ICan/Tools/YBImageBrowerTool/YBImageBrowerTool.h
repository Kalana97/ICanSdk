//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 24/9/2019
- File name:  YBImageBrowerTool.h
- Description: 杨波图片浏览器
- Function List: 
*/
        

#import <Foundation/Foundation.h>
#import "YBImageToolViewHandler.h"
#import "YBImageBrowser.h"
#import "BusinessUserResponse.h"
NS_ASSUME_NONNULL_BEGIN
@class UploadImgModel; 
@interface YBImageBrowerTool : NSObject
@property(nonatomic, strong) YBImageBrowser *browser;
@property(nonatomic, copy) void (^deleImgeBlock)(NSInteger index);
- (void)showYBImageBrowerWithCurrentIndex:(NSInteger )currentIndex currentTableView:(UITableView *)tableView currentChatId:(NSString*)currentChatId;


- (void)showYBImageBrowerWithCurrentIndex:(NSInteger )currentIndex chatModelArray:(NSArray<ChatModel*>*)array;
//如果撤回的图片正在浏览 那么就隐藏改浏览
- (void)hiddenYBImageBrower;


-(void)showYBImageBrowerWithCurrentIndex:(NSInteger)currentIndex imageItems:(NSArray*)imageItems;

/// 显示的是查看朋友圈的时候的view
/// @param currentIndex currentIndex description
/// @param imageItem imageItem description
-(void)showTimelinsNetWorkImageBrowerWithCurrentIndex:(NSInteger)currentIndex imageItems:(NSArray*)imageItem;

-(void)showReplyImageWithContent:(NSString*)content;

-(void)showCirclePhotoWallImagesWith:(NSArray<PhotoWallInfo*>*)imageItems urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete;

-(void)showCircleUserImagesWith:(NSArray<UploadImgModel*>*)imageItems  urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete;

-(void)showC2CQrCodeImageWith:(NSString*)imageStr;
-(void)showBusinessPhotoWallImagesWith:(NSArray<BusinessPhotoWallList*>*)imageItems urlArray:(NSArray*)urlArray currentIndex:(NSInteger)index canDelete:(BOOL)canDelete;
@end

NS_ASSUME_NONNULL_END

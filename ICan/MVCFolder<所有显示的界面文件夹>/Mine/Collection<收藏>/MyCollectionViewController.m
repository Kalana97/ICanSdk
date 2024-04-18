//
//  MyCollectionViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/24.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionTimelinesImageTableViewCell.h"
#import "HJCActionSheet.h"
#import "ShowAppleMapLocationViewController.h"
#import "FriendDetailViewController.h"
#import "YBImageBrowerTool.h"
#import "TimelinesDetailViewController.h"
#import "AudioPlayerManager.h"
#import "ShowCollectionTextDetailViewController.h"
#import "DZAVPlayerViewController.h"
@interface MyCollectionViewController ()<HJCActionSheetDelegate,MyCollectionTimelinesImageTableViewCellDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)  UIView * footerView;
@property(nonatomic,strong)  HJCActionSheet * hjcActionSheet;

@property(nonatomic,strong)  CollectionListDetailResponse * response;
@property(nonatomic, strong) YBImageBrowerTool *ybImageBrowerTool;
/**预览文件*/
@property(nonatomic, strong) UIDocumentInteractionController *docVc;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MyFavorite".icanlocalized;
    self.listRequest=[CollectionListRequest request];
    self.listClass=[CollectionListResponse class];
    [self refreshList];
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:KMyCollectionTimelinesTableViewCell];
}

-(void)showHjcActionSheetWith:(CollectionListDetailResponse *)response{
    self.response = response;
    [self showActionSheet];
}

-(void)showActionSheet{
    self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:@"Delete".icanlocalized, nil];
    self.hjcActionSheet.tag = 101;
    [self.hjcActionSheet setBtnTag:1 TextColor:UIColorMake(0, 0, 0) textFont:18.0f enable:YES];
    [self.hjcActionSheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self deleteCollectionRequest];
    }
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionListDetailResponse * response = [self.listItems objectAtIndex:indexPath.row];
    //有图片，有文字
    MyCollectionTimelinesImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KMyCollectionTimelinesTableViewCell];
    cell.response = response;
    cell.delegate =self;
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionListDetailResponse * response = [self.listItems objectAtIndex:indexPath.row];
    [self handleResponseWith:response];
}

-(void)handleResponseWith:(CollectionListDetailResponse *)response{
    if ([response.favoriteType isEqualToString:@"TimeLine"]) {
        TimelinesDetailViewController * vc = [TimelinesDetailViewController new];
        vc.tapCommentButton = false;
        vc.messageId = response.busId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([response.favoriteType isEqualToString:@"Txt"]){
        ShowCollectionTextDetailViewController*vc=[[ShowCollectionTextDetailViewController alloc]init];
        vc.response=response;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([response.favoriteType isEqualToString:@"Video"]){
        [self showVideoWithUrl:[NSURL URLWithString:response.videoUrl]];
    }else if ([response.favoriteType isEqualToString:@"Image"]){
        
        [self.ybImageBrowerTool showTimelinsNetWorkImageBrowerWithCurrentIndex:0 imageItems:@[response.imageUrl]];
        
        
    }else if ([response.favoriteType isEqualToString:@"Voice"]){
        [[AudioPlayerManager shareDZAudioPlayerManager]playCollectionAudioWitUrl:response.voiceUrl];
        
    }else if ([response.favoriteType isEqualToString:@"File"]){
        NSString *filePath = [MessageCollectFileCache stringByAppendingPathComponent:[response.fileUrl md5]];
        if ([DZFileManager fileIsExistOfPath:filePath]) {
            self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            self.docVc.delegate = self;
            [self.docVc presentPreviewAnimated:YES];
        }else{
            [[NetworkRequestManager shareManager]downloadCollectFileWithUrl:response.fileUrl downloadProgress:nil success:^(NSString *localPath) {
                self.docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:localPath]];
                self.docVc.delegate = self;
                [self.docVc presentPreviewAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
            
        }
    }else if ([response.favoriteType isEqualToString:@"UserCard"]) {
        FriendDetailViewController *vc = [FriendDetailViewController new];
        vc.userId = response.userCardId;
        vc.friendDetailType = FriendDetailType_push;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([response.favoriteType isEqualToString:@"POI"]) {
        NSLog(@"response");
//        This is future development
//        LocationMessageInfo *linfo = [LocationMessageInfo mj_objectWithKeyValues:info.jsonMessage];
//        NSArray *names = [linfo.address componentsSeparatedByString:@","];
//        linfo.name = names[0];
//        ShowAppleMapLocationViewController *locatinVC = [ShowAppleMapLocationViewController new];
//        locatinVC.locationMessageInfo = linfo;
//        [[AppDelegate shared] pushViewController:locatinVC animated:true];
    }
}

-(void)showVideoWithUrl:(NSURL *)url{
    
    DZAVPlayerViewController* vc = [[DZAVPlayerViewController alloc]init];
    [vc setPlayUrl:url aVPlayerViewType:AVPlayerViewNormal];
    [self.navigationController pushViewController:vc animated:YES];
    [self.view endEditing:YES];
    
}
#pragma mark -- UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.view.frame;
}
-(YBImageBrowerTool *)ybImageBrowerTool{
    if (!_ybImageBrowerTool) {
        _ybImageBrowerTool = [[YBImageBrowerTool alloc]init];
    }
    return _ybImageBrowerTool;
}

-(void)deleteCollectionRequest{
    DeleteCollectionRequest * request = [DeleteCollectionRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/favorites/%@",request.baseUrlString,self.response.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        [self.listItems removeObject:self.response];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

@end

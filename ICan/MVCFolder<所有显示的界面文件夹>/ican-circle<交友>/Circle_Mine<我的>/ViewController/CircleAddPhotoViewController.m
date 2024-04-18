
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/7/2021
- File name:  CircleMyImgViewController.m
- Description:
- Function List:
*/
        

#import "CircleAddPhotoViewController.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import <TZImagePickerController.h>
#import "YBImageBrowerTool.h"
#import "UploadImgModel.h"
#import "PrivacyPermissionsTool.h"
#import "CircleOssWrapper.h"

@interface CircleAddPhotoViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *addImgModel;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) UIButton *rightButton;

@end

@implementation CircleAddPhotoViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.collectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    self.addImgModel=[[UploadImgModel alloc]init];
    self.addImgModel.image=UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd=YES;
    self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
    if (self.selectPhotos.count!=9) {
        [self.selectPhotos addObject:self.addImgModel];
    }
    self.addPhotoLabel.text=@"CircleEditMydDataImgTableViewCell.addPhotoLabel".icanlocalized;
    [self updateView];
}

#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
-(void)updateView{
    [self.collectionView reloadData];
    [self.collectionView layoutSubviews];
    [self.collectionView layoutIfNeeded];
    self.collectionViewHeight.constant=self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}
//- (void)addRecognize{
//    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
//    //设置长按响应时间为0.5秒
//    recognize.minimumPressDuration = 0.5;
//    [self.collectionView addGestureRecognizer:recognize];
//}
//// 长按抖动手势方法
//- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
//    switch (longGesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            // 通过手势获取点，通过点获取点击的indexPath， 移动该cell
//            NSIndexPath *aIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
//            UploadImgModel*model=[self.circleUserInfo.selectImgs objectAtIndex:aIndexPath.item];
//            if (!model.isAdd) {
//                [self.collectionView beginInteractiveMovementForItemAtIndexPath:aIndexPath];
//            }
//        }
//            break;
//        case UIGestureRecognizerStateChanged:{
//            NSIndexPath *aIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
//            UploadImgModel*model=[self.circleUserInfo.selectImgs objectAtIndex:aIndexPath.item];
//            if (!model.isAdd) {
//                // 通过手势获取点，通过点获取拖动到的indexPath， 更新该cell位置
//                [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
//            }
//
//
//        }
//            break;
//        case UIGestureRecognizerStateEnded:{
//            // 移动完成关闭cell移动
//            [self.collectionView endInteractiveMovement];
//        // 移除拖动手势
//            [self.collectionView removeGestureRecognizer:longGesture];
//            // collectionView停止抖动
//
//            // 为collectionView添加拖动手势
//            [self addRecognize];
//            NSArray *cellArray = [self.collectionView visibleCells];
//            for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
//                // 调用cell停止抖动方法
//                [cell stopShake];
//            }
//        }
//            break;
//        default:
//            [self.collectionView endInteractiveMovement];
//            [self.collectionView removeGestureRecognizer:longGesture];
//
//            [self addRecognize];
//            NSArray *cellArray = [self.collectionView visibleCells];
//            for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
//                [cell stopShake];
//            }
//            break;
//    }
//}
//#pragma mark - UICollectionViewDataSource
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (collectionView==self.collectionView) {
//        UploadImgModel*model=self.circleUserInfo.selectImgs[indexPath.row];
//        if (model.isAdd) {
//            return NO;
//        }
//        return YES;
//    }
//    return NO;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    if (collectionView==self.collectionView) {
//        NSMutableArray*array=[NSMutableArray arrayWithArray:self.circleUserInfo.selectImgs];
//        // 删除数据源中初始位置的数据
//        UploadImgModel* objc = [array objectAtIndex:sourceIndexPath.item];
//        [self.circleUserInfo.selectImgs removeObject:objc];
//        // 将数据插入数据源中新的位置，实现数据源的更新
//        [self.circleUserInfo.selectImgs insertObject:objc atIndex:destinationIndexPath.item];
//        NSArray *cellArray = [self.collectionView visibleCells];
//        for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
//            [cell stopShake];
//        }
//    }
//
//}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.selectPhotos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleUserDetailImgeCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleUserDetailImgeCollectionViewCell forIndexPath:indexPath];
    cell.deletBtn.hidden=NO;
    UploadImgModel*model=self.selectPhotos[indexPath.row];
    cell.model=model;
    cell.deleteBlock = ^(UploadImgModel * _Nonnull model) {
        [self.selectPhotos removeObjectAtIndex:indexPath.item];
        [self.selectPhotos removeObject:self.addImgModel];
        self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
        [self.selectPhotos addObject:self.addImgModel];
        [self updateView];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgModel*model=[self.selectPhotos objectAtIndex:indexPath.row];
    if (model.isAdd) {
        [self pushTZImagePickerController];
    }else{
        YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
        tool.deleImgeBlock = ^(NSInteger index) {
            [self.selectPhotos removeObjectAtIndex:index];
            [self.selectPhotos removeObject:self.addImgModel];
            self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
            [self.self.selectPhotos addObject:self.addImgModel];
            [self updateView];
        };
        NSMutableArray*array=[NSMutableArray arrayWithArray:self.selectPhotos];
        [array removeObject:self.addImgModel];
        [tool showCircleUserImagesWith:array urlArray:@[] currentIndex:indexPath.row canDelete:YES];
    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-25)/3.0,(ScreenWidth-25)/3.0);
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 2;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (void)pushTZImagePickerController {
    NSInteger count;
    if ([self.selectPhotos containsObject:self.addImgModel]) {
        count=9-self.selectPhotos.count+1;
    }else{
        count=9-self.selectPhotos.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    // 1.设置目前已经选中的图片数组
    
    //    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.photoWidth = 1600;
    imagePickerVc.photoPreviewMaxWidth = 1600;
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {

}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeObject:self.addImgModel];
    for (UIImage*image in photos) {
        UploadImgModel*model=[[UploadImgModel alloc]init];
        model.image=image;
        [self.selectPhotos addObject:model];
    }
    self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
    if (self.selectPhotos.count!=9) {
        [self.selectPhotos addObject:self.addImgModel];
    }
    
    [self updateView];
    
}
// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}
#pragma mark - Lazy
-(UIButton *)rightButton{
    if (!_rightButton) {
        
        //        "CircleEditMydDataViewController.rightButton"="保存";
        _rightButton=[UIButton dzButtonWithTitle:@"CircleEditMydDataViewController.rightButton".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}
#pragma mark - Event
-(void)rightBarButtonItemAction{
    [self.selectPhotos removeObject:self.addImgModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    });
    [self uploadImageWithImageItems:self.selectPhotos];
    if (self.selectPhotos.count!=9) {
        [self.selectPhotos addObject:self.addImgModel];
    }
   
    
}
-(void)uploadImageWithImageItems:(NSArray<UploadImgModel*>*)imageItems{
    [[CircleOssWrapper shared]uploadImagesWithModels:imageItems uploadType:UploadType_CircleUser successHandler:^(NSArray * _Nonnull imgModels) {
        [self setUserInfoFirst:imgModels];
    }];
}
//设置用户信息
-(void)setUserInfoFirst:(NSArray*)imageModel{
    AddPhotosWallRequest * request = [AddPhotosWallRequest request];
    NSMutableArray*array=[NSMutableArray arrayWithArray:imageModel];
    NSArray*imageurl=[array valueForKeyPath:@"ossImgUrl"];
    request.urls=imageurl;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self.selectPhotos removeAllObjects];
        [self.navigationController popViewControllerAnimated: YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCirclePhotoWallChangeNotification object:nil];
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

@end

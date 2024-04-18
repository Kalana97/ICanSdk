//
//  BusinessAddPhotoViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessAddPhotoViewController.h"
#import "BusinessListImageCollectionViewCell.h"
#import <TZImagePickerController.h>
#import "YBImageBrowerTool.h"
#import "UploadImgModel.h"
#import "PrivacyPermissionsTool.h"
#import "CircleOssWrapper.h"
#import "BusinessUserRequest.h"
#import "BusinessNetworkReqManager.h"

@interface BusinessAddPhotoViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(nonatomic, strong) UploadImgModel *addImgModel;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) UIButton *rightButton;
@end

@implementation BusinessAddPhotoViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.collectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    self.addImgModel = [[UploadImgModel alloc]init];
    self.addImgModel.image = UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd = YES;
    self.countLabel.text = [NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
    if(self.selectPhotos.count != 9 && !self.isSinglePhoto){
        [self.selectPhotos addObject:self.addImgModel];
    }
    self.addPhotoLabel.text = @"CircleEditMydDataImgTableViewCell.addPhotoLabel".icanlocalized;
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
    self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBusinessListImageCollectionViewCell forIndexPath:indexPath];
    cell.deletBtn.hidden = NO;
    UploadImgModel *model = self.selectPhotos[indexPath.row];
    cell.model = model;
    cell.deleteBlock = ^(UploadImgModel * _Nonnull model) {
        [self.selectPhotos removeObjectAtIndex:indexPath.item];
        [self.selectPhotos removeObject:self.addImgModel];
        self.countLabel.text = [NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
        [self.selectPhotos addObject:self.addImgModel];
        [self updateView];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgModel *model = [self.selectPhotos objectAtIndex:indexPath.row];
    if (model.isAdd) {
        [self pushTZImagePickerController];
    }else{
        YBImageBrowerTool *tool = [[YBImageBrowerTool alloc]init];
        tool.deleImgeBlock = ^(NSInteger index) {
            [self.selectPhotos removeObjectAtIndex:index];
            [self.selectPhotos removeObject:self.addImgModel];
            self.countLabel.text = [NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
            [self.self.selectPhotos addObject:self.addImgModel];
            [self updateView];
        };
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.selectPhotos];
        [array removeObject:self.addImgModel];
        [tool showCircleUserImagesWith:array urlArray:@[] currentIndex:indexPath.row canDelete:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-25)/3.0,(ScreenWidth-25)/3.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)pushTZImagePickerController {
    NSInteger count;
    if ([self.selectPhotos containsObject:self.addImgModel]) {
        count = 9 - self.selectPhotos.count + 1;
    }else{
        count = 9 - self.selectPhotos.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.videoMaximumDuration = 10;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.photoWidth = 1600;
    imagePickerVc.photoPreviewMaxWidth = 1600;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {

}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeObject:self.addImgModel];
    for (UIImage *image in photos) {
        UploadImgModel *model = [[UploadImgModel alloc]init];
        model.image = image;
        [self.selectPhotos addObject:model];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd/9",self.selectPhotos.count];
    if (self.selectPhotos.count != 9) {
        [self.selectPhotos addObject:self.addImgModel];
    }
    [self updateView];
}

- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

#pragma mark - Lazy
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton dzButtonWithTitle:@"CircleEditMydDataViewController.rightButton".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}

#pragma mark - Event
-(void)rightBarButtonItemAction{
    [self.selectPhotos removeObject:self.addImgModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:YES];
    });
    [self uploadImageWithImageItems:self.selectPhotos];
    if (self.selectPhotos.count != 9) {
        [self.selectPhotos addObject:self.addImgModel];
    }
}

-(void)uploadImageWithImageItems:(NSArray<UploadImgModel *> *)imageItems{
    [[CircleOssWrapper shared]uploadImagesWithModels:imageItems uploadType:UploadType_CircleUser successHandler:^(NSArray * _Nonnull imgModels) {
        [self setUserInfoFirst:imgModels];
    }];
}

-(void)setUserInfoFirst:(NSArray *)imageModel{
    AddBusinessPhotosWallRequest *request = [AddBusinessPhotosWallRequest request];
    NSMutableArray *array = [NSMutableArray arrayWithArray:imageModel];
    NSArray *imageurl = [array valueForKeyPath:@"ossImgUrl"];
    request.urls = imageurl;
    request.parameters = [request mj_JSONObject];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self.selectPhotos removeAllObjects];
        [self.navigationController popViewControllerAnimated: YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCirclePhotoWallChangeNotification object:nil];
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
    }];
}
@end

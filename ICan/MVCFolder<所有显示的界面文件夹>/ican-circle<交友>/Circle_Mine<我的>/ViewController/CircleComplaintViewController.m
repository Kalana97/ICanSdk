//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleComplaintViewController.m
 - Description:
 - Function List:
 */


#import "CircleComplaintViewController.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import <TZImagePickerController.h>
#import "UploadImgModel.h"
#import "CircleOssWrapper.h"
#import "YBImageBrowerTool.h"
@interface CircleComplaintViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *complaintLabel;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *addTipsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *addButtoon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectedPhoto;
//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *addImgModel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation CircleComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.addImgModel=[[UploadImgModel alloc]init];
    self.addImgModel.image=UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd=YES;
    [self.selectedPhoto addObject:self.addImgModel];
    [self.collectView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    //"CircleComplaintViewController.complaintLabel"="投诉原因";
    //    "CircleComplaintViewController.addTipsLabel"="添加照片";
    //    "CircleComplaintViewController.textViewPlacholder"="请输入投诉原因";
    //    "CircleComplaintViewController.addButtoon"="提交";
    self.title=@"CircleMoreViewController.complaint".icanlocalized;
    [self.addButtoon layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.complaintLabel.text=@"CircleComplaintViewController.complaintLabel".icanlocalized;
    self.addTipsLabel.text=@"CircleComplaintViewController.addTipsLabel".icanlocalized;
    self.textView.placeholder=@"CircleComplaintViewController.textViewPlacholder".icanlocalized;
    [self.addButtoon setTitle:@"CircleComplaintViewController.addButtoon".icanlocalized forState:UIControlStateNormal];
    [self addRecognize];
    [self.collectView reloadData];
    self.countLabel.text=[NSString stringWithFormat:@"0/9"];
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)addRecognize{
    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    //设置长按响应时间为0.5秒
    recognize.minimumPressDuration = 0.5;
    
    [self.collectView addGestureRecognizer:recognize];
}
// 长按抖动手势方法
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该cell
            NSIndexPath *aIndexPath = [self.collectView indexPathForItemAtPoint:[longGesture locationInView:self.collectView]];
            UploadImgModel*model=[self.selectedPhoto objectAtIndex:aIndexPath.item];
            if (!model.isAdd) {
                [self.collectView beginInteractiveMovementForItemAtIndexPath:aIndexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSIndexPath *aIndexPath = [self.collectView indexPathForItemAtPoint:[longGesture locationInView:self.collectView]];
            UploadImgModel*model=[self.selectedPhoto objectAtIndex:aIndexPath.item];
            if (!model.isAdd) {
                // 通过手势获取点，通过点获取拖动到的indexPath， 更新该cell位置
                [self.collectView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectView]];
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            // 移动完成关闭cell移动
            [self.collectView endInteractiveMovement];
            // 移除拖动手势
            [self.collectView removeGestureRecognizer:longGesture];
            
            // 为collectionView添加拖动手势
            [self addRecognize];
            NSArray *cellArray = [self.collectView visibleCells];
            for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
                // 调用cell停止抖动方法
                [cell stopShake];
            }
        }
            break;
        default:
            [self.collectView endInteractiveMovement];
            [self.collectView removeGestureRecognizer:longGesture];
            [self addRecognize];
            NSArray *cellArray = [self.collectView visibleCells];
            for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
                [cell stopShake];
            }
            break;
    }
}
- (IBAction)end:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)addButtonAction {
    //    "CircleComplaintViewController.successTips"="投诉成功";
    if (self.textView.text.trimmingwhitespaceAndNewline.length<=0) {
//        "CircleComplaintViewController.nullTips"="请输入投诉内容";
        [QMUITipsTool showOnlyTextWithMessage:@"CircleComplaintViewController.nullTips".icanlocalized inView:self.view];
        return;
    }
    [self.selectedPhoto removeObject:self.addImgModel];
    //"CircleComplaintViewController.loading"="正在提交";
    [QMUITipsTool showLoadingWihtMessage:@"CircleComplaintViewController.loading".icanlocalized inView:self.view isAutoHidden:NO];
    if (self.selectedPhoto.count>0) {
        [self uploadImageWithImageItems:self.selectedPhoto];
    }else{
        [self setPostWith:@[]];
    }
}
-(void)setPostWith:(NSArray*)imgModels{
    PostComplaintsRequest*request=[PostComplaintsRequest request];
    request.content=self.textView.text;
    if (imgModels.count>0) {
        NSArray*imageurl=[imgModels valueForKeyPath:@"ossImgUrl"];
        request.images=imageurl;
    }else{
        request.images=@[];
    }
    request.targetUserId=self.targetUserId;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleBaseResponse class] contentClass:[CircleBaseResponse class] success:^(id  _Nonnull response) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleComplaintViewController.successTips".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)uploadImageWithImageItems:(NSArray<UploadImgModel*>*)imageItems{
    [[CircleOssWrapper shared]uploadImagesWithModels:imageItems uploadType:UploadType_CircleUser successHandler:^(NSArray * _Nonnull imgModels) {
        [self setPostWith:imgModels];
    }];
}
#pragma mark - UICollectionViewDataSource
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgModel*model=self.selectedPhoto[indexPath.row];
    if (model.isAdd) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // 删除数据源中初始位置的数据
    UploadImgModel* objc = [self.selectedPhoto objectAtIndex:sourceIndexPath.item];
    [self.selectedPhoto removeObject:objc];
    // 将数据插入数据源中新的位置，实现数据源的更新
    [self.selectedPhoto insertObject:objc atIndex:destinationIndexPath.item];
    NSArray *cellArray = [self.collectView visibleCells];
    for (CircleUserDetailImgeCollectionViewCell *cell in cellArray ) {
        [cell stopShake];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhoto.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserDetailImgeCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleUserDetailImgeCollectionViewCell forIndexPath:indexPath];
    cell.deletBtn.hidden=NO;
    cell.model=self.selectedPhoto[indexPath.row];
    cell.deleteBlock = ^(UploadImgModel * _Nonnull model) {
        [self.selectedPhoto removeObject:model];
        self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectedPhoto.count];
        if (![self.selectedPhoto containsObject:self.addImgModel]) {
            [self.selectedPhoto addObject:self.addImgModel];
        }
        [self.collectView reloadData];
        [self.collectView layoutSubviews];
        [self.collectView layoutIfNeeded];
        self.collectionViewHeight.constant=self.collectView.collectionViewLayout.collectionViewContentSize.height;
        [self.view layoutIfNeeded];
    };
    [cell.userImageView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgModel*model=[self.selectedPhoto objectAtIndex:indexPath.row];
    if (model.isAdd) {
        [self pushTZImagePickerController];
    }else{
        YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
        NSMutableArray*array=[NSMutableArray arrayWithArray:self.selectedPhoto];
        [array removeObject:self.addImgModel];
        [tool showCircleUserImagesWith:array urlArray:@[] currentIndex:indexPath.item canDelete:NO];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-60)/3.0,143);
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)pushTZImagePickerController {
    NSInteger count;
    if ([self.selectedPhoto containsObject:self.addImgModel]) {
        count=9-self.selectedPhoto.count+1;
    }else{
        count=9-self.selectedPhoto.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.barItemTextColor = [UIColor blackColor];
    // [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    // imagePickerVc.navigationBar.tintColor = [UIColor blackColor];
    // imagePickerVc.naviBgColor = [UIColor whiteColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
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
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectedPhoto removeObject:self.addImgModel];
    for (UIImage*image in photos) {
        UploadImgModel*model=[[UploadImgModel alloc]init];
        model.image=image;
        [self.selectedPhoto addObject:model];
    }
    self.countLabel.text=[NSString stringWithFormat:@"%zd/9",self.selectedPhoto.count];
    if (self.selectedPhoto.count!=9) {
        [self.selectedPhoto addObject:self.addImgModel];
    }
    [self.collectView reloadData];
    [self.collectView layoutSubviews];
    [self.collectView layoutIfNeeded];
    self.collectionViewHeight.constant=self.collectView.collectionViewLayout.collectionViewContentSize.height;
    [self.view layoutIfNeeded];
    
    
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
-(NSMutableArray<UploadImgModel *> *)selectedPhoto{
    if (!_selectedPhoto) {
        _selectedPhoto=[NSMutableArray array];
    }
    return _selectedPhoto;
}
@end

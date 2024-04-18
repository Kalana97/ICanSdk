//
//  BusinessMyImgViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessMyImgViewController.h"
#import "BusinessListImageCollectionViewCell.h"
#import "BusinessAddPhotoViewController.h"
#import "YBImageBrowerTool.h"
#import "UploadImgModel.h"
#import "PrivacyPermissionsTool.h"
#import <MJRefresh.h>
#import "MyPhotoWallCollectionReusableView.h"
#import "MyPhotoWallBottomView.h"
#import <TZImagePickerController.h>
#import "BusinessNetworkReqManager.h"
#import "BusinessUserRequest.h"

@interface BusinessMyImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UploadImgModel *addImgModel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray<BusinessPhotoWallList *> *photoWallItems;
@property (nonatomic, assign) BOOL  isLoadMoreData;
@property (nonatomic, assign) BOOL isAutoLoad;
@property (nonatomic, assign) NSInteger  current;
@property (nonatomic, assign) NSInteger  pageSize;
@property (nonatomic, strong) BusinessListInfo *listInfo;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSMutableArray *letterPhotoResultArr;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, assign) BOOL isSelectAll;
@property (nonatomic, strong) MyPhotoWallBottomView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *selectAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectAllImageView;
@property (weak, nonatomic) IBOutlet UIControl *selectAllBg;
@property (weak, nonatomic) IBOutlet UIControl *deleteBg;
@property (nonatomic, strong) NSMutableArray<BusinessPhotoWallList *> *selectImageItems;
@property (nonatomic, strong)MJRefreshBackNormalFooter *footer;
@end

@implementation BusinessMyImgViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshList];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:kCirclePhotoWallChangeNotification object:nil];
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.collectionView.mj_footer = self.footer;
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    self.collectionViewBottomConstraint.constant = 0;
    self.deleteBg.hidden = self.selectAllBg.hidden = YES;
    [self refreshList];
    self.canSelect = NO;
    self.isSelectAll = NO;
    [self addRecognize];
    self.title = @"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.collectionView registNibWithNibName:kBusinessListImageCollectionViewCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kMyPhotoWallCollectionReusableView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyPhotoWallCollectionReusableView];
}

- (IBAction)selectAll {
    [self.selectImageItems removeAllObjects];
    self.isSelectAll = !self.isSelectAll;
    self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
    for (NSArray *array in self.letterPhotoResultArr){
        if (self.isSelectAll) {
            [self.selectImageItems addObjectsFromArray:array];
        }
        for (BusinessPhotoWallList *info in array) {
            info.select = self.isSelectAll;
        }
    }
    if (self.isSelectAll) {
        self.title = [NSString stringWithFormat:@"%@(%lu)",@"Selected".icanlocalized,(unsigned long)self.selectImageItems.count];
    }else{
        self.title = @"BatchManagement".icanlocalized;
    }
    [self.collectionView reloadData];
}

- (IBAction)ddeleteAction {
    [self deleteImageRequest];
}

- (void)addRecognize{
    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    recognize.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:recognize];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.title = @"BatchManagement".icanlocalized;
            self.navigationItem.rightBarButtonItem = nil;
            self.canSelect = YES;
            self.collectionViewBottomConstraint.constant = 30+16+20;
            self.deleteBg.hidden = self.selectAllBg.hidden = NO;
            self.selectAllLabel.text = @"Select All".icanlocalized;
            self.deleteLabel.text = @"Delete".icanlocalized;
            [self.collectionView reloadData];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
        }
            break;
        case UIGestureRecognizerStateChanged:{
        }
            break;
        case UIGestureRecognizerStateEnded:{
        }
            break;
        default:
            break;
    }
}

-(void)leftBtnAction{
    self.title = @"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.leftBarButtonItem = nil;
    self.collectionViewBottomConstraint.constant = 0;
    self.deleteBg.hidden = self.selectAllBg.hidden = YES;
    self.isSelectAll = NO;
    self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
    self.canSelect = NO;
    for (NSArray *array in self.letterPhotoResultArr) {
        for (BusinessPhotoWallList *info in array) {
            info.select = NO;
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.indexArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = [self.letterPhotoResultArr objectAtIndex:section];
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessListImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBusinessListImageCollectionViewCell forIndexPath:indexPath];
    NSArray *array = [self.letterPhotoResultArr objectAtIndex:indexPath.section];
    cell.isMine = YES;
    cell.wallInfo = array[indexPath.row];
    cell.canSelect = self.canSelect;
    cell.selectBlock = ^(BusinessPhotoWallList * _Nonnull model) {
        if(model.select){
            [self.selectImageItems addObject:model];
        }else{
            [self.selectImageItems removeObject:model];
        }
        self.title = [NSString stringWithFormat:@"%@(%lu)",@"Selected".icanlocalized,(unsigned long)self.selectImageItems.count];
        self.isSelectAll = self.selectImageItems.count == self.photoWallItems.count;
        self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        YBImageBrowerTool *tool = [[YBImageBrowerTool alloc]init];
        tool.deleImgeBlock = ^(NSInteger index) {
        };
        [tool showBusinessPhotoWallImagesWith:self.photoWallItems urlArray:@[] currentIndex:indexPath.row canDelete:NO];
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

#pragma mark - UICollectionViewDataSource
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 55);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        MyPhotoWallCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyPhotoWallCollectionReusableView forIndexPath:indexPath];
        headerView.titleLabel.text = [self.indexArray objectAtIndex:indexPath.section];
        reusableview = headerView;
    }
    return reusableview;
}

- (void)pushTZImagePickerController {
    NSInteger count = 9-self.selectPhotos.count;
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
    [self.selectPhotos removeAllObjects];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeAllObjects];
    for (UIImage *image in photos) {
        UploadImgModel *model = [[UploadImgModel alloc]init];
        model.image = image;
        [self.selectPhotos addObject:model];
    }
    BusinessAddPhotoViewController *vc = [[BusinessAddPhotoViewController alloc]init];
    vc.selectPhotos = [NSMutableArray arrayWithArray:self.selectPhotos];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

#pragma mark - Networking
-(void)deleteImageRequest{
    NSMutableArray *aarray = [[NSMutableArray alloc]init];
    for (BusinessPhotoWallList *info in self.selectImageItems) {
        [aarray addObject:[NSNumber numberWithInt:info.photoWallId]];
    }
    if (self.selectImageItems.count > 0) {
        [self.photoWallItems removeObjectsInArray:self.selectImageItems];
        [self.selectImageItems removeAllObjects];
        DeleteBusinessPhotosWallRequest *request = [DeleteBusinessPhotosWallRequest request];
        request.ids = aarray.copy;
        request.parameters = [request mj_JSONObject];
        [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            self.title = @"BatchManagement".icanlocalized;
            [self.dict removeAllObjects];
            self.indexArray = @[];
            [self.letterPhotoResultArr removeAllObjects];
            if (self.photoWallItems.count == 0) {
                self.collectionViewBottomConstraint.constant = 0;
                self.deleteBg.hidden = self.selectAllBg.hidden = YES;
                self.isSelectAll = NO;
                self.canSelect = NO;
            }else{
                [self sortPhotoWallWithImageItems:self.photoWallItems];
            }
            [self.collectionView reloadData];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        }];
    }
}

-(void)fetchListRequest{
    GetBusinessPhotosWallListRequest *request = [GetBusinessPhotosWallListRequest request];
    request.size = @(self.pageSize);
    request.current = @(self.current);
    request.parameters = [request mj_JSONObject];
    if (!self.isAutoLoad) {
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    }
    @weakify(self);
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[BusinessPhotoWallListInfo class] contentClass:[BusinessPhotoWallList class] success:^(BusinessPhotoWallListInfo *response) {
        @strongify(self);
        self.isLoadMoreData = NO;
        self.isAutoLoad = NO;
        self.listInfo = response;
        [self handleFetchlistSuccess:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self endingRefresh];
        self.isAutoLoad = NO;
        self.isLoadMoreData = NO;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)refreshList{
    self.current = 1;
    self.pageSize = 20;
    [self fetchListRequest];
}

-(void)loadMore{
    if (self.listInfo.records.count == 0) {
        [self endingRefresh];
        return;
    }
    self.current++;
    [self fetchListRequest];
}

-(void)checkHasFooter{
    if (self.listInfo.records.count < 20) {
        self.collectionView.mj_footer = nil;
    }else{
        self.collectionView.mj_footer = self.footer;
        self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    }
}

-(void)sortPhotoWallWithImageItems:(NSArray*)imageArray{
    for (BusinessPhotoWallList *info in imageArray) {
        NSString *createTime = info.createTime;
        NSString *createDate = [GetTime convertDateWithString:createTime dateFormmate:@"yyyy/MM/dd"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.dict objectForKey:createDate]];
        [array addObject:info];
        [self.dict setObject:array forKey:createDate];
    }
    self.indexArray = [ self.dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj2 compare:obj1 options:NSNumericSearch];
    }];
    for (NSString *key in self.indexArray) {
        [self.letterPhotoResultArr addObject:[self.dict objectForKey:key]];
    }
}

-(void)handleFetchlistSuccess:(BusinessListInfo *)response{
    if (self.current != 1) {
        [self.photoWallItems addObjectsFromArray:response.records];
    }else{
        self.photoWallItems = [NSMutableArray arrayWithArray:response.records];
    }
    self.indexArray = @[];
    [self.letterPhotoResultArr removeAllObjects];
    [self.dict removeAllObjects];
    [self sortPhotoWallWithImageItems:self.photoWallItems];
    [self checkHasFooter];
    [self endingRefresh];
    [self.collectionView reloadData];
}

-(void)endingRefresh{
    [QMUITips hideAllTips];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - Lazy
-(NSMutableArray *)letterPhotoResultArr{
    if (!_letterPhotoResultArr) {
        _letterPhotoResultArr = [NSMutableArray array];
    }
    return _letterPhotoResultArr;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton dzButtonWithTitle:@"Add".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}

#pragma mark - Event
-(void)rightBarButtonItemAction{
    [self pushTZImagePickerController];
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

-(NSMutableArray<UploadImgModel *> *)selectPhotos{
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray array];
    }
    return _selectPhotos;
}

-(MyPhotoWallBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"MyPhotoWallBottomView" owner:self options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, isIPhoneX?30+20+16+39:30+20+16);
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        }];
    }
    return _bottomView;
}

-(NSMutableArray<BusinessPhotoWallList *> *)selectImageItems{
    if (!_selectImageItems) {
        _selectImageItems = [NSMutableArray array];
    }
    return _selectImageItems;
}
@end

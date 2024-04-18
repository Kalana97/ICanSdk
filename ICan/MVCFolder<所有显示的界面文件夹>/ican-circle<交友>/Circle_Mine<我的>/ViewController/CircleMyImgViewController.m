
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 1/7/2021
 - File name:  CircleMyImgViewController.m
 - Description:
 - Function List:
 */


#import "CircleMyImgViewController.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "CircleAddPhotoViewController.h"
#import "YBImageBrowerTool.h"
#import "UploadImgModel.h"
#import "PrivacyPermissionsTool.h"
#import <MJRefresh.h>
#import "MyPhotoWallCollectionReusableView.h"
#import "MyPhotoWallBottomView.h"
#import <TZImagePickerController.h>
@interface CircleMyImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *addImgModel;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) NSMutableArray<PhotoWallInfo*> *photoWallItems;
/// 当前是否是正在自动加载更多数据
@property (nonatomic,assign) BOOL  isLoadMoreData;
/// 是否是自动加载
@property(nonatomic, assign) BOOL isAutoLoad;
@property (nonatomic,assign) NSInteger  current;
/** 获取每页多少条数据 */
@property (nonatomic,assign) NSInteger  pageSize;
@property (nonatomic,strong) CircleListInfo * listInfo;
@property(nonatomic, strong) NSMutableDictionary *dict;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterPhotoResultArr;
/** 当前是否可以选择图片 */
@property(nonatomic,assign) BOOL canSelect;
/** 当前是否是全选状态 */
@property(nonatomic,assign) BOOL isSelectAll;
@property(nonatomic, strong) MyPhotoWallBottomView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *selectAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectAllImageView;
@property (weak, nonatomic) IBOutlet UIControl *selectAllBg;
@property (weak, nonatomic) IBOutlet UIControl *deleteBg;

@property(nonatomic, strong) NSMutableArray<PhotoWallInfo*> *selectImageItems;
/** 当前从相册选择的照片数组 */
@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectPhotos;

@property (nonatomic,strong)MJRefreshBackNormalFooter*footer;

@end

@implementation CircleMyImgViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshList];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshList) name:kCirclePhotoWallChangeNotification object:nil];
    self.footer =[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.collectionView.mj_footer=self.footer;
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    self.collectionViewBottomConstraint.constant = 0;
    self.deleteBg.hidden = self.selectAllBg.hidden = YES;
    [self refreshList];
    self.canSelect = NO;
    self.isSelectAll = NO;
    [self addRecognize];
    self.title=@"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.collectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kMyPhotoWallCollectionReusableView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyPhotoWallCollectionReusableView];
}
- (IBAction)selectAll {
    [self.selectImageItems removeAllObjects];
    self.isSelectAll = !self.isSelectAll;
    self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
    for (NSArray * array in self.letterPhotoResultArr) {
        if (self.isSelectAll) {
            [self.selectImageItems addObjectsFromArray:array];
        }
        for (PhotoWallInfo*info in array) {
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
    //设置长按响应时间为0.5秒
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
            self.deleteBg.hidden = self.selectAllBg.hidden =NO;
            [self.collectionView reloadData];
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnAction)];
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
//取消按钮
-(void)leftBtnAction{
    self.title = @"CircleMineShowUserImgTableViewCell.myPhotoLabel".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.leftBarButtonItem = nil;
    self.collectionViewBottomConstraint.constant = 0;
    self.deleteBg.hidden = self.selectAllBg.hidden = YES;
    self.isSelectAll = NO;
    self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
    self.canSelect = NO;
    for (NSArray * array in self.letterPhotoResultArr) {
        for (PhotoWallInfo*info in array) {
            info.select = NO;
        }
    }
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.indexArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray * array = [self.letterPhotoResultArr objectAtIndex:section];
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleUserDetailImgeCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleUserDetailImgeCollectionViewCell forIndexPath:indexPath];
    NSArray * array = [self.letterPhotoResultArr objectAtIndex:indexPath.section];
    cell.wallInfo = array[indexPath.row];
    cell.canSelect = self.canSelect;
    cell.selectBlock = ^(PhotoWallInfo * _Nonnull model) {
        if (model.select) {
            [self.selectImageItems addObject:model];
        }else{
            [self.selectImageItems removeObject:model];
        }
        self.title = [NSString stringWithFormat:@"%@(%lu)",@"Selected".icanlocalized,(unsigned long)self.selectImageItems.count];
        self.isSelectAll = self.selectImageItems.count==self.photoWallItems.count;
        self.selectAllImageView.image = self.isSelectAll?UIImageMake(@"mine_Photo_choice"):UIImageMake(@"mine_Photo_choice_no");
        
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.collectionView) {
        YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
        tool.deleImgeBlock = ^(NSInteger index) {
            
        };
        [tool showCirclePhotoWallImagesWith:self.photoWallItems urlArray:@[] currentIndex:indexPath.row canDelete:NO];
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    UITableViewCell*lastCell=self.collectionView.visibleCells.lastObject;
    //    NSIndexPath *last= [self.collectionView indexPathForCell:lastCell];
    //    if (self.listItems.count-last.row<5) {
    //        if (!self.isLoadMoreData) {
    //            self.isAutoLoad=YES;
    //            self.isLoadMoreData=YES;
    //            [self loadMore];
    //        }
    //    }
}
- (void)pushTZImagePickerController {
    NSInteger count = 9-self.selectPhotos.count;
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
    [self.selectPhotos removeAllObjects];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.selectPhotos removeAllObjects];
    for (UIImage*image in photos) {
        UploadImgModel*model=[[UploadImgModel alloc]init];
        model.image=image;
        [self.selectPhotos addObject:model];
    }
    CircleAddPhotoViewController * vc = [[CircleAddPhotoViewController alloc]init];
    vc.selectPhotos = [NSMutableArray arrayWithArray:self.selectPhotos];
    [self.navigationController pushViewController:vc animated:YES];
    
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
#pragma mark - Networking
-(void)deleteImageRequest{
    NSMutableArray * aarray = [[NSMutableArray alloc]init];
    for (PhotoWallInfo*info in self.selectImageItems) {
        [aarray addObject:info.photoWallId];
    }
    if (self.selectImageItems.count>0) {
        [self.photoWallItems removeObjectsInArray:self.selectImageItems];
        [self.selectImageItems removeAllObjects];
        DeletePhotosWallRequest * request =[DeletePhotosWallRequest request];
        request.ids = aarray.copy;
        request.parameters = [request mj_JSONObject];
        [[CircleNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
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
    GetPhotosWallListRequest * request = [GetPhotosWallListRequest request];
    request.size=@(self.pageSize);
    request.current=@(self.current);
    request.parameters=[request mj_JSONObject];
    if (!self.isAutoLoad) {
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    }
    @weakify(self);
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[PhotoWallListInfo class] contentClass:[PhotoWallInfo class] success:^(PhotoWallListInfo* response) {
        @strongify(self);
        self.isLoadMoreData=NO;
        self.isAutoLoad=NO;
        self.listInfo=response;
        [self handleFetchlistSuccess:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [self endingRefresh];
        self.isAutoLoad=NO;
        self.isLoadMoreData=NO;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(void)refreshList{
    self.current=1;
    self.pageSize=20;
    [self fetchListRequest];
}
-(void)loadMore{
    if (self.listInfo.records.count==0) {
        [self endingRefresh];
        return;
    }
    self.current++;
    [self fetchListRequest];
}
-(void)checkHasFooter{
    if (self.listInfo.records.count<20) {
        self.collectionView.mj_footer = nil;
    }else{
        self.collectionView.mj_footer = self.footer;
        self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX ? 34 : 0;
    }
}
-(void)sortPhotoWallWithImageItems:(NSArray*)imageArray{
    for (PhotoWallInfo*info in imageArray) {
        //1635316614000
        NSString * createTime = info.createTime;
        NSString * createDate = [GetTime convertDateWithString:createTime dateFormmate:@"yyyy/MM/dd"];
        NSMutableArray * array = [NSMutableArray arrayWithArray:[self.dict objectForKey:createDate]];
        [array addObject:info];
        [self.dict setObject:array forKey:createDate];
    }
    self.indexArray =[ self.dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj2 compare:obj1 options:NSNumericSearch];
    }];
    for (NSString*key in self.indexArray) {
        [self.letterPhotoResultArr addObject:[self.dict objectForKey:key]];
    }
}
-(void)handleFetchlistSuccess:(CircleListInfo*)response{
    if (self.current !=1) {
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
        _rightButton=[UIButton dzButtonWithTitle:@"Add".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
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
-(NSMutableArray<PhotoWallInfo *> *)selectImageItems{
    if (!_selectImageItems) {
        _selectImageItems = [NSMutableArray array];
    }
    return _selectImageItems;
}
@end

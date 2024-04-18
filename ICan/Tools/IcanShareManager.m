//
//  UMShareManager.m
//  CaiHongApp
//
//  Created by lidazhi on 2019/5/27.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import "ShareManager.h"
static  NSString * const  KIDShareViewCell=@"ShareViewCell";

@interface ShareViewCell:UICollectionViewCell
@property (nonatomic,strong) NSDictionary * typeDict;
@property (nonatomic,strong) UILabel * typeLabel;
@property (nonatomic,strong) UIImageView * typeImageView;
@end
@implementation ShareViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        
    }];
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.typeImageView.mas_centerX);
        make.top.equalTo(self.typeImageView.mas_bottom).offset(5);
        make.height.equalTo(@25);
        //        make.width.equalTo(@40);
    }];
}
-(void)setTypeDict:(NSDictionary *)typeDict{
    self.typeLabel.text=typeDict[@"title"];
    self.typeImageView.image=[UIImage imageNamed:typeDict[@"image"]];
    //    CGFloat width=[NSString widthForString:typeDict[@"title"] withFont:[UIFont systemFontOfSize:13] height:25];
    //    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.typeImageView.mas_centerX);
    //        make.top.equalTo(self.typeImageView.mas_bottom).offset(5);
    //        make.height.equalTo(@25);
    //        make.width.equalTo(@(width+20));
    //    }];
}
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel=[UILabel centerLabelWithTitle:NSLocalizedString(@"CopyURL", 复制链接) font:13 color:UIColor252730Color];
        //        _typeLabel.backgroundColor=[UIColor whiteColor];
        //        [_typeLabel layerWithCornerRadius:12.5 borderWidth:0 borderColor:nil];
    }
    return _typeLabel;
}
-(UIImageView *)typeImageView{
    if (!_typeImageView) {
        _typeImageView=[[UIImageView alloc]init];
        _typeImageView.userInteractionEnabled=YES;
        [_typeImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
        
    }
    return _typeImageView;
}
@end
@interface ShareView()<UICollectionViewDelegate,UICollectionViewDataSource>
/***/
@property (nonatomic,strong,nullable) UIButton * cancleButton;
@property (nonatomic,strong)  UIView * contentView;
@property (nonatomic,strong)  UICollectionView * collectionView;
@property (nonatomic,strong)  UIView * bottomView;


@property (nonatomic,strong)  UIButton * bgButton;


@end

@implementation ShareView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupView];
        [self.collectionView becomeFirstResponder];
        
        
    }
    return self;
}
-(void)setTypeArray:(NSArray *)typeArray{
    _typeArray=typeArray;
    [self.collectionView reloadData];
}
-(void)setupView{
    
    [self addSubview:self.bgButton];
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-(isIPhoneX?83:49)));
    }];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(isIPhoneX?83:49));
    }];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@110);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@44);
    }];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
-(void)hiddenShareView{
    
    [self removeFromSuperview];
}
-(void)showShareView{
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
-(UIButton *)bgButton{
    if (!_bgButton) {
        _bgButton=[[UIButton alloc]init];
        _bgButton.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
        [_bgButton addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=UIColorBg243Color;
    }
    return _contentView;
}
-(UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton=[UIButton functionButtonWithTitle:@"UIAlertController.cancel.title".icanlocalized image:nil backgroundColor:UIColor.whiteColor titleFont:16 target:self action:@selector(hiddenShareView)];
        [_cancleButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    }
    return _cancleButton;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]init];
        _bottomView.backgroundColor=[UIColor whiteColor];
    }
    return _bottomView;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.backgroundColor                 = [UIColor clearColor];
        [_collectionView registClassWithClassName:KIDShareViewCell];
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:KIDShareViewCell forIndexPath:indexPath];
    cell.typeDict=self.typeArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.didselectItem?:self.didselectItem(indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70,110);
    
}
@end
@interface IcanShareManager ()


@end

@implementation IcanShareManager
+(instancetype)sharedManager{
    static IcanShareManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IcanShareManager alloc]init];
        
    });
    return manager;
    
}
-(void)ftShareThumImage:(UIImage*)thumImage sharingChannels:(NSArray*)sharingChannels{
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData =  UIImageJPEGRepresentation(thumImage, 1);;
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
//    if (self.shareView) {
//        self.shareView=nil;
//    }
    self.shareView=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    self.shareView.typeArray = sharingChannels;
    @weakify(self);
    self.shareView.didselectItem = ^(NSInteger index) {
        @strongify(self);
        
        if (index==0) {
            req.scene = WXSceneSession;
            [self sendWXReq:req];
        }else if(index==1){
            req.scene = WXSceneTimeline;
            [self sendWXReq:req];
            
        }else if (index==2){
            !self.tapIndexBlock?:self.tapIndexBlock(index);
        }
        
        [self.shareView hiddenShareView];
        self.shareView=nil;
    };
    [self.shareView showShareView];
}
-(void)ftShareThumImage:(UIImage*)thumImage{
    
    
}
-(void)sendWXReq:(BaseReq*)req{
    //[WXApi sendReq:req ];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
-(void)ftShareWebpageUrl:(NSString*)webpageUrl title:(NSString* )title des:(NSString* _Nullable )des thumImage:(NSString*_Nullable)thumImage thumbData:(NSData*_Nullable)thumbData image:(UIImage*_Nullable)image{
    if (self.shareView) {
        self.shareView=nil;
    }
    WXWebpageObject *imageObject = [WXWebpageObject object];
    imageObject.webpageUrl=webpageUrl;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    if (thumbData) {
        message.thumbData = [UIImage compressImageSize:[UIImage imageWithData:thumbData] toByte:32*1024];
    }else if (image){
        message.thumbData =[UIImage compressImageSize:image toByte:32*1024];
//        [message setThumbImage:[UIImage imageWithData:]];
    }
    
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    self.shareView=[[ShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.shareView.typeArray=@[@{@"image":@"icon_share_wechat_user",@"title":@"WeChat".icanlocalized},@{@"image":@"icon_share_wechat_moments",@"title":@"friend.detail.listCell.Moments".icanlocalized},@{@"image":@"icon_share_LOGO",@"title":@"我行"}];;
    @weakify(self);
    self.shareView.didselectItem = ^(NSInteger index) {
        @strongify(self);
        if (index==0) {
            req.scene = WXSceneSession;
            [self sendWXReq:req];
        }else if(index==1){
            req.scene = WXSceneTimeline;
           [self sendWXReq:req];
        }else if (index==2){
            !self.tapIndexBlock?:self.tapIndexBlock(index);
        }
        
        
        [self.shareView hiddenShareView];
        self.shareView=nil;
    };
    [self.shareView showShareView];
    
}


@end

//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 24/11/2021
 - File name:  C2CComplaintOrderViewController.m
 - Description:
 - Function List:
 */


#import "C2CComplaintOrderViewController.h"
#import "SelectBuyerComplaintPopView.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "CircleUserDetailImgeCollectionViewCell.h"
#import "YBImageBrowerTool.h"
#import "UploadImgModel.h"
#import "HWProgressView.h"
#import "C2COssWrapper.h"
#import "UIViewController+Extension.h"
#import "DZAVPlayerViewController.h"
@interface C2CComplaintOrderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipsLab1;

@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet QMUITextField *reasonTextField;

@property (weak, nonatomic) IBOutlet UILabel *describeLab;
@property (weak, nonatomic) IBOutlet QMUITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;


@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UILabel *addTipsLab;
///视频
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteVideoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoWidthConstraint;

///图片张数
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet QMUITextField *contactTextField;

@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property(nonatomic, strong) NSMutableArray<UploadImgModel*> *selectPhotos;
//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *addImgModel;
///本地视频地址、
@property(nonatomic, copy)    NSURL * saveUrlPath;
@property(nonatomic, strong)  HWProgressView *hProgressView;
@property(nonatomic, copy) NSString *reasonId;
@property(nonatomic, copy) NSString *videoOssUrl;
@property(nonatomic, copy) NSString *videoOssImgUrl;
@property(nonatomic, copy) NSMutableArray *evidenceItems;
@end

@implementation C2CComplaintOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Appeal".icanlocalized;
    self.tipsLab1.text = @"AppealTips".icanlocalized;
    self.reasonLab.text = @"ReasonForAppeal".icanlocalized;
    self.reasonTextField.placeholder = @"SelectAppealReason".icanlocalized;
    self.describeLab.text = @"DescriptionOfRepresentation".icanlocalized;
    self.describeTextView.placeholder = @"Completelypossible".icanlocalized;
    self.addLab.text = @"AddCredentials".icanlocalized;
    self.addTipsLab.text = @"AddCredentialsTips".icanlocalized;
    self.videoLabel.text = @"C2CVideo".icanlocalized;
    self.contactLab.text = @"C2CContact".icanlocalized;
    self.contactTextField.placeholder = @"PleaseEnterAContact".icanlocalized;
    self.mobileLab.text = @"ContactNumber".icanlocalized;
    self.mobileTextField.placeholder = @"PleaseEnterContactNumber".icanlocalized;
    [self.complaintBtn setTitle:@"IwantToAppeal".icanlocalized forState:UIControlStateNormal];
    [self.collectionView registNibWithNibName:kCircleUserDetailImgeCollectionViewCell];
    self.videoWidthConstraint.constant = (ScreenWidth-60)/3.0;
    self.addImgModel=[[UploadImgModel alloc]init];
    self.addImgModel.image=UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd=YES;
    if (self.orderInfo.adOrderAppeal) {
        self.reasonId = self.orderInfo.adOrderAppeal.reason;
        self.reasonTextField.text = self.orderInfo.adOrderAppeal.reason.icanlocalized;
        self.describeTextView.text = self.orderInfo.adOrderAppeal.Description;
        self.contactTextField.text = self.orderInfo.adOrderAppeal.contact;
        self.mobileTextField.text  = self.orderInfo.adOrderAppeal.contactNumber;
        NSMutableArray * allMediaItems = [NSMutableArray arrayWithArray:[self.orderInfo.adOrderAppeal.evidence componentsSeparatedByString:@","]];
        NSArray * videoItems = [allMediaItems.lastObject componentsSeparatedByString:@" "];
        ///证明有视频
        if (videoItems.count==2) {
            [self.videoImgView setImageWithString:videoItems.firstObject placeholder:nil];
            [allMediaItems removeLastObject];
        }
        for (NSString * imgUrl in allMediaItems) {
            UploadImgModel*model=[[UploadImgModel alloc]init];
            model.ossImgUrl = imgUrl;
            [self.selectPhotos addObject:model];
        }
        if (self.selectPhotos.count!=5) {
            [self.selectPhotos addObject:self.addImgModel];
        }
        if (BaseSettingManager.isChinaLanguages) {
            self.imageCountLabel.text=[NSString stringWithFormat:@"图片（%zd/5）张",self.selectPhotos.count];
        }else{
            self.imageCountLabel.text=[NSString stringWithFormat:@"(%zd/5) pictures",self.selectPhotos.count];
        }
    }else{
        
        if (BaseSettingManager.isChinaLanguages) {
            self.imageCountLabel.text=[NSString stringWithFormat:@"图片（%zd/5）张",self.selectPhotos.count];
        }else{
            self.imageCountLabel.text=[NSString stringWithFormat:@"(%zd/5) pictures",self.selectPhotos.count];
        }
        
        if (self.selectPhotos.count!=5) {
            [self.selectPhotos addObject:self.addImgModel];
        }
    }
    [self updateView];
}
- (IBAction)selectReasonAction {
    if (!self.orderInfo.adOrderAppeal) {
        SelectBuyerComplaintPopView * view  =[SelectBuyerComplaintPopView showBuyerComplaintView];
        if (self.orderInfo.buyUserId == C2CUserManager.shared.userId.integerValue) { ///联系卖家 我是买家
            
            
        }else{///联系买家 我是卖家
            view.isSeller = YES;
        }
        view.tapBblock = ^(NSString * _Nonnull reason) {
            self.reasonId = reason;
            self.reasonTextField.text = reason.icanlocalized;
        };
    }
    
    
}
- (IBAction)deleteVideoBtnAction {
    if (!self.orderInfo.adOrderAppeal) {
        self.deleteVideoBtn.hidden = YES;
        self.videoImgView.image = UIImageMake(@"icon_appeal_video");
        self.videoOssUrl = nil;
    }
    
}

- (IBAction)videoBtnAction {
    if (!self.orderInfo.adOrderAppeal) {
        if (!self.deleteVideoBtn.isHidden) {
            DZAVPlayerViewController * vc = [[DZAVPlayerViewController alloc]init];
            [vc setPlayUrl:self.saveUrlPath aVPlayerViewType:AVPlayerViewTimelinesPostMessage];
            vc.delectBlock = ^{
                self.videoImgView.image = UIImageMake(@"icon_appeal_video");
                self.deleteVideoBtn.hidden = YES;
                self.videoOssUrl = nil;
                self.saveUrlPath = nil;
            };
            [self.view endEditing:YES];
        }else{
            [self selectOnlyVideoPickFromeTZImagePicker];
        }
    }
    
    
}


- (IBAction)complaintAction {
    
    if (!self.reasonId) {
        [QMUITipsTool showOnlyTextWithMessage:@"SelectAppealReason".icanlocalized inView:self.view];
        return;
    }
    if (self.contactTextField.text.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"PleaseEnterAContact".icanlocalized inView:self.view];
        return;
    }
    if (self.mobileTextField.text.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"PleaseEnterContactNumber".icanlocalized inView:self.view];
        return;
    }
    if (self.describeTextView.text.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"PleaseFillInformation".icanlocalized inView:self.view];
        return;
    }
    NSInteger count ;
    if ([self.selectPhotos containsObject:self.addImgModel]) {
        count=5-self.selectPhotos.count+1;
    }else{
        count=5-self.selectPhotos.count;
    }
    //        count==5说明一张图片都没有
    if (!self.videoOssUrl&&count==5) {
        [QMUITipsTool showOnlyTextWithMessage:@"PleaseAddCredentials".icanlocalized inView:self.view];
        return;
    }
    if (self.videoOssUrl) {
        NSString * video = [NSString stringWithFormat:@"%@ %@",self.videoOssImgUrl,self.videoOssUrl];
        [self.evidenceItems addObject:video];
    }
    C2CPostOrderAppealRequest * request = [C2CPostOrderAppealRequest request];
    request.reason = self.reasonId;
    if (self.evidenceItems.count>0) {
        request.evidence = [self.evidenceItems componentsJoinedByString:@","];
    }
    request.adOrderId = self.orderInfo.adOrderId;
    request.contact = self.contactTextField.text;
    request.contactNumber = self.mobileTextField.text;
    request.Description = self.describeTextView.text;
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CBaseResponse class] contentClass:[C2CBaseResponse class] success:^(id  _Nonnull response) {
        [self removeVcWithArray:@[@"C2CPConfirmOrderViewController",@"C2CPaymentViewController",@"C2CCancelOrderViewController",@"C2CConfirmReceiptMoneyViewController",@"C2CSaleSuccessViewController",@"C2COptionalSaleViewController",@"C2CBuyerQuestionViewController"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kC2CRefreshOrderListNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
    
}
-(void)updateView{
    [self.collectionView reloadData];
    [self.collectionView layoutSubviews];
    [self.collectionView layoutIfNeeded];
    self.collectionViewHeight.constant=self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}
-(void)textViewDidChange:(UITextView *)textView{
    self.countLab.text = [NSString stringWithFormat:@"(%lu/500)",textView.text.length];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
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
        if (BaseSettingManager.isChinaLanguages) {
            self.imageCountLabel.text=[NSString stringWithFormat:@"图片（%zd/5）张",self.selectPhotos.count];
        }else{
            self.imageCountLabel.text=[NSString stringWithFormat:@"(%zd/5) pictures",self.selectPhotos.count];
        }
        [self.selectPhotos addObject:self.addImgModel];
        [self updateView];
    };
    //    if (self.orderInfo.adOrderAppeal) {
    //        cell.deletBtn.hidden = YES;
    //    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgModel*model=[self.selectPhotos objectAtIndex:indexPath.row];
    if (model.isAdd) {
        [self selectOnlyPhotoPickFromeTZImagePicker];
    }else{
        YBImageBrowerTool*tool=[[YBImageBrowerTool alloc]init];
        tool.deleImgeBlock = ^(NSInteger index) {
            [self.selectPhotos removeObjectAtIndex:index];
            [self.selectPhotos removeObject:self.addImgModel];
            if (BaseSettingManager.isChinaLanguages) {
                self.imageCountLabel.text=[NSString stringWithFormat:@"图片（%zd/5）张",self.selectPhotos.count];
            }else{
                self.imageCountLabel.text=[NSString stringWithFormat:@"(%zd/5) pictures",self.selectPhotos.count];
            }
            [self.self.selectPhotos addObject:self.addImgModel];
            [self updateView];
        };
        NSMutableArray*array=[NSMutableArray arrayWithArray:self.selectPhotos];
        [array removeObject:self.addImgModel];
        [tool showCircleUserImagesWith:array urlArray:@[] currentIndex:indexPath.row canDelete:!self.orderInfo.adOrderAppeal];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-65)/3.0,(ScreenWidth-65)/3.0);
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
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
-(void)selectOnlyVideoPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureOrVideoInTimeLinesWithTarget:self maxCount:1 minCount:1 canSelectVide:YES canSelectPhoto:NO pickingPhotosHandle:nil didFinishPickingPhotosWithInfosHandle:nil cancelHandle:^{
            
        } pickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            self.videoBtn.hidden = NO;
            self.deleteVideoBtn.hidden = NO;
            self.videoImgView.image = coverImage;
            PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            options.networkAccessAllowed = YES;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                NSNumber *size;
                [videoAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                self.saveUrlPath = videoAsset.URL;
                if (([size floatValue]/(1024.0*1024.0))>5.00) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hProgressView.hidden = NO;
                    });
                    @weakify(self);
                    [[UIImagePickerHelper sharedManager]startExportVideoWithVideoAsset:videoAsset preset:4 outputPath:nil exportProgress:^(float progress) {
                        @strongify(self);
                        self.hProgressView.progress = progress;
                    } success:^(NSString * _Nonnull outputPath) {
                        @strongify(self);
                        self.hProgressView.hidden = YES;
                        self.saveUrlPath = [NSURL fileURLWithPath:outputPath];
                        [self uploadVideo];
                    } failure:^(NSString * _Nonnull errorMessage, NSError * _Nullable error) {
                        @strongify(self);
                        self.hProgressView.hidden = YES;
                        if ([errorMessage isEqualToString:@"Failed"]) {
                            [QMUITipsTool showErrorWihtMessage:@"Video export failed, please upload again".icanlocalized inView:self.view];
                            
                        }
                    }];
                }else{
                    [self uploadVideo];
                }
            }];
            
            
        } pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
    
}


-(void)selectOnlyPhotoPickFromeTZImagePicker{
    NSInteger count;
    if ([self.selectPhotos containsObject:self.addImgModel]) {
        count=5-self.selectPhotos.count+1;
    }else{
        count=5-self.selectPhotos.count;
    }
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureOrVideoInTimeLinesWithTarget:self maxCount:count minCount:1 canSelectVide:NO canSelectPhoto:YES pickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [QMUITips hideAllTips];
            [self.selectPhotos removeObject:self.addImgModel];
            for (UIImage*image in photos) {
                UploadImgModel*model=[[UploadImgModel alloc]init];
                model.image=image;
                [self.selectPhotos addObject:model];
            }
            if (BaseSettingManager.isChinaLanguages) {
                self.imageCountLabel.text=[NSString stringWithFormat:@"图片（%zd/5）张",self.selectPhotos.count];
            }else{
                self.imageCountLabel.text=[NSString stringWithFormat:@"(%zd/5) pictures",self.selectPhotos.count];
            }
            if (self.selectPhotos.count!=5) {
                [self.selectPhotos addObject:self.addImgModel];
            }
            [self updateView];
            [self uploadImage];
            
        } didFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
            [QMUITips hideAllTips];
        } cancelHandle:^{
            [QMUITips hideAllTips];
            
        } pickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            
            
        } pickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
            [QMUITips hideAllTips];
            
        }];
        
    } failure:^{
        
    }];
    
    
}
-(void)uploadImage{
    
    [[C2COssWrapper shared]uploadC2CComplaintImagesWithModels:self.selectPhotos successHandler:^(NSArray<UploadImgModel*> *  imgModels) {
        NSArray*imageurl= [imgModels valueForKeyPath:@"ossImgUrl"];
        [self.evidenceItems addObjectsFromArray:imageurl];
    }];
}
-(void)uploadVideo{
    [[C2COssWrapper shared]startUploadC2CCComplaintVideoWith:self.videoImgView.image imageFailure:^(NSError * error) {
        
    } videoFailure:^(NSError * error) {
        
    } videoUrl:self.saveUrlPath videoUploadProgress:^(float progress) {
        
    } success:^(NSString * _Nonnull imageUrl, NSString * _Nonnull videoUrl, NSString * _Nonnull videoOssPath) {
        self.videoOssUrl = videoUrl;
        self.videoOssImgUrl = imageUrl;
    }];
}
-(HWProgressView *)hProgressView{
    if (!_hProgressView) {
        _hProgressView = [[HWProgressView alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
        _hProgressView .center = self.view.center;
        [self.view addSubview:_hProgressView];
        _hProgressView.hidden = YES;
    }
    return _hProgressView;
}
-(NSMutableArray<UploadImgModel *> *)selectPhotos{
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray array];
    }
    return _selectPhotos;
}
-(NSMutableArray *)evidenceItems{
    if (!_evidenceItems) {
        _evidenceItems = [NSMutableArray array];
    }
    return _evidenceItems;
}
@end

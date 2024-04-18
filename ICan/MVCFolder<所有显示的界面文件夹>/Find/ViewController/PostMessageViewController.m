//
//  PostMessageViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//  发布帖子

#import "PostMessageViewController.h"
#import "PostMessageLimitViewController.h"
#import "SelectTimelineMembersViewController.h"
#import "SelectAtTimelineTableViewController.h"
#import "TypeTimelinesViewController.h"
#import "PostMessageBottomView.h"
#import "UIImagePickerHelper.h"
#import "OSSWrapper.h"
#import "PrivacyPermissionsTool.h"
#import "SaveViewManager.h"
#import "YBImageBrowerTool.h"
#import "TZImageManager.h"
#import "DZFileManager.h"
#import "OSSWrapper.h"
#import "DZCircleView.h"
#import "HWProgressView.h"
#import "DZProgressCircleView.h"
#import "EmojyShowView.h"
#import "UploadImgModel.h"
#import "ChatViewHandleTool.h"
#import "HXPhotoPicker.h"
#import "DZAVPlayerViewController.h"
#import "SelectMKMapLocationViewController.h"

@interface PostMessageViewController()<PostMessageLimitViewControllerDelegate,QMUITextViewDelegate>
@property(nonatomic,weak)  IBOutlet DZIconImageView * iconImageView;
@property(nonatomic,weak)  IBOutlet UILabel * nameLabel;
@property(nonatomic,weak)  IBOutlet UILabel * visibleRangeLab;
@property(nonatomic,weak)  IBOutlet UIControl  * visibleRangeBgView;
@property(nonatomic,weak)  IBOutlet UILabel * addressLab;
@property(nonatomic,weak)  IBOutlet QMUITextView  * textView;
@property(weak,nonatomic)  IBOutlet NSLayoutConstraint *textViewHeight;


//第一张照片
@property(nonatomic,weak)  IBOutlet UIView * firstBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * firstImageView;
@property(weak,nonatomic)  IBOutlet NSLayoutConstraint *firstImageViewHeight;
@property(nonatomic,weak)  IBOutlet UIImageView * playIcon;
//第二组照片
@property(nonatomic,weak)  IBOutlet UIView * secondBgView;
@property(weak,nonatomic)  IBOutlet UIImageView *secondOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * secondTwoImageView;
//第三组照片
@property(nonatomic,weak)  IBOutlet UIView * thirdBgView;
@property(weak,nonatomic)  IBOutlet UIImageView *thirdOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * thirdTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * thirdThreeImageView;
//第四组照片
@property(nonatomic,weak)  IBOutlet UIView * fourthBgView;
@property(weak,nonatomic)  IBOutlet UIImageView *fourthOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthThreeImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthFourImageView;
//第五组照片
@property(nonatomic,weak)  IBOutlet UIView * fifthBgView;
@property(weak,nonatomic)  IBOutlet UIImageView *fifthOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthThreeImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthFourImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthFiveImageView;

@property(nonatomic,weak)  IBOutlet UIView * coverView;
@property(nonatomic,weak)  IBOutlet UILabel * numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet EmojyShowView *emojyShowView;
@property (weak, nonatomic) IBOutlet UIView *postBottomView;

@property (weak, nonatomic) IBOutlet UIImageView *cameraImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *emojyImgView;
@property (weak, nonatomic) IBOutlet UIImageView *atImgView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImgView;
@property(nonatomic, strong) NSMutableArray * imageItems;


@property(nonatomic, copy)   NSString *fileVideoUrl;
@property(nonatomic, copy)   NSString *originalVideoHash;

@property(nonatomic, strong)  YBImageBrowerTool *ybImageBrowerTool;

@property(nonatomic, copy)    NSURL * saveUrlPath;
@property(nonatomic, copy)    NSString * visibleRange;
//提醒看的人
@property(nonatomic, strong)  NSMutableArray * reminders;
//部分朋友可见
@property(nonatomic, strong)  NSMutableArray <UserMessageInfo *>* specifies;
//屏蔽的人
@property(nonatomic, strong)  NSMutableArray <UserMessageInfo *>* shields;

@property(nonatomic, strong)  LocationInfo * locationInfo;

@property(nonatomic, strong)  UIButton * rightBtn;

@property(nonatomic, strong)  DZProgressCircleView *progressView;
@property(nonatomic, strong)  HWProgressView *hProgressView;
/** 当前是否是视频转码过程 */
@property(nonatomic, assign) BOOL isExportVideo;
//发图片的时候不能选择视频
@property(nonatomic, assign) BOOL canSelectViedo;
/** 存在视频 */
@property(nonatomic, assign) BOOL isExistedVideo;
/** 服务器是否存在该视频 */
@property(nonatomic, assign) BOOL remoteHaveVideo;
/** 是否正在上传 */
@property(nonatomic, assign) BOOL isUploading;

@property(nonatomic, strong)  NSMutableArray<OSSWrapper*> *ossRequestClinetArr;
@property(nonatomic, strong) HXPhotoManager *photoManager;
@end

@implementation PostMessageViewController

-(void)dealloc{
    DDLogInfo(@"%s",__func__);
}
- (IBAction)visibleRangeAction {
    if (self.postMessageType==TimeLinesFriendCrile) {
        PostMessageLimitViewController * vc =[PostMessageLimitViewController new];
        vc.delegate =self;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
-(void)setCurrentTitleWith:(NSString *)title{
    NSString * leftIconImageString;
    NSString*string=@"Public".icanlocalized;
    if ([title isEqualToString:@"Open"]) {
        leftIconImageString = @"icon_timeline_post_setting_open";
        string = @"Public".icanlocalized;
    }else if ([title isEqualToString:@"AllFriend"]){
        leftIconImageString = @"icon_timeline_post_setting_friend";
        string = @"timeline.limit.tip.friend".icanlocalized;
    }else if ([title isEqualToString:@"ExceptSomeFriends"]){
        
        leftIconImageString = @"icon_timeline_post_setting_except";
        string = [@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"];
        
        
    }else if ([title isEqualToString:@"SomeFriends"]){
        
        leftIconImageString = @"icon_timeline_post_setting_appoint";
        
        string= [@"timeline.limit.tip.designatedFriends" icanlocalized:@"指定好友"];
    }else{
        
        leftIconImageString = @"icon_timeline_post_setting_myself";
        string =  [@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"];;
    }
    NSAttributedString*nullString= [[NSAttributedString alloc]initWithString:@" "];
    NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithAttributedString:nullString];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    textAttachment.image = [UIImage imageNamed:leftIconImageString];
    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
    textAttachment.bounds = CGRectMake(0, 0, 11 , 11);
    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [att appendAttributedString:imageStr];
    [att appendAttributedString:nullString];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:string]];
    NSTextAttachment *righttextAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    righttextAttachment.image = [UIImage imageNamed:@"icon_posttimeline_arrow_down"];
    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
    righttextAttachment.bounds = CGRectMake(0,0, 8 , 8);
    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
    NSAttributedString *rightimageStr = [NSAttributedString attributedStringWithAttachment:righttextAttachment];
    [att appendAttributedString:nullString];
    [att appendAttributedString:rightimageStr];
    [att appendAttributedString:nullString];
    self.visibleRangeLab.attributedText = att;
}
- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height{
    if (self.textViewHeight.constant < height) {
        self.textViewHeight.constant = height;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.cameraImgView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.photoImgView addGestureRecognizer:tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.emojyImgView addGestureRecognizer:tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.atImgView addGestureRecognizer:tap4];
    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.locationImgView addGestureRecognizer:tap5];
    [self.emojyShowView setSendButtonHidden:YES];
    @weakify(self);
    self.emojyShowView.selectEmojyBlock = ^(NSString * _Nonnull text) {
        @strongify(self);
        [self insertStringWithCursorText:self.textView emoji:text];
    };
    self.emojyShowView.deleteBlock = ^{
        @strongify(self);
        [self deletetStringWithCursorText:self.textView];
        
    };
    [self.visibleRangeBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor153Color];
    self.nameLabel.text = UserInfoManager.sharedManager.nickname;
    [self.iconImageView setDZIconImageViewWithUrl:UserInfoManager.sharedManager.headImgUrl gender:UserInfoManager.sharedManager.gender];
    [self.iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
    
    self.firstBgView.hidden = self.secondBgView.hidden = self.thirdBgView.hidden = self.fourthBgView.hidden = self.fifthBgView.hidden = YES;
    self.textView.placeholder = @"What's on your mind...".icanlocalized;
    
    self.textView.delegate = self;
    self.textViewHeight.constant = 100;
    UITapGestureRecognizer * imageTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap10 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap12 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap13 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap14 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    UITapGestureRecognizer * imageTap15 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)];
    [self.firstImageView addGestureRecognizer:imageTap1];
    [self.secondOneImageView addGestureRecognizer:imageTap2];
    [self.secondTwoImageView addGestureRecognizer:imageTap3];
    [self.thirdOneImageView addGestureRecognizer:imageTap4];
    [self.thirdTwoImageView addGestureRecognizer:imageTap6];
    [self.thirdThreeImageView addGestureRecognizer:imageTap7];
    [self.fourthOneImageView addGestureRecognizer:imageTap5];
    [self.fourthTwoImageView addGestureRecognizer:imageTap8];
    [self.fourthThreeImageView addGestureRecognizer:imageTap9];
    [self.fourthFourImageView addGestureRecognizer:imageTap10];
    [self.fifthOneImageView addGestureRecognizer:imageTap11];
    [self.fifthTwoImageView addGestureRecognizer:imageTap12];
    [self.fifthThreeImageView addGestureRecognizer:imageTap13];
    [self.fifthFourImageView addGestureRecognizer:imageTap14];
    [self.fifthFiveImageView addGestureRecognizer:imageTap15];
    
    self.title =@"Create a post".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.canSelectViedo = YES;
    [IQKeyboardManager sharedManager].enable=YES;
    if (self.postMessageType==TimeLinesFriendCrile) {
        self.visibleRange = @"AllFriend";
        [self setCurrentTitleWith:@"AllFriend"];
    }else{
        self.visibleRange = @"Open";
        [self setCurrentTitleWith:@"Open"];
    }
    self.isUploading   = NO;
    self.isExportVideo = NO;
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger index=tap.view.tag;
    switch (index) {
        case 300:
            [self choseFunctionWith:PostMessageFunctionType_photograph];
            break;
        case 301:
            [self choseFunctionWith:PostMessageFunctionType_image];
            
            break;
        case 302:
            self.postBottomView.hidden = YES;
            [self choseFunctionWith:PostMessageFunctionType_face];
            
            break;
        case 303:
            [self choseFunctionWith:PostMessageFunctionType_atUser];
            
            break;
        case 304:
            [self choseFunctionWith:PostMessageFunctionType_location];
            
            break;
        default:
            break;
    }
    
}
-(void)imageAction:(UITapGestureRecognizer *)tap{
    if (self.isExistedVideo) {
        [self showVideo];
    }else{
        [self showPhotoWithIndex:tap.view.tag];
    }
    
}
-(void)updateShowImageView{
    if (self.imageItems.count ==0 ) {
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
        
    }else if (self.imageItems.count == 1 ) {
        UIImage * image = self.imageItems[0];
        self.firstImageView.image = self.imageItems[0];
        self.firstBgView.hidden =NO;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
        if (self.isExistedVideo) {
            self.playIcon.hidden = NO;
        }
        CGFloat oneImageHeight=(image.size.height/(image.size.width*1.0f))*ScreenWidth;
        if (oneImageHeight>=ScreenHeight-NavBarHeight-TabBarHeight) {
            oneImageHeight=ScreenHeight-NavBarHeight-TabBarHeight-150;
        }
        self.firstImageViewHeight.constant = oneImageHeight;
    }else if (self.imageItems.count == 2 ) {
        self.secondOneImageView.image = self.imageItems[0];
        self.secondTwoImageView.image = self.imageItems[1];
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = NO;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (self.imageItems.count == 3 ) {
        self.thirdOneImageView.image = self.imageItems[0];
        self.thirdTwoImageView.image = self.imageItems[1];
        self.thirdThreeImageView.image = self.imageItems[2];
        
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = NO;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (self.imageItems.count == 4 ) {
        self.fourthOneImageView.image = self.imageItems[0];
        self.fourthTwoImageView.image = self.imageItems[1];
        self.fourthThreeImageView.image = self.imageItems[2];
        self.fourthFourImageView.image = self.imageItems[3];
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = NO;
        self.fifthBgView.hidden = YES;
    }else {
        self.fifthOneImageView.image = self.imageItems[0];
        self.fifthTwoImageView.image = self.imageItems[1];
        self.fifthThreeImageView.image = self.imageItems[2];
        self.fifthFourImageView.image = self.imageItems[3];
        self.fifthFiveImageView.image = self.imageItems[4];
        
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"+%lu",self.imageItems.count-5];
        self.coverView.hidden = self.imageItems.count<6;
        self.numberLabel.hidden = self.imageItems.count<6;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([UIImagePickerHelper sharedManager].timer) {
        dispatch_source_cancel([UIImagePickerHelper sharedManager].timer);
    }
    if ([UIImagePickerHelper sharedManager].exportSession) {
        [[UIImagePickerHelper sharedManager].exportSession cancelExport];
        [UIImagePickerHelper sharedManager].exportSession=nil;
    }
    if ([UIImagePickerHelper sharedManager].lfaexportSession) {
        [[UIImagePickerHelper sharedManager].lfaexportSession cancelExport];
        [UIImagePickerHelper sharedManager].lfaexportSession=nil;
    }
    //取消当前正在上传的oss请求
    for (OSSWrapper*wrapper in self.ossRequestClinetArr) {
        for (OSSPutObjectRequest*request in wrapper.requestArray) {
            [request cancel];
        }
    }
    
    
}
-(void)keyboardWillShow:(NSNotification *)noti{
    //获取键盘的高度
    NSDictionary*userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.bottomViewHeight.constant = [value CGRectValue].size.height;
    self.emojyShowView.hidden = YES;
    self.postBottomView.hidden = NO;
    [self hiddenFaceView];
}
-(void)keyboardDidShow:(NSNotification *)noti{
    [self hiddenFaceView];
}
-(void)keyboardDidHide:(NSNotification *)noti{
    self.emojyShowView.hidden = YES;
    self.postBottomView.hidden = NO;
    self.bottomViewHeight.constant = isIPhoneX?34:0;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddenFaceView];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hiddenFaceView];
    [self.view endEditing:YES];
}
- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _photoManager.configuration.type = HXConfigurationTypeWXMoment;
        _photoManager.configuration.openCamera = NO;
        _photoManager.configuration.photoMaxNum = 9;
        _photoManager.configuration.videoMaxNum = 1;
        _photoManager.configuration.maxNum = 9;
        _photoManager.configuration.lookLivePhoto = NO;
        //是否允许图片和视频一起获取
        _photoManager.configuration.selectTogether = NO;
        _photoManager.configuration.lookLivePhoto = NO;
        _photoManager.configuration.videoCanEdit=NO;
        _photoManager.configuration.videoMaximumSelectDuration=60*15;
        
    }
    return _photoManager;
}
-(void)selectOnlyVideoPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureOrVideoInTimeLinesWithTarget:self maxCount:1 minCount:1 canSelectVide:YES canSelectPhoto:NO pickingPhotosHandle:nil didFinishPickingPhotosWithInfosHandle:nil cancelHandle:^{
            
        } pickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            self.isExistedVideo = YES;
            [self.imageItems addObject:coverImage];
            [self updateShowImageView];
            
            PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            options.networkAccessAllowed = YES;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                NSNumber *size;
                [videoAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                self.saveUrlPath = videoAsset.URL;
                if (([size floatValue]/(1024.0*1024.0))>5.00) {
                    self.isExportVideo = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hProgressView.hidden = NO;
                    });
                    @weakify(self);
                    [[UIImagePickerHelper sharedManager]startExportVideoWithVideoAsset:videoAsset preset:4 outputPath:nil exportProgress:^(float progress) {
                        @strongify(self);
                        self.hProgressView.progress = progress;
                    } success:^(NSString * _Nonnull outputPath) {
                        @strongify(self);
                        self.isExportVideo = NO;
                        self.hProgressView.hidden = YES;
                        self.saveUrlPath = [NSURL fileURLWithPath:outputPath];
                        
                    } failure:^(NSString * _Nonnull errorMessage, NSError * _Nullable error) {
                        @strongify(self);
                        self.isExportVideo=NO;
                        self.hProgressView.hidden = YES;
                        if ([errorMessage isEqualToString:@"Failed"]) {
                            [QMUITipsTool showErrorWihtMessage:@"Video export failed, please upload again".icanlocalized inView:self.view];
                            
                        }
                    }];
                }else{
                    self.isExportVideo = NO;
                }
            }];
            
            
        } pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
    
}


-(void)selectOnlyPhotoPickFromeTZImagePicker{
    self.isExportVideo=NO;
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureOrVideoInTimeLinesWithTarget:self maxCount:9-self.imageItems.count minCount:1 canSelectVide:NO canSelectPhoto:YES pickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [QMUITips hideAllTips];
            [self.imageItems addObjectsFromArray:photos];
            [self updateShowImageView];
            self.canSelectViedo =NO;
            
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

//从相册选择 视频跟图片
-(void)selectPickFromeTZImagePicker{
    self.isExportVideo=NO;
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureOrVideoInTimeLinesWithTarget:self maxCount:9-self.imageItems.count minCount:1 canSelectVide:self.canSelectViedo canSelectPhoto:YES pickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [QMUITips hideAllTips];
            [self.imageItems addObjectsFromArray:photos];
            self.canSelectViedo =NO;
            [self updateShowImageView];
        } didFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
            [QMUITips hideAllTips];
        } cancelHandle:^{
            [QMUITips hideAllTips];
            
        } pickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            self.isExistedVideo =YES;
            [self.imageItems addObject:coverImage];
            [self updateShowImageView];
            [self handleVideoSendFromImage:coverImage phasset:asset];
            
            
        } pickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
            
        }];
        
        
        
    } failure:^{
        
    }];
}
-(void)startCompressVideoWithAVURLAsset:(AVURLAsset*)videoAsset{
    //获取转码之后的视频
    NSNumber *size;
    [videoAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
    self.saveUrlPath=videoAsset.URL;
    @weakify(self);
    if (([size floatValue]/(1024.0*1024.0))>5.00) {
        self.isExportVideo=YES;
        [[UIImagePickerHelper sharedManager]startExportVideoWithVideoAsset:videoAsset preset:4 outputPath:nil exportProgress:^(float progress) {
            @strongify(self);
            self.hProgressView.hidden=NO;
            self.hProgressView.progress=progress;
        } success:^(NSString * _Nonnull outputPath) {
            @strongify(self);
            [QMUITips hideAllTips];
            self.isExportVideo=NO;
            self.hProgressView.hidden=YES;
            self.saveUrlPath = [NSURL fileURLWithPath:outputPath];
        } failure:^(NSString * _Nonnull errorMessage, NSError * _Nullable error) {
            @strongify(self);
            self.isExportVideo=NO;
            if ([errorMessage isEqualToString:@"Failed"]) {
                [QMUITipsTool showErrorWihtMessage:@"Video export failed, please upload again".icanlocalized inView:nil];
            }
        }];
    }
}
/** 处理从相册拿到的视频 */
-(void)handleVideoSendFromImage:(UIImage*)coverImage phasset:(PHAsset*)asset{
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    self.remoteHaveVideo=NO;
    //先拿原视频 然后从服务器获取是否存在该视频
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        NSData*data=[NSData dataWithContentsOfURL:videoAsset.URL];
        self.originalVideoHash=[NSString getHasNameData:data];
        CheckFileHasExistRequest*request=[CheckFileHasExistRequest request];
        request.hashId=self.originalVideoHash;
        request.isHttpResponse=YES;
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
            [QMUITips hideAllTips];
            self.isExportVideo=NO;
            //如果远端存在视频URL 不用再重新上传
            if (response.length>0) {
                self.remoteHaveVideo=YES;
                self.fileVideoUrl=response;
            }else{
                [self startCompressVideoWithAVURLAsset:videoAsset];
                
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [self startCompressVideoWithAVURLAsset:videoAsset];
        }];
        
    }];
    
}
//拍照和视频
-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                self.photoManager.configuration.saveSystemAblum = YES;
                self.photoManager.selectPhotoFinishDismissAnimated = YES;
                self.photoManager.cameraFinishDismissAnimated = YES;
                self.photoManager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
                [self hx_presentCustomCameraViewControllerWithManager:self.photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
                    if (model.subType == HXPhotoModelMediaSubTypePhoto ) {
                        // 获取一张图片临时展示用
                        [model requestPreviewImageWithSize:CGSizeMake(720, 1080) startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                            [self.imageItems addObject:image];
                            self.canSelectViedo =NO;
                            [self updateShowImageView];
                        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                            
                        }];
                    }else{
                        // 获取一张图片临时展示用
                        [model requestPreviewImageWithSize:CGSizeMake(720, 1080) startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                            self.isExistedVideo =YES;
                            [self.imageItems addObject:image];
                            self.saveUrlPath = model.videoURL;
                            self.canSelectViedo = NO;
                            [self updateShowImageView];
                        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                            
                        }];
                    }
                    
                } cancel:^(HXCustomCameraViewController *viewController) {
                    
                }];
            } notDetermined:^{
                
            } failure:^{
                
            }];
            
        } failure:^{
            
        }];
        
        
    } failure:^{
        
    }];
}

/** 拍视频 */
-(void)takeSmallVideo{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                self.photoManager.configuration.saveSystemAblum = YES;
                self.photoManager.selectPhotoFinishDismissAnimated = YES;
                self.photoManager.cameraFinishDismissAnimated = YES;
                self.photoManager.type = HXPhotoManagerSelectedTypeVideo;
                self.photoManager.configuration.customCameraType  = HXPhotoCustomCameraTypeVideo;
                [self hx_presentCustomCameraViewControllerWithManager:self.photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
                    // 获取一张图片临时展示用
                    [model requestPreviewImageWithSize:CGSizeMake(720, 1080) startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        self.isExistedVideo =YES;
                        [self.imageItems addObject:image];
                        self.saveUrlPath = model.videoURL;
                        self.canSelectViedo = NO;
                        [self updateShowImageView];
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        
                    }];
                } cancel:^(HXCustomCameraViewController *viewController) {
                    
                }];
            } notDetermined:^{

            } failure:^{

            }];

        } failure:^{

        }];


    } failure:^{

    }];
}
///只拍照
-(void)takePhoto{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        self.photoManager.configuration.saveSystemAblum = YES;
        self.photoManager.selectPhotoFinishDismissAnimated = YES;
        self.photoManager.cameraFinishDismissAnimated = YES;
        self.photoManager.type = HXPhotoManagerSelectedTypePhoto;
        self.photoManager.configuration.customCameraType  = HXPhotoCustomCameraTypePhoto;
        [self hx_presentCustomCameraViewControllerWithManager:self.photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
            // 获取一张图片临时展示用
            [model requestPreviewImageWithSize:CGSizeMake(720, 1080) startRequestICloud:nil progressHandler:nil success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                [self.imageItems addObject:image];
                self.canSelectViedo = NO;
                [self updateShowImageView];
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                
            }];
        } cancel:^(HXCustomCameraViewController *viewController) {
            
        }];

    } failure:^{

    }];
    
    
    
}




- (void)showAlert {
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"Camera", 拍照) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
}

-(void)showFaceView{
    [self.view endEditing:YES];
    self.emojyShowView.hidden = NO;
    self.postBottomView.hidden = YES;
    
}

-(void)hiddenFaceView{
    
}

-(void)selectAtMembers{
    SelectAtTimelineTableViewController * vc = [SelectAtTimelineTableViewController new];
    vc.atSingleBlcok = ^(UserMessageInfo * _Nonnull userMessageInfo) {
        [self dealWithAtUserMessageWithShowName:userMessageInfo.nickname userId:userMessageInfo.userId longPress:NO];
    };
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark==  处理 @ 用户的 ==
- (void)dealWithAtUserMessageWithShowName:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress{
    BOOL contain=NO;
    for (NSDictionary*dict in self.reminders) {
        if ([dict[@"userId"] isEqualToString:userId]) {
            contain=YES;
            break;;
        }
    }
    if (!contain) {
        
        NSString *message = [self.textView.text stringByAppendingString:@"@"];
        NSArray * rangeArray=[self rangeOfSubString:@"@" inString:message];
        NSValue *rangeValue=[rangeArray lastObject];
        NSRange atRange =[rangeValue rangeValue];
        NSMutableString * messageMustr=[NSMutableString stringWithString:message];
        [messageMustr insertString:[NSString stringWithFormat:@"%@ ",showName] atIndex:atRange.location+1];
        self.textView.text = messageMustr;
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:4];
        // 用户的user
        infoDic[@"userId"] = userId;
        // 用户的昵称
        infoDic[@"remark"] = showName;
        // 用户在textView的末尾位置
        infoDic[@"location"] = [NSNumber numberWithInteger: atRange.location+showName.length+1];
        // 用户所占的长度
        infoDic[@"length"] = [NSNumber numberWithInteger:showName.length + 2];
        //    [self.atMemberArr addObject:infoDic];
        [self.reminders addObject:infoDic];
        [self.textView becomeFirstResponder];
    }
    
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(NSUInteger i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    for (NSDictionary *infoDic in self.reminders) {
        if ([infoDic[@"location"] integerValue] == range.location) {
            NSInteger indexLocation = [infoDic[@"location"] integerValue];
            NSInteger length = [infoDic[@"length"] integerValue];
            self.textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(indexLocation - (length -1) , length - 1 ) withString:@""];
            [self.textView setSelectedRange:NSMakeRange(indexLocation, 0)];
            [self.reminders removeObject:infoDic];
            return YES;
        }
    }
    return YES;
}
-(void)choseFunctionWith:(PostMessageFunctionType )index{
    switch (index) {
        case PostMessageFunctionType_photograph:{
            //拍照
            if (self.isExistedVideo) {
                [QMUITipsTool showOnlyTextWithMessage:@"Only one video can be selected".icanlocalized inView:self.view];
                return;
            }
            
            if (self.imageItems.count ==9) {
                [QMUITipsTool showOnlyTextWithMessage:@"Select up to 9 pictures".icanlocalized inView:self.view];
                return;
            }
            if (self.postMessageType ==TimelinesShare) {
                //只拍照
                [self takePhoto];
            }else if (self.postMessageType==TimelinesVideo){
                //只能拍小视频
                [self takeSmallVideo];
                
            }else{
                //点朋友圈进来，拍照跟小视频
                [self photographToSetHeaderPic];
            }
            
        }
            
            break;
        case PostMessageFunctionType_image:{//图片
            if (self.isExistedVideo) {
                [QMUITipsTool showOnlyTextWithMessage:@"Only one video can be selected".icanlocalized inView:self.view];
                return;
            }
            
            if (self.imageItems.count ==9) {
                [QMUITipsTool showOnlyTextWithMessage:@"Select up to 9 pictures".icanlocalized inView:self.view];
                return;
            }
            
            
            
            if (self.postMessageType==TimelinesVideo) {
                //只能选择视频
                [self selectOnlyVideoPickFromeTZImagePicker];
            }else if (self.postMessageType==TimelinesShare){
                //只能选图片
                [self selectOnlyPhotoPickFromeTZImagePicker];
            }else{
                //图片+图片
                [self selectPickFromeTZImagePicker];
            }
            
        }
            
            break;
            
        case PostMessageFunctionType_face:{//表情
            [self showFaceView];
            
        }
            
            break;
        case PostMessageFunctionType_atUser:{//@联系人
            [self selectAtMembers];
        }
            
            break;
        case PostMessageFunctionType_location:{
            SelectMKMapLocationViewController *vc = [[SelectMKMapLocationViewController alloc] init];
            @weakify(self);
            vc.locationSelectBlock = ^(LocationMessageInfo *_Nonnull locationInfo) {
                self.addressLab.text = [NSString stringWithFormat:@"%@, %@",locationInfo.name, locationInfo.address];
                self.addressLab.hidden = NO;
                self.locationInfo = [[LocationInfo alloc]init];
                self.locationInfo.name = [NSString stringWithFormat:@"%@, %@",locationInfo.name, locationInfo.address];
                self.locationInfo.latitude = [NSString stringWithFormat:@"%f",locationInfo.latitude];
                self.locationInfo.longitude = [NSString stringWithFormat:@"%f",locationInfo.longitude];
            };
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
            nav.modalPresentationStyle =  UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
    }
    
}

-(void)didChoseLimit:(NSString *)title index:(NSInteger)index choseArray:(nonnull NSArray *)choseArray{
    [self setCurrentTitleWith:title];
    if ([title isEqualToString:@"ExceptSomeFriends"]){
        [self.shields addObjectsFromArray:choseArray];
        
    }else if ([title isEqualToString:@"SomeFriends"]){
        [self.specifies addObjectsFromArray:choseArray];
    }
}
#pragma XMChatFaceViewDelegate
- (void)faceViewSendFace:(NSString *)faceName{
    if ([faceName isEqualToString:@"[删除]"]) {
        if (!self.textView.text ||self.textView.text.length==0) {
            return;
        }
        self.textView.text = [self.textView.text stringByReplacingCharactersInRange:NSMakeRange(self.textView.text.length-1, 1) withString:@""];
    }else{
        self.textView.text = [self.textView.text stringByAppendingString:faceName];
    }
    
    
}
-(void)removePeople{
    //提醒的人的数组跟屏蔽的人的数组有同一个人，把提醒的人移除
    NSMutableArray * removeArray = [NSMutableArray array];
    for (NSDictionary * reminderUser in self.reminders) {
        for (UserMessageInfo * shieldUser in self.shields) {
            if ([reminderUser[@"userId"] isEqualToString:shieldUser.userId]) {
                [removeArray addObject:reminderUser];
                break;
            }
        }
    }
    [self.reminders removeObjectsInArray:removeArray];
    
    
}
- (void)postSuccess {
    [QMUITipsTool showSuccessWithMessage:@"SuccessfullyPosted".icanlocalized inView:nil];
    if (self.postMessageType==TimeLinesFriendCrile) {
        TypeTimelinesViewController*vc=[[TypeTimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.timelineType=TimelineType_find;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.postMessageSucessBlock) {
        self.postMessageSucessBlock();
    }
}
-(void)PostSendTimelinesRequestWith:(SendTimelinesRequest*)request{
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITipsTool showLoadingWihtMessage:@"Announcing".icanlocalized inView:self.view isAutoHidden:NO];
    });
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [self postSuccess];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        self.rightBtn.enabled = YES;
    }];
}
-(void)sentTimelinesAction{
    if (self.isExportVideo) {
        [QMUITipsTool showOnlyTextWithMessage:@"Video processing, please post later".icanlocalized inView:self.view];
        return;
    }
    if (self.isUploading) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.uploading".icanlocalized inView:self.view];
        return;
    }
    NSString * tentContent = self.textView.text.trimmingwhitespaceAndNewline;
    BOOL isWhitespace = false;
    if ([NSString isEmptyString:tentContent]) {
        isWhitespace = YES;
    }
    //不能发送空白图片
    if (isWhitespace && self.imageItems.count==0 && !self.saveUrlPath) {
        [QMUITipsTool showOnlyTextWithMessage:@"Cannot send blank message".icanlocalized inView:self.view];
        return;
    }
    [self removePeople];
    SendTimelinesRequest * requeset = [SendTimelinesRequest request];
    if (tentContent.length >0) {
        requeset.content= self.textView.text;
    }
    //可见范围
    requeset.visibleRange = self.visibleRange;
    //屏蔽的人
    if (self.shields.count >0) {
        NSMutableArray * shieldArray = [NSMutableArray array];
        for (UserMessageInfo * user in self.shields) {
            [shieldArray addObject:user.userId];
        }
        requeset.shields = (NSArray *)shieldArray;
    }
    //指定可见的人
    if (self.specifies.count>0) {
        NSMutableArray * specifiesArray = [NSMutableArray array];
        for (UserMessageInfo * user in self.specifies) {
            [specifiesArray addObject:user.userId];
        }
        requeset.specifies = (NSArray *)specifiesArray;
    }
    
    if (self.locationInfo) {
        requeset.location = self.locationInfo;
    }
    if (self.reminders.count>0) {
        NSMutableArray * extArray = [NSMutableArray array];
        NSMutableArray * reminderArray  = [NSMutableArray array];
        for (NSDictionary * user in self.reminders) {
            NSMutableDictionary * extDic = [[NSMutableDictionary alloc]init];
            [extDic setObject:user[@"remark"]forKey:@"v"];
            [extDic setObject:user[@"userId"] forKey:@"k"];
            [extArray addObject:extDic];
            [reminderArray addObject:user[@"userId"]];
        }
        requeset.ext = [extArray mj_JSONString];
        requeset.reminders = (NSArray *)reminderArray;
    }
    self.rightBtn.enabled = NO;
    if (self.isExistedVideo) {//是上传视频的
        //如果远端存在视频
        if (self.remoteHaveVideo) {
            [[[OSSWrapper alloc]init]uploadImagesWithImage:self.imageItems.firstObject successHandler:^(NSString * _Nonnull imageimageUrl) {
                requeset.videoUrl = self.fileVideoUrl;
                UIImage*image=self.imageItems.firstObject;
                requeset.height=@(image.size.height);
                requeset.width=@(image.size.width);
                requeset.imageUrls = @[imageimageUrl];
                requeset.parameters = [requeset mj_JSONString];
                [self PostSendTimelinesRequestWith:requeset];
            } failureHandler:^(NSError * _Nonnull error, NSInteger statusCode) {
                
            }];
        }else{
            OSSWrapper*wrapper=[[OSSWrapper alloc]init];
            [self.ossRequestClinetArr addObject:wrapper];
            self.isUploading=YES;
            [wrapper startUploadTimelinesVideoWith:self.imageItems.firstObject imageFailure:^(NSError * _Nonnull) {
                self.rightBtn.enabled = YES;
                [QMUITipsTool showOnlyTextWithMessage:@"Video upload failed, please upload again".icanlocalized inView:self.view];
            } videoFailure:^(NSError * _Nonnull) {
                self.rightBtn.enabled = YES;
                [QMUITipsTool showOnlyTextWithMessage:@"Video upload failed, please upload again".icanlocalized inView:self.view];
            } videoUrl:self.saveUrlPath videoUploadProgress:^(float progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressView.hidden=NO;
                    self.progressView.progress=progress;
                });
            } success:^(NSString * _Nonnull imageUrl, NSString * _Nonnull videoUrl, NSString * _Nonnull videoOssPath) {
                self.isUploading=NO;
                self.progressView.hidden=YES;
                [self.ossRequestClinetArr removeObject:wrapper];
                requeset.videoUrl = videoUrl;
                requeset.imageUrls = @[imageUrl];
                UIImage*image=self.imageItems.firstObject;
                requeset.height=@(image.size.height);
                requeset.width=@(image.size.width);
                requeset.parameters = [requeset mj_JSONString];
                [self PostSendTimelinesRequestWith:requeset];
                //添加视频hash
                NSData*data=[NSData dataWithContentsOfURL:self.saveUrlPath];
                NSString* size=[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)];
                [[ChatViewHandleTool shareManager]ossAddHashWihtHash:self.originalVideoHash url:videoUrl name:self.saveUrlPath.lastPathComponent size:size path:videoOssPath];
            }];
        }
    }else if(self.imageItems.count>0){
        [QMUITipsTool showLoadingWihtMessage:@"Announcing".icanlocalized inView:self.view isAutoHidden:NO];
        self.isUploading=YES;
        NSMutableArray*requestArray=[NSMutableArray arrayWithCapacity:self.imageItems.count];
        //组装图片上传model
        for (int i=0; i<self.imageItems.count; i++) {
            UploadImgModel*model=[[UploadImgModel alloc]init];
            model.image=self.imageItems[i];
            model.index=i;
            [requestArray addObject:model];
        }
        OSSWrapper*wrapper=[[OSSWrapper alloc]init];
        [self.ossRequestClinetArr addObject:wrapper];
        [wrapper uploadTimelineImagesWithModels:requestArray successHandler:^(NSArray * _Nonnull imgModels) {
            self.isUploading=NO;
            [self.ossRequestClinetArr removeObject:wrapper];
            NSArray * urlArrs = [imgModels valueForKeyPath:@"ossImgUrl"];
            requeset.imageUrls = urlArrs;
            if (requestArray.count==1) {
                UIImage*image=self.imageItems.firstObject;
                requeset.height=@(image.size.height);
                requeset.width=@(image.size.width);
            }
            requeset.parameters = [requeset mj_JSONString];
            [self PostSendTimelinesRequestWith:requeset];
        }];
        
    }else{
        requeset.parameters = [requeset mj_JSONString];
        
        [self PostSendTimelinesRequestWith:requeset];
        
    }
    
}
-(NSMutableArray<OSSWrapper *> *)ossRequestClinetArr{
    if (!_ossRequestClinetArr) {
        _ossRequestClinetArr=[NSMutableArray array];
    }
    return _ossRequestClinetArr;
}
-(DZProgressCircleView *)progressView{
    if (!_progressView) {
        _progressView = [[NSBundle mainBundle]loadNibNamed:@"DZProgressCircleView" owner:self options:nil].firstObject;
        _progressView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight);
        _progressView .center = self.view.center;
        _progressView.hidden = YES;
        [self.view addSubview:_progressView];
    }
    return _progressView;
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

-(YBImageBrowerTool *)ybImageBrowerTool{
    if (!_ybImageBrowerTool) {
        _ybImageBrowerTool = [[YBImageBrowerTool alloc]init];
    }
    return _ybImageBrowerTool;
}

-(NSMutableArray *)reminders{
    if (!_reminders) {
        _reminders = [NSMutableArray array];
    }
    
    return _reminders;
}

-(NSMutableArray *)specifies{
    if (!_specifies) {
        _specifies = [NSMutableArray array];
    }
    
    return _specifies;
}

-(NSMutableArray *)shields{
    if (!_shields) {
        _shields = [NSMutableArray array];
    }
    
    return _shields;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton functionButtonWithTitle:@"PostMessageViewController.rightBtn".icanlocalized image:nil backgroundColor:UIColor.whiteColor titleFont:16 target:self action:@selector(sentTimelinesAction)];
        [_rightBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorMake(243, 243, 243) forState:UIControlStateDisabled];
    }
    return _rightBtn;
}
-(NSMutableArray *)imageItems{
    if (!_imageItems) {
        _imageItems = [NSMutableArray array];
    }
    
    return _imageItems;
}
-(void)showPhotoWithIndex:(NSInteger)index{
    @weakify(self);
    self.ybImageBrowerTool.deleImgeBlock = ^(NSInteger index) {
        @strongify(self);
        [self.imageItems removeObjectAtIndex:index];
        [self updateShowImageView];
    };
    [self.ybImageBrowerTool showYBImageBrowerWithCurrentIndex:index imageItems:self.imageItems];
}

-(void)showVideo{
    DZAVPlayerViewController* vc = [[DZAVPlayerViewController alloc]init];
    [vc setPlayUrl:self.saveUrlPath aVPlayerViewType:AVPlayerViewTimelinesPostMessage];
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.delectBlock = ^{
        @strongify(self);
        [self.imageItems removeAllObjects];
        self.isExistedVideo = NO;
        self.saveUrlPath = nil;
        [self updateShowImageView];
        
    };
    [self.view endEditing:YES];
}

//插入emoji
- (void)insertStringWithCursorText:(UITextView *)textView emoji:(NSString *)emoji {
    
    NSRange range = textView.selectedRange;
    NSUInteger location  = textView.selectedRange.location;
    
    NSString * textStr = textView.text;
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@",[textStr substringToIndex:location],emoji,[textStr substringFromIndex:location]];
    
    textView.text = resultStr;
    range.location = range.location + [emoji length];
    textView.selectedRange = NSMakeRange(range.location,0);
}
//光标位置删除
- (void)deletetStringWithCursorText:(UITextView *)textView {
    NSRange range = textView.selectedRange;
    if (textView.text.length > 0) {
        NSUInteger location  = textView.selectedRange.location;
        NSString *head = [textView.text substringToIndex:location];
        if (range.length ==0) {
        }else{
            //文字为全选
            textView.text =@"";
        }
        if (location > 0) {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",textView.text];
            [self lastRange:head];
            [str deleteCharactersInRange:[self lastRange:head]];
            textView.text = str;
            textView.selectedRange = NSMakeRange([self lastRange:head].location,0);
        } else {
            textView.selectedRange = NSMakeRange(0,0);
            
        }
        
    }
    
}
//计算选中的最后一个是字符还是表情所占长度
- (NSRange)lastRange:(NSString *)str {
    NSRange lastRange = [str rangeOfComposedCharacterSequenceAtIndex:str.length-1];
    return lastRange;
    
}
@end

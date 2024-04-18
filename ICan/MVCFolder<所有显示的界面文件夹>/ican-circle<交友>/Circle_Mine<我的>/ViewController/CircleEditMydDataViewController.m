//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 19/5/2021
 - File name:  CircleEditMydDataViewController.m
 - Description:
 不可修改的数据：
 生日
 性别
 星座
 国家
 - Function List:
 */


#import "CircleEditMydDataViewController.h"
#import <TZImagePickerController.h>
#import "CircleOssWrapper.h"
#import "YBImageBrowerTool.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"

#import "CircleUserDetailImgeCollectionViewCell.h"
#import "CircleHobbyCollectionViewCell.h"
#import "CircleSelectHobbyViewController.h"
#import "HJCActionSheet.h"
#import <BRPickerView.h>
#import "ShowSelectAddressView.h"
#import <ReactiveObjC.h>
#import "UploadImgModel.h"
@interface CircleEditMydDataViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,QMUITextViewDelegate,HJCActionSheetDelegate,UIScrollViewDelegate,QMUITextFieldDelegate,QMUITextViewDelegate>
@property(nonatomic, assign) BOOL isItemShake;

@property (weak, nonatomic) IBOutlet UIView *sinureBgView;

@property (weak, nonatomic) IBOutlet DZIconImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *checkBgView;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
//用户昵称
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTfWidth;
//个性签名
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *signatureTextView;
//出生日期
@property (weak, nonatomic) IBOutlet UIControl *birthdayBgCon;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIImageView *birthdayArrowImgView;
//性别
@property (weak, nonatomic) IBOutlet UIControl *genderBgCon;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *genderArrowImgView;
//身高
@property (weak, nonatomic) IBOutlet UIControl *heightBgCon;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *heightTextField;
//体重
@property (weak, nonatomic) IBOutlet UIControl *weightBgCon;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *weightTextField;
//星座
@property (weak, nonatomic) IBOutlet UIControl *xingzuoBgCon;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *xingzuoTextField;
//区域
@property (weak, nonatomic) IBOutlet UIControl *areaBgCon;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *areaLaTextField;
@property (weak, nonatomic) IBOutlet UIImageView *areaLaArrowImgView;
//学历
@property (weak, nonatomic) IBOutlet UIControl *educationBgCon;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *educationTextField;

//职业
@property (weak, nonatomic) IBOutlet UIControl *professionBgCon;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *professionTextField;
//爱好
@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (weak, nonatomic) IBOutlet UILabel *hobbyTipLabel;
@property (weak, nonatomic) IBOutlet UIControl *hobbyTapCon;
@property (weak, nonatomic) IBOutlet UIImageView *hobbyArrowImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hobyBgHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *hobyCollectionView;
@property(nonatomic, strong) HJCActionSheet *hjcActionSheet;
@property(nonatomic, strong) NSArray *educationItems;
@property(nonatomic, strong) NSArray *genderItems;

@property(nonatomic, strong) NSArray *professionItems;

@property(nonatomic, strong) ShowSelectAddressView *selectAddressView;


@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *addImgModel;
//当前的添加图片的model
@property(nonatomic, strong) UploadImgModel *userIconImgModel;

@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
@property(nonatomic, assign) BOOL selectUserIconImg;




@end

@implementation CircleEditMydDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    "CircleEditMydDataViewController.title"="个人详情";
    self.title=@"CircleEditMydDataViewController.title".icanlocalized;
    [IQKeyboardManager sharedManager].enable=NO;
    self.addImgModel=[[UploadImgModel alloc]init];
    self.addImgModel.image=UIImageMake(@"icon_photograph_w");
    self.addImgModel.isAdd=YES;
    self.userIconImgModel=[[UploadImgModel alloc]init];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self getUserRequest];
    [self.hobyCollectionView registNibWithNibName:kCircleHobbyCollectionViewCell];
    
    //    "CircleEditMydDataDetialInfoTableViewCell.nameLabel"="用户昵称";
    //    "CircleEditMydDataDetialInfoTableViewCell.nameTextField"="请输入用户昵称";
    self.nameLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.nameLabel".icanlocalized;
    self.nameTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.nameTextField".icanlocalized;
    //    "CircleEditMydDataDetialInfoTableViewCell.signatureLabel"="个性签名";
    //    "CircleEditMydDataDetialInfoTableViewCell.signatureTextView"="请填写个性签名，有助于大家注意到你哟~";
    self.signatureLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.signatureLabel".icanlocalized;
    self.signatureTextView.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.signatureTextView".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.birthdayLabel"="出生日期";
    //    "CircleEditMydDataDetialInfoTableViewCell.birthdayTextField"="请选择出生日期";
    self.birthdayLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.birthdayLabel".icanlocalized;
    self.birthdayTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.birthdayTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.genderLabel"="性别";
    //    "CircleEditMydDataDetialInfoTableViewCell.genderTextField"="请选择性别";
    self.genderLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.genderLabel".icanlocalized;
    self.genderTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.genderTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.heightLabel"="身高";
    //    "CircleEditMydDataDetialInfoTableViewCell.heightTextField"="请输入身高（cm)";
    self.heightLabel.text=[NSString stringWithFormat:@"%@(cm)",@"CircleEditMydDataDetialInfoTableViewCell.heightLabel".icanlocalized];
    self.heightTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.heightTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.weightLabel"="体重";
    //    "CircleEditMydDataDetialInfoTableViewCell.weightTextField"="请输入体重（kg)";
    self.weightLabel.text=[NSString stringWithFormat:@"%@(kg)",@"CircleEditMydDataDetialInfoTableViewCell.weightLabel".icanlocalized];
    self.weightTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.weightTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.xingzuoLabel"="星座";
    //    "CircleEditMydDataDetialInfoTableViewCell.xingzuoTextField"="请选择星座";
    self.xingzuoLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.xingzuoLabel".icanlocalized;
    self.xingzuoTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.xingzuoTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.educationLabel"="学历";
    //    "CircleEditMydDataDetialInfoTableViewCell.educationTextField"="请输入学历";
    self.educationLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.educationLabel".icanlocalized;
    self.educationTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.educationTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.areaLabel"="区域设置";
    //    "CircleEditMydDataDetialInfoTableViewCell.areaLaTextField"="请选择区域";
    self.areaLabel.text=@"CircleHomeListViewController.topHeadView.area".icanlocalized;
    self.areaLaTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.areaLaTextField".icanlocalized;
    //
    //    "CircleEditMydDataDetialInfoTableViewCell.professionLabel"="职业";
    //    "CircleEditMydDataDetialInfoTableViewCell.professionTextField"="请选择职业";
    self.professionLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.professionLabel".icanlocalized;
    self.professionTextField.placeholder=@"CircleEditMydDataDetialInfoTableViewCell.professionTextField".icanlocalized;
    self.hobbyLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.hobbyLabel".icanlocalized;
    self.hobbyTipLabel.text=@"CircleEditMydDataDetialInfoTableViewCell.hobbyTipLabel".icanlocalized;
    self.educationItems=@[@"CircleEditMydDataDetialInfoTableViewCell.Education.PrimarySchool".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.Education.JuniorHighSchool".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.Education.HighSchool".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.Education.Specialist".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.Education.Undergraduate".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.Education.Postgraduate".icanlocalized];
    self.genderItems=@[@"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized,@"CircleEditMydDataDetialInfoTableViewCell.gender.Female".icanlocalized];
    self.checkLabel.text=@"CircleMineShowUserImgTableViewCell.checkIconLabel".icanlocalized;
    self.signatureTextView.delegate=self;
    [self.userImageView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    [self.userImageView addTap];
    self.userImageView.tapBlock = ^{
        [self showAlert];
    };
    self.nameTextField.delegate=self;
    [self.nameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.circleUserInfo.nickname=x.trimmingwhitespaceAndNewline;
    }];
    [self.heightTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.circleUserInfo.bodyHeight=@(x.integerValue);
    }];
    [self.weightTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.circleUserInfo.bodyWeight=@(x.integerValue);
    }];
    [self.checkBgView layerWithCornerRadius:40 borderWidth:0 borderColor:nil];
    [self.sinureBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
}
//icon_edit
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string].trimmingwhitespaceAndNewline;
    int lenth= [checkStr getLenth];
    if (lenth>20) {
        [QMUITipsTool showErrorWihtMessage:@"circle.nameTextFieldlength".icanlocalized inView:self.view];
        return NO;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *checkStr = [textView.text stringByReplacingCharactersInRange:range withString:text].trimmingwhitespaceAndNewline;
    int lenth= [checkStr getLenth];
    if (lenth>100) {
        //circle.nameTextFieldlength
        [QMUITipsTool showErrorWihtMessage:@"circle.singturelength".icanlocalized inView:self.view];
        return NO;
    }
    return YES;
}

-(void)updateView{
    self.birthdayArrowImgView.hidden=self.isEidt;
    self.genderArrowImgView.hidden=self.isEidt;
    self.nameTextField.text=self.circleUserInfo.nickname;
    self.nameTfWidth.constant = 5;
    self.heightTextField.text=[NSString stringWithFormat:@"%zd",self.circleUserInfo.bodyHeight.integerValue];
    self.weightTextField.text=[NSString stringWithFormat:@"%zd",self.circleUserInfo.bodyWeight.integerValue];
    self.genderTextField.text=[self getLocaliGenderWith:self.circleUserInfo.gender];
    self.educationTextField.text=[CircleUserInfo getShowEducationStringByString:self.circleUserInfo.education];
    if (self.circleUserInfo.bodyWeight.integerValue!=0) {
        self.weightTextField.text=self.circleUserInfo.bodyWeight.stringValue;
    }
    if (self.circleUserInfo.bodyHeight.integerValue!=0) {
        self.heightTextField.text=self.circleUserInfo.bodyHeight.stringValue;
    }
    if (self.circleUserInfo.checkSignature.length>0) {
        self.signatureTextView.text=self.circleUserInfo.checkSignature;
    }else{
        if (self.circleUserInfo.signature.length>0) {
            self.signatureTextView.text=self.circleUserInfo.signature;
        }
    }
    
    if (self.circleUserInfo.dateOfBirth) {
        self.birthdayTextField.text=self.circleUserInfo.dateOfBirth;
    }
    //星座
    if (self.circleUserInfo.constellation) {
        self.xingzuoTextField.text=[CircleUserInfo getXingZuoName:self.circleUserInfo.constellation];
    }
    //职业
    if (self.circleUserInfo.professionId) {
        for (ProfessionInfo*info in CircleUserInfoManager.shared.professionArray) {
            if (info.professionId==self.circleUserInfo.professionId) {
                self.professionTextField.text=info.showProfessionName;
                break;
            }
        }
    }
    //拼接用户的地区字符串
    if (self.circleUserInfo.countryId) {
        self.areaLaTextField.text=self.circleUserInfo.showArea;
    }
    if (self.circleUserInfo.userHobbyTags.count==0) {
        self.hobyCollectionView.hidden=YES;
        self.hobbyTipLabel.hidden=NO;
        self.hobbyTapCon.hidden=NO;
    }else{
        self.hobyCollectionView.hidden=NO;
        self.hobbyTipLabel.hidden=YES;
        self.hobbyTapCon.hidden=YES;
    }
    [self.hobyCollectionView reloadData];
    [self.hobyCollectionView layoutSubviews];
    [self.hobyCollectionView layoutIfNeeded];
    CGFloat height=self.hobyCollectionView.collectionViewLayout.collectionViewContentSize.height;
    if (height<40) {
        height=40;
    }
    self.hobyBgHeight.constant=height+50;
    if (self.circleUserInfo.checkAvatar) {
        self.checkBgView.hidden=NO;
        [self.userImageView setImageWithString:self.circleUserInfo.checkAvatar placeholder:BoyDefault];
    }else{
        self.checkBgView.hidden=YES;
        [self.userImageView setImageWithString:self.circleUserInfo.avatar placeholder:BoyDefault];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.circleUserInfo.userHobbyTags.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleHobbyCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCircleHobbyCollectionViewCell forIndexPath:indexPath];
    cell.deleteBlock = ^{
        NSMutableArray*array=[NSMutableArray arrayWithArray:self.circleUserInfo.userHobbyTags];
        [array removeObjectAtIndex:indexPath.item];
        self.circleUserInfo.userHobbyTags=[array copy];
        [self updateView];
        
    };
    cell.tagsInfo=self.circleUserInfo.userHobbyTags[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.hobyCollectionView) {
        HobbyTagsInfo*info=self.circleUserInfo.userHobbyTags[indexPath.item];
        CGFloat width=[NSString widthForString:info.showName withFontSize:13 height:25]+60;
        return CGSizeMake(width,35);
    }
    return CGSizeMake((ScreenWidth-50)/3.0,143);
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
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
-(NSString*)getLocaliGenderWith:(NSString*)gender{
    if ([gender isEqualToString:@"Male"]) {//男
        return @"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized;
    }
    return  @"CircleEditMydDataDetialInfoTableViewCell.gender.Female".icanlocalized;
}
-(NSString*)getPushGenderWith:(NSString*)gender{
    if ([gender isEqualToString:@"CircleEditMydDataDetialInfoTableViewCell.gender.Male".icanlocalized]) {
        return @"Male";
    }
    return  @"Female";
}
- (IBAction)selectBirthdayAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.isEidt) {
        [self showDatePickerView];
        
    }
}
-(void)showDatePickerView{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithPickerMode:BRDatePickerModeYMD];
    // 2.设置属性
    datePickerView.title =@"CircleEditMydDataDetialInfoTableViewCell.birthdayTextField".icanlocalized;
    NSCalendar *ccalendar = [NSCalendar currentCalendar];
    NSDateComponents *ccomponents = [ccalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    //当前的年
    NSInteger year=ccomponents.year;
    datePickerView.minDate = [NSDate br_setYear:1949 month:1];
    datePickerView.maxDate = [NSDate br_setYear:year-18 month:1];
    datePickerView.isAutoSelect = NO;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        //yyyy-mm-dd
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectDate];
        NSInteger month=[components month];
        NSInteger day=[components day];
        NSString*bir=[GetTime stringFromDate:selectDate withDateFormat:@"yyyy-MM-dd"];;
        self.birthdayTextField.text=bir;
        NSString*xingzuoString= [CircleUserInfo getAstroWithMonth:month day:day];
        self.xingzuoTextField.text= [CircleUserInfo getXingZuoName:xingzuoString];
        self.circleUserInfo.dateOfBirth=bir;
        self.circleUserInfo.constellation=xingzuoString;
    };
    // 自定义主题样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColorBg243Color;
    customStyle.pickerTextColor = UIColor102Color;
    customStyle.separatorColor = UIColor102Color;
    datePickerView.pickerStyle = customStyle;
    // 3.显示
    [datePickerView show];
}
- (IBAction)selectAreaAction:(id)sender {
    [self.view endEditing:YES];
    [self.selectAddressView didShowSelectAddressView];
    
}
//选择爱好
- (IBAction)selectHobby {
    [self.view endEditing:YES];
    CircleSelectHobbyViewController*vc=[CircleSelectHobbyViewController new];
    vc.selectHobbyBlock = ^(NSArray<HobbyTagsInfo *> * _Nonnull selectHobbyItems) {
        self.circleUserInfo.userHobbyTags=selectHobbyItems;
        [self updateView];
    };
    vc.selectHobbyItems=self.circleUserInfo.userHobbyTags;
    [[AppDelegate shared]pushViewController:vc animated:YES];
    
}
//选择性别
- (IBAction)selectGenderAction {
    [self.view endEditing:YES];
    if (!self.isEidt) {
        self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.genderItems];
        self.hjcActionSheet.tag=101;
        [self.hjcActionSheet show];
        
        
    }
    
}
//选择学历
- (IBAction)selectEducationAction {
    [self.view endEditing:YES];
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.educationItems];
    self.hjcActionSheet.tag=100;
    [self.hjcActionSheet show];
    
}
/**
 选择职业
 */
- (IBAction)selectProfession:(id)sender {
    [self.view endEditing:YES];
    self.professionItems = [CircleUserInfoManager.shared.professionArray valueForKeyPath:@"showProfessionName"];
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.professionItems];
    self.hjcActionSheet.tag=102;
    [self.hjcActionSheet show];
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==100) {
        NSString*title=[self.educationItems objectAtIndex:buttonIndex-1];
        self.educationTextField.text=title;
        self.circleUserInfo.education=[CircleUserInfo getEducationStringByString:title];
    }else if (actionSheet.tag==101) {
        NSString*title=[self.genderItems objectAtIndex:buttonIndex-1];
        self.genderTextField.text=title;
        self.circleUserInfo.gender=[self getPushGenderWith:title];
    }else if (actionSheet.tag==102){
        NSString*title=[self.professionItems objectAtIndex:buttonIndex-1];
        self.professionTextField.text=title;
        for (ProfessionInfo*info in CircleUserInfoManager.shared.professionArray) {
            if ([info.showProfessionName isEqualToString:title]) {
                self.circleUserInfo.professionId=info.professionId;
                break;
            }
        }
    }
}

- (void)showAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"chatView.function.camera".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self photographToSetHeaderPic];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
}
//从相册选择
-(void)selectPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        self.selectUserIconImg=YES;
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES  pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            self.userIconImgModel.image=photos.firstObject;
            self.selectUserIconImg=NO;
            self.userImageView.image=photos.firstObject;
            //            [QMUITipsTool showLoadingWihtMessage:@"CircleEditMydDataViewController.uploadingimg".icanlocalized inView:self.view isAutoHidden:NO];
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                [QMUITips hideAllTips];
                self.circleUserInfo.avatar=imgModels.firstObject.ossImgUrl;
                self.userIconImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
            }];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
}
//拍照
-(void)photographToSetHeaderPic{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        self.selectUserIconImg=YES;
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            [QMUITips hideAllTips];
            self.userIconImgModel.image=image;
            self.selectUserIconImg=NO;
            self.userImageView.image=image;
            //            [QMUITipsTool showLoadingWihtMessage:@"CircleEditMydDataViewController.uploadingimg".icanlocalized inView:self.view isAutoHidden:NO];
            [[CircleOssWrapper shared]uploadImagesWithModels:@[self.userIconImgModel] uploadType:UploadType_CircleUser successHandler:^(NSArray<UploadImgModel*> * _Nonnull imgModels) {
                self.circleUserInfo.avatar=imgModels.firstObject.ossImgUrl;
                self.userIconImgModel.ossImgUrl=imgModels.firstObject.ossImgUrl;
            }];
        }];
        
    } failure:^{
        
    }];
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        
        //        "CircleEditMydDataViewController.rightButton"="保存";
        _rightButton=[UIButton dzButtonWithTitle:@"CircleEditMydDataViewController.rightButton".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}
-(void)rightBarButtonItemAction{
    //    "CircleEditMydDataViewController.pleseSelectIconImg"="请上传头像";
    //    "CircleEditMydDataViewController.pleseInputNickname"="请填写昵称";
    if (!self.userIconImgModel.ossImgUrl&&!self.userIconImgModel.image) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.pleseSelectIconImg".icanlocalized inView:self.view];
        return;
    }
    if (self.circleUserInfo.nickname.length<=0) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.pleseInputNickname".icanlocalized inView:self.view];
        return;
    }
    if (self.circleUserInfo.bodyHeight.doubleValue==0.00) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.bodyHeightTips".icanlocalized inView:self.view];
        return;
    }
    if (self.circleUserInfo.bodyWeight.doubleValue==0.00) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.weightTips".icanlocalized inView:self.view];
        return;
    }
    if (!self.circleUserInfo.countryId&&!self.circleUserInfo.areaId&&!self.circleUserInfo.provinceId) {
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.areaTips".icanlocalized inView:self.view];
        return;
    }
//    if (self.circleUserInfo.signature.length>0&&self.signatureTextView.text.trimmingwhitespaceAndNewline.length==0) {
//        if (self.signatureTextView.text.trimmingwhitespaceAndNewline.length==0){
//            [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataDetialInfoTableViewCell.signatureTips".icanlocalized inView:self.view];
//            return;
//        }
//    }
    
    [self setUserInfoFirst];
    
}
//设置用户信息
-(void)setUserInfoFirst{
//    必填
//         头像
//         昵称
//         出生日期
//         区域
//         身高
//         体重
//         性别
//
//    选填
//         学历
//         职业
//         爱好
    PutCircleUserInfoRequest*request=[PutCircleUserInfoRequest request];
    if (self.circleUserInfo.professionId) {
        request.professionId=@(self.circleUserInfo.professionId);
    }
    
    request.bodyWeight=self.circleUserInfo.bodyWeight;
    request.bodyHeight=self.circleUserInfo.bodyHeight;
    if (self.circleUserInfo.constellation) {
        request.constellation=self.circleUserInfo.constellation;
    }
    if (self.circleUserInfo.education) {
        request.education=self.circleUserInfo.education;
    }
    if (self.signatureTextView.text.trimmingwhitespaceAndNewline.length>0) {
        request.signature=self.signatureTextView.text.trimmingwhitespaceAndNewline;
    }
    //编辑用户信息
    if (self.isEidt) {
        switch (self.circleUserInfo.currentSelectItems.count) {
            case 1:
                
                break;
            case 2:
                
                request.provinceId=self.circleUserInfo.provinceId;
                break;
            case 3:
                
                request.provinceId=self.circleUserInfo.provinceId;
                request.cityId=self.circleUserInfo.cityId;
                break;
        }
    }else{
        if (!self.circleUserInfo.gender) {
            [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.selectGener".icanlocalized inView:self.view];
            return;
        }
        if (!self.circleUserInfo.dateOfBirth) {
            [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.selectBirthday".icanlocalized inView:self.view];
            return;
        }
        switch (self.circleUserInfo.currentSelectItems.count) {
            case 1:
                request.countryId=self.circleUserInfo.countryId;
                break;
            case 2:
                request.countryId=self.circleUserInfo.countryId;
                request.provinceId=self.circleUserInfo.provinceId;
                break;
            case 3:
                request.countryId=self.circleUserInfo.countryId;
                request.provinceId=self.circleUserInfo.provinceId;
                request.cityId=self.circleUserInfo.cityId;
                break;
        }
        request.dateOfBirth=self.circleUserInfo.dateOfBirth;
        request.gender=self.circleUserInfo.gender;
    }
    request.avatar=self.userIconImgModel.ossImgUrl;
    request.nickname=self.circleUserInfo.nickname;
    if (self.circleUserInfo.userHobbyTags.count>0) {
        NSArray*hobbyTags=[self.circleUserInfo.userHobbyTags valueForKeyPath:@"hobbyTagId"];
        request.hobbyIdList=hobbyTags;
    }else{
        request.hobbyIdList=@[];
    }
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        CircleUserInfoManager.shared.avatar=self.circleUserInfo.avatar;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
        !self.editSuccessBlock?:self.editSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
        [QMUITipsTool showOnlyTextWithMessage:@"CircleEditMydDataViewController.changeSuccess".icanlocalized inView:nil];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        
    }];
    
    
    
}
-(void)getUserRequest{
    GetCircleCurrenUserInfoRequest*request=[GetCircleCurrenUserInfoRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        if ([response.gender isEqualToString:@"Unknown"]) {//默认为男 给他赋值
            response.gender=@"Male";
        }
        self.circleUserInfo=response;
        self.circleUserInfo.selectImgs=[NSMutableArray array];
        CircleUserInfoManager.shared.age=response.age;
        CircleUserInfoManager.shared.icanId=[NSString stringWithFormat:@"%zd",response.icanId];
        CircleUserInfoManager.shared.userId=response.userId;
        CircleUserInfoManager.shared.gender=response.gender;
        CircleUserInfoManager.shared.dateOfBirth=response.dateOfBirth;
        CircleUserInfoManager.shared.avatar=response.avatar;
        CircleUserInfoManager.shared.checkAvatar=response.checkAvatar;
        CircleUserInfoManager.shared.nickname=response.nickname;
        CircleUserInfoManager.shared.enable=response.enable;
        CircleUserInfoManager.shared.yue=response.yue;
        for (NSString*imgUrl in self.circleUserInfo.photos) {
            UploadImgModel*model=[[UploadImgModel alloc]init];
            model.ossImgUrl=imgUrl;
            [self.circleUserInfo.selectImgs addObject:model];
        }
        //获取信息成功之后 重新初始化该model 避免再次修改的用户图片的时候 再次上传用户头像
        self.userIconImgModel=[[UploadImgModel alloc]init];
        self.userIconImgModel.ossImgUrl=response.avatar;
        if (self.circleUserInfo.photos.count!=9) {
            [self.circleUserInfo.selectImgs addObject:self.addImgModel];
        }
        if (self.circleUserInfo.dateOfBirth) {
            self.isEidt=YES;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCircleUserMessageNotificatiaon object:nil];
        [self updateView];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
/**
 选择地区
 */
-(ShowSelectAddressView *)selectAddressView{
    if (!_selectAddressView) {
        _selectAddressView=[[ShowSelectAddressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _selectAddressView.userInfo=self.circleUserInfo;
        if (self.isEidt) {
            _selectAddressView.addressViewType=AddressViewType_SetUserMessage;
        }else{
            _selectAddressView.addressViewType=AddressViewType_FirstSetUserMessage;
        }
        @weakify(self);
        _selectAddressView.successBlock = ^(NSArray<AreaInfo *> * _Nonnull selectAreaItems) {
            @strongify(self);
            self.circleUserInfo.currentSelectItems=selectAreaItems;
            NSMutableString*area=[[NSMutableString alloc]init];
            for (int i=0; i<selectAreaItems.count; i++) {
                if (i!=0) {
                    [area appendString:@" "];
                }
                AreaInfo*info=[selectAreaItems objectAtIndex:i];
                [area appendString:info.areaName];
            }
            self.areaLaTextField.text=area;
            switch (selectAreaItems.count) {
                case 0:
                    
                    break;
                case 1:{
                    self.circleUserInfo.countryId=@(selectAreaItems[0].areaId);
                }
                    break;
                case 2:{
                    self.circleUserInfo.countryId=@(selectAreaItems[0].areaId);
                    self.circleUserInfo.provinceId=@(selectAreaItems[1].areaId);
                }
                    break;
                case 3:{
                    self.circleUserInfo.countryId=@(selectAreaItems[0].areaId);
                    self.circleUserInfo.provinceId=@(selectAreaItems[1].areaId);
                    self.circleUserInfo.cityId=@(selectAreaItems[2].areaId);
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _selectAddressView;
}
@end


/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 7/9/2021
 - File name:  BuyVipOrIdViewController.m
 - Description:
 - Function List:
 */


#import "BuyVipOrIdViewController.h"
#import "CommonWebViewController.h"
#import "QDNavigationController.h"
#import "MemberCenterVIPCollectionViewCell.h"
#import "MemberCenterNumberIdCollectionViewCell.h"
#import "PayManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import <ReactiveObjC.h>
typedef NS_ENUM(NSInteger,ShowMemberType){
    ShowMemberTypeHigh,
    ShowMemberTypeDiamond,
    ShowMemberTypeNumberId,
};
@interface BuyVipOrIdViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QMUITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;


@property (weak, nonatomic) IBOutlet UIImageView *vipTipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//黄金VIP
@property (weak, nonatomic) IBOutlet UIControl *highBgCon;
@property (weak, nonatomic) IBOutlet UILabel *highLab;
@property (weak, nonatomic) IBOutlet UIView *highLineView;

//钻石VIP
@property (weak, nonatomic) IBOutlet UIControl *diamondBgCon;
@property (weak, nonatomic) IBOutlet UILabel *diamondLab;
@property (weak, nonatomic) IBOutlet UIView *diamondLineViwe;


/** 自选ID */
@property (weak, nonatomic) IBOutlet UIControl *selectIDBgCon;
@property (weak, nonatomic) IBOutlet UILabel *selectIDLab;

//搜索的背景
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *searchLabBgView;
@property (weak, nonatomic) IBOutlet UILabel *searchLab;


@property (weak, nonatomic) IBOutlet UICollectionView *vipCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;


/** 换一批 */
@property (weak, nonatomic) IBOutlet UIControl *swichBgCon;
@property (weak, nonatomic) IBOutlet UIView *switchLineView;


/** 立即购买 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UIButton *selectProtocolBtn;

/** 购买协议和会员服务协议 */
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
/** 有阴影的View */
@property (weak, nonatomic) IBOutlet UIView *shapView;

/** 购买ID说明  VIP说明的背景 */
@property (weak, nonatomic) IBOutlet UIView *explainBgView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UIView *oneLineView;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIView *twoLineView;

@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIView *threeLineView;


/** VIP特权 */
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstrint;

@property(nonatomic, assign) ShowMemberType showMemberType;

@property(nonatomic, strong) NSArray<MemberCentreVipInfo*> *allMemberArray;

@property(nonatomic, strong) NSMutableArray<MemberCentreNumberIdSellInfo*> *allMemberNumberIdArray;
/** 钻石会员数组 */
@property(nonatomic, strong) NSArray<MemberCentreVipInfo*> *diamondMemberArray;
@property(nonatomic, strong) NSIndexPath *selectDiamondIndexPath;
/** 高级会员数组 */
@property(nonatomic, strong) NSArray<MemberCentreVipInfo*> *highMemberArray;
@property(nonatomic, strong) NSIndexPath *selectHighIndexPath;
/** 显示的numberID数组 */
@property(nonatomic, strong) NSArray<MemberCentreNumberIdSellInfo*> *showMemberNumberIdArray;
@property(nonatomic, strong) NSIndexPath *selectNumberIdIndexPath;

@property (weak, nonatomic) IBOutlet UICollectionView *idCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idCollectionViewHeight;

@property(nonatomic, assign) BOOL canSearch;

@property(nonatomic, strong) PayManager *payManager;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@end

@implementation BuyVipOrIdViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.canSearch = NO;
    [self.backBtn setBackgroundImage:UIImageMake(@"icon_nav_back_white") forState:UIControlStateNormal];
    [self.searchLabBgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self.explainBgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(208, 108, 40)];
    [self.buyButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    [self.selectProtocolBtn setBackgroundImage:UIImageMake(@"icon_selectperson_nor") forState:UIControlStateNormal];
    [self.selectProtocolBtn setBackgroundImage:UIImageMake(@"wallet_recharge_way_select") forState:UIControlStateSelected];
    self.scrollViewTopConstrint.constant = -StatusBarHeight;
    [self .iconImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    self.highLab.text = @"SeniorVIP".icanlocalized;
    self.diamondLab.text = @"DiamondVIP".icanlocalized;
    self.selectIDLab.text = @"SelfSelectedID".icanlocalized;
    self.searchTextField.placeholder = @"BuyVIPOrIdTextfieldPlachoder".icanlocalized;
    self.searchLab.text = @"Search".icanlocalized;
    
    
    [self.buyButton setTitle:@"BuyPackageViewController.buyBtn".icanlocalized forState:UIControlStateNormal];
    //默认设置高的圆角
    CGRect frame = self.highBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.highBgCon.layer.mask = maskLayer;
    self.highBgCon.backgroundColor = UIColorViewBgColor;
    
    self.highLineView.hidden = YES;
    self.showMemberType = ShowMemberTypeHigh;
    [self getMemberCentreMemberAllRequest];
    [self getMemberCentreMemberAllNumberIdRequest];
    [self.vipCollectionView registNibWithNibName:kMemberCenterVIPCollectionViewCell];
    [self.vipCollectionView registNibWithNibName:kMemberCenterNumberIdCollectionViewCell];
    [self.idCollectionView registNibWithNibName:kMemberCenterVIPCollectionViewCell];
    [self.idCollectionView registNibWithNibName:kMemberCenterNumberIdCollectionViewCell];
    
    self.selectHighIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.selectDiamondIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.selectNumberIdIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    [self huangJinConAction:nil];
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        self.balanceInfo = balance;
    }];
    
    [self.iconImageView setDZIconImageViewWithUrl:UserInfoManager.sharedManager.headImgUrl gender:UserInfoManager.sharedManager.gender];
    self.nicknameLab.text = UserInfoManager.sharedManager.nickname;
    if (UserInfoManager.sharedManager.diamondValid) {
        NSString* time = [GetTime convertDateWithString:UserInfoManager.sharedManager.diamondMemberExpiration dateFormmate:@"yyyy-MM-dd"];
        if (BaseSettingManager.isChinaLanguages) {
            self.timeLab.text = [NSString stringWithFormat:@"钻石会员至%@",time];
        }else{
            self.timeLab.text = [NSString stringWithFormat:@"VVIP to %@",time];
        }
        
        //        icon_buyvip_diamonds
        self.vipTipsImageView.image = UIImageMake(@"icon_buyvip_diamonds");
    }else if (UserInfoManager.sharedManager.seniorValid){
        //icon_senior_hightlight
        NSString* time = [GetTime convertDateWithString:UserInfoManager.sharedManager.seniorMemberExpiration dateFormmate:@"yyyy-MM-dd"];
        if (BaseSettingManager.isChinaLanguages) {
            self.timeLab.text = [NSString stringWithFormat:@"高级会员至%@",time];
        }else{
            self.timeLab.text = [NSString stringWithFormat:@"VIP to %@",time];
        }
        self.vipTipsImageView.image = UIImageMake(@"icon_senior_hightlight");
    }else{
        self.timeLab.text = @"Standard".icanlocalized;
        self.vipTipsImageView.image = UIImageMake(@"icon_senior_nor");
    }
    NSString*s2=@"MemberServiceAgreement".icanlocalized;
    NSString*s3=@"And".icanlocalized;
    NSString*s4=@"PurchaseAgreement".icanlocalized;
    NSString*string5=[NSString stringWithFormat:@"%@%@%@",s2,s3,s4];
    NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:string5];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, string.length)];
    NSRange rang =[string5 rangeOfString:s2];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang.location, s2.length)];
    NSRange rang2 =[string5 rangeOfString:s4];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang2.location, s4.length)];
    self.protocolLabel.attributedText=string;
    [self.protocolLabel yb_addAttributeTapActionWithStrings:@[s2,s4] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        CommonWebViewController*web = [[CommonWebViewController alloc]init];
        NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:string];
        web.title     = dict[@"title"];
        web.urlString = dict[@"url"];
        web.isPresent=YES;
        QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:web];
        nav.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    /* 添加监听条件 */
    [[self.searchTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        self.canSearch = value.length == 6;
        return value.length == 6; // 表示输入文字长度 > 5 时才会调用下面的 block
        
    }] subscribeNext:^(NSString * _Nullable x) {
        
        [self searchAction];
    }];
    
}


#pragma mark - Private
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    BOOL isPure = [NSString checkIsPureString:string];
    if (isPure) {
        NSString * toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return toString.length<=6;
    }
    return NO;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - Lazy
#pragma mark - Event
- (IBAction)selectBtnAction:(id)sender {
    self.selectProtocolBtn.selected = !self.selectProtocolBtn.selected;
    
    
    
}
/** 高级VIP */
- (IBAction)huangJinConAction:(id)sender {
    self.showMemberType = ShowMemberTypeHigh;
    self.highLineView.hidden = YES;
    self.diamondLineViwe.hidden = NO;
    self.highLab.textColor = UIColorMake(201, 142, 36);
    self.diamondLab.textColor = UIColor.whiteColor;
    self.selectIDLab.textColor = UIColor.whiteColor;
    self.swichBgCon.hidden = self.switchLineView.hidden = YES;
    self.searchBgView.hidden = YES;
    self.twoLabel.hidden = self.twoLineView.hidden = self.threeLabel.hidden = self.threeLineView.hidden = YES;
    //说明
    //vip
    self.vipLabel.text = @"VIPPrivileges".icanlocalized;
    self.oneLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",@"VIPDesc1".icanlocalized,@"VIPDesc2".icanlocalized,@"VIPDesc3".icanlocalized];
    [self reloadData];
    //默认设置高的圆角
    CGRect frame = self.highBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.highBgCon.layer.mask = maskLayer;
    self.highBgCon.backgroundColor = UIColorViewBgColor;
    
    //默认设置钻石会员的圆角
    CGRect diamondFrame = self.diamondBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *diamondmaskPath = [UIBezierPath bezierPathWithRoundedRect:diamondFrame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *diamondmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    diamondmaskLayer.frame = diamondFrame;
    //设置图形样子
    diamondmaskLayer.path = diamondmaskPath.CGPath;
    self.diamondBgCon.layer.mask = diamondmaskLayer;
    self.diamondBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    
    
    CGRect vipFrame = self.selectIDBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *vipmaskPath = [UIBezierPath bezierPathWithRoundedRect:vipFrame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *vipmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    vipmaskLayer.frame = vipFrame;
    //设置图形样子
    vipmaskLayer.path = vipmaskPath.CGPath;
    self.selectIDBgCon.layer.mask = vipmaskLayer;
    self.selectIDBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    
    
}
//钻石
- (IBAction)diamondAction:(id)sender {
    self.showMemberType = ShowMemberTypeDiamond;
    self.highLab.textColor = UIColor.whiteColor;
    self.diamondLab.textColor =  UIColorMake(201, 142, 36);
    self.selectIDLab.textColor = UIColor.whiteColor;
    self.highLineView.hidden = YES;
    self.diamondLineViwe.hidden = YES;
    self.swichBgCon.hidden = self.switchLineView.hidden = YES;
    self.searchBgView.hidden = YES;
    self.twoLabel.hidden = self.twoLineView.hidden = self.threeLabel.hidden = self.threeLineView.hidden = YES;
    self.vipLabel.text = @"DiamondPrivileges".icanlocalized;
    self.oneLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",@"DiamondDesc1".icanlocalized,@"DiamondDesc2".icanlocalized,@"DiamondDesc3".icanlocalized,@"DiamondDesc4".icanlocalized];
    [self reloadData];
    //默认设置高的圆角
    CGRect frame = self.highBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.highBgCon.layer.mask = maskLayer;
    self.highBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    
    //默认设置钻石会员的圆角
    CGRect diamondFrame = self.diamondBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *diamondmaskPath = [UIBezierPath bezierPathWithRoundedRect:diamondFrame byRoundingCorners: UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *diamondmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    diamondmaskLayer.frame = diamondFrame;
    //设置图形样子
    diamondmaskLayer.path = diamondmaskPath.CGPath;
    self.diamondBgCon.layer.mask = diamondmaskLayer;
    self.diamondBgCon.backgroundColor = UIColorViewBgColor;
    
    
    //默认设置VIP的圆角
    CGRect vipFrame = self.selectIDBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *vipmaskPath = [UIBezierPath bezierPathWithRoundedRect:vipFrame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *vipmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    vipmaskLayer.frame = vipFrame;
    //设置图形样子
    vipmaskLayer.path = vipmaskPath.CGPath;
    self.selectIDBgCon.layer.mask = vipmaskLayer;
    self.selectIDBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    
}
//自选ID
- (IBAction)selectIdAction:(id)sender {
    self.showMemberType = ShowMemberTypeNumberId;
    self.highLab.textColor = UIColor.whiteColor;
    self.diamondLab.textColor = UIColor.whiteColor;
    self.selectIDLab.textColor =  UIColorMake(201, 142, 36);
    self.highLineView.hidden =NO;
    self.diamondLineViwe.hidden = YES;
    self.swichBgCon.hidden = self.switchLineView.hidden = NO;
    self.vipLabel.text=@"PurchaseID".icanlocalized;
    self.oneLabel.text = @"PurchaseIDTop".icanlocalized;
    self.twoLabel.text = @"Rules".icanlocalized;
    self.twoLineView.hidden = self.twoLabel.hidden = NO;
    self.threeLabel.text = [NSString stringWithFormat:@"%@\n\n%@",@"PurchaseIDDes1".icanlocalized,@"PurchaseIDDes2".icanlocalized];
    self.threeLineView.hidden = self.threeLabel.hidden = NO;
    self.searchBgView.hidden =  NO;
    [self reloadData];
    //默认设置高的圆角
    CGRect frame = self.highBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.highBgCon.layer.mask = maskLayer;
    self.highBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    
    //默认设置钻石会员的圆角
    CGRect diamondFrame = self.diamondBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *diamondmaskPath = [UIBezierPath bezierPathWithRoundedRect:diamondFrame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *diamondmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    diamondmaskLayer.frame = diamondFrame;
    //设置图形样子
    diamondmaskLayer.path = diamondmaskPath.CGPath;
    self.diamondBgCon.layer.mask = diamondmaskLayer;
    self.diamondBgCon.backgroundColor = UIColorMake(28, 31, 44);
    
    CGRect vipFrame = self.selectIDBgCon.bounds;
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *vipmaskPath = [UIBezierPath bezierPathWithRoundedRect:vipFrame byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *vipmaskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    vipmaskLayer.frame = vipFrame;
    //设置图形样子
    vipmaskLayer.path = vipmaskPath.CGPath;
    self.selectIDBgCon.layer.mask = vipmaskLayer;
    self.selectIDBgCon.backgroundColor =UIColorViewBgColor;
    
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 换一批
/// @param sender sender description
- (IBAction)switchAction:(id)sender {
    if (self.allMemberNumberIdArray.count>9) {
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        while ([randomSet count] < 9) {
            int r = arc4random() % [self.allMemberNumberIdArray count];
            [randomSet addObject:[self.allMemberNumberIdArray objectAtIndex:r]];
        }
        self.showMemberNumberIdArray = [randomSet allObjects];
        
    }else{
        self.showMemberNumberIdArray = self.allMemberNumberIdArray;
        
    }
    [self reloadData];
    
    
}
- (IBAction)searchAction {
    if (self.canSearch) {
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"numberId = %@ ",@(self.searchTextField.text.integerValue)];
        NSArray<MemberCentreNumberIdSellInfo*>*selectImtes=[self.allMemberNumberIdArray filteredArrayUsingPredicate:gpredicate];
        if (selectImtes.count>0) {
            self.showMemberNumberIdArray = selectImtes;
            [self reloadData];
        }else{
            CheckMemberCentreNumberIdRequest*request = [CheckMemberCentreNumberIdRequest request];
            request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/memberCentre/check/%@",self.searchTextField.text];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[MemberCentreNumberIdSellInfo class] contentClass:[MemberCentreNumberIdSellInfo class] success:^(MemberCentreNumberIdSellInfo* response) {
                if (response.numberId) {
                    self.showMemberNumberIdArray = @[response];
                }else{
                    [QMUITipsTool showOnlyTextWithMessage:@"ThisIdHasBeenUse".icanlocalized inView:self.view];
                }
                [self reloadData];
                
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
            
        }
    }
}

- (IBAction)buyAction:(id)sender {
    if (!self.selectProtocolBtn.isSelected) {
        [QMUITipsTool showOnlyTextWithMessage:@"LookAndagreeBuyiDagreementtips".icanlocalized inView:self.view];
        return;
    }
    if (self.balanceInfo) {
        [self showSurePayView];
    }else{
        [UserInfoManager.sharedManager fetchUserBalanceRequest:^(UserBalanceInfo * _Nonnull balance) {
            self.balanceInfo = balance;
            [self showSurePayView];
        }];
    }
    
}
-(void)showSurePayView{
    double  amount;
    NSString * typeString;
    switch (self.showMemberType) {
        case ShowMemberTypeHigh:{
            if (self.highMemberArray.count==0) {
                return;
            }
            MemberCentreVipInfo * info = self.highMemberArray[self.selectHighIndexPath.item];
            amount = info.price.doubleValue;
            typeString = @"BuyMember".icanlocalized;
        }
            break;
        case ShowMemberTypeDiamond:{
            if (self.diamondMemberArray.count==0) {
                return;
            }
            MemberCentreVipInfo * info = self.diamondMemberArray[self.selectDiamondIndexPath.item];
            amount = info.price.doubleValue;
            typeString = @"BuyMember".icanlocalized;
        }
            break;
        case ShowMemberTypeNumberId:{
            if (self.showMemberNumberIdArray.count==0) {
                return;
            }
            MemberCentreNumberIdSellInfo * info = self.showMemberNumberIdArray[self.selectNumberIdIndexPath.item];
            amount = info.price.doubleValue;
            typeString = @"BuyId".icanlocalized;
        }
            break;
        default:
            break;
    }
    NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",amount]];
    if ([total compare:self.balanceInfo.balance] == NSOrderedAscending || [total compare:self.balanceInfo.balance] == NSOrderedSame) {
        [self.payManager showPayViewWithAmount:[NSString stringWithFormat:@"%.2f",amount] typeTitleStr:typeString SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
            [self buyMemberWithPassword:password];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:self.view];
    }
}
-(void)buyMemberWithPassword:(NSString*)password{
    switch (self.showMemberType) {
        case ShowMemberTypeHigh:{
            MemberCentreVipInfo * info = self.highMemberArray[self.selectHighIndexPath.item];
            BuyMemberCentreRequest*request = [BuyMemberCentreRequest request];
            request.payPassword = password;
            request.memberId = info.memberId;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                [UserInfoManager sharedManager].attemptCount = nil;
                [UserInfoManager sharedManager].isPayBlocked = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getMyUserInfo];
                });
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self showSurePayView];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self showSurePayView];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }
                } else {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                }
            }];
        }
            break;
        case ShowMemberTypeDiamond:{
            MemberCentreVipInfo * info = self.diamondMemberArray[self.selectDiamondIndexPath.item];
            BuyMemberCentreRequest*request = [BuyMemberCentreRequest request];
            request.payPassword = password;
            request.memberId = info.memberId;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                [UserInfoManager sharedManager].attemptCount = nil;
                [UserInfoManager sharedManager].isPayBlocked = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getMyUserInfo];
                });
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self showSurePayView];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self showSurePayView];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }
                } else {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                }
            }];
        }
            break;
        case ShowMemberTypeNumberId:{
            MemberCentreNumberIdSellInfo * info = self.showMemberNumberIdArray[self.selectNumberIdIndexPath.item];
            BuyMemberCentreNumberIdRequest*request = [BuyMemberCentreNumberIdRequest request];
            request.payPassword = password;
            request.numberId = info.numberId.integerValue;
            request.price = info.price;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                [UserInfoManager sharedManager].attemptCount = nil;
                [UserInfoManager sharedManager].isPayBlocked = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self getMyUserInfo];
                });
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self showSurePayView];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self showSurePayView];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }
                } else {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                }
            }];
            
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showMemberType == ShowMemberTypeDiamond) {
        return self.diamondMemberArray.count;
    }else if (self.showMemberType == ShowMemberTypeHigh){
        return self.highMemberArray.count;
    }
    return self.showMemberNumberIdArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.vipCollectionView) {
        
    }
    if (self.showMemberType == ShowMemberTypeDiamond) {
        MemberCenterVIPCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMemberCenterVIPCollectionViewCell forIndexPath:indexPath];
        cell.vipInfo = self.diamondMemberArray[indexPath.row];
        if (indexPath == self.selectDiamondIndexPath) {
            [cell.bgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColorMake(202, 146, 47)];
            cell.bgView.backgroundColor = UIColorMake(248, 242, 233);
            
        }else{
            [cell.bgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
            cell.bgView.backgroundColor = UIColor10PxClearanceBgColor;
        }
        return cell;
    }else if (self.showMemberType == ShowMemberTypeHigh){
        MemberCenterVIPCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMemberCenterVIPCollectionViewCell forIndexPath:indexPath];
        cell.vipInfo = self.highMemberArray[indexPath.row];
        if (indexPath == self.selectHighIndexPath) {
            [cell.bgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColorMake(202, 146, 47)];
            cell.bgView.backgroundColor = UIColorMake(248, 242, 233);
            
        }else{
            [cell.bgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
            cell.bgView.backgroundColor = UIColor10PxClearanceBgColor;
        }
        return cell;
    }
    MemberCenterNumberIdCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMemberCenterNumberIdCollectionViewCell forIndexPath:indexPath];
    cell.idInfo = self.showMemberNumberIdArray[indexPath.item];
    if (indexPath == self.selectNumberIdIndexPath) {
        [cell.bgView layerWithCornerRadius:15 borderWidth:1 borderColor:UIColorMake(202, 146, 47)];
        cell.bgView.backgroundColor = UIColorMake(248, 242, 233);
    }else{
        [cell.bgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        cell.bgView.backgroundColor = UIColor10PxClearanceBgColor;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.showMemberType) {
        case ShowMemberTypeHigh:{
            self.selectHighIndexPath = indexPath;
        }
            break;
        case ShowMemberTypeDiamond:{
            self.selectDiamondIndexPath = indexPath;
        }
            break;
        case ShowMemberTypeNumberId:{
            self.selectNumberIdIndexPath = indexPath;
        }
            break;
        default:
            break;
    }
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showMemberType == ShowMemberTypeDiamond || self.showMemberType == ShowMemberTypeHigh) {
        return CGSizeMake(100,125);
    }
    return CGSizeMake((ScreenWidth-50)/3.0,55);
    
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
    return UIEdgeInsetsMake(15, 10, 15, 10);
}
#pragma mark - Networking
-(void)getMemberCentreMemberAllRequest{
    GetMemberCentreRequest*request=[GetMemberCentreRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemberCentreVipInfo class] success:^(NSArray<MemberCentreVipInfo*>* response) {
        /** 会员类型,可用值:SeniorMember,DiamondMember */
        self.allMemberArray = response;;
        NSPredicate * highPredicate = [NSPredicate predicateWithFormat:@"memberType CONTAINS[c] %@ ",@"SeniorMember"];
        self.highMemberArray= [self.allMemberArray filteredArrayUsingPredicate:highPredicate];
        
        NSPredicate * diamondPredicate = [NSPredicate predicateWithFormat:@"memberType CONTAINS[c] %@ ",@"DiamondMember"];
        self.diamondMemberArray= [self.allMemberArray filteredArrayUsingPredicate:diamondPredicate];
        [self reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)reloadData{
    
    if (self.showMemberType == ShowMemberTypeHigh||self.showMemberType == ShowMemberTypeDiamond) {
        [self.vipCollectionView reloadData];
        [self.vipCollectionView layoutSubviews];
        [self.vipCollectionView layoutIfNeeded];
        self.collectionViewHeight.constant=self.vipCollectionView.collectionViewLayout.collectionViewContentSize.height;
        self.vipCollectionView.hidden = NO;
        self.idCollectionView.hidden = YES;
    }else {
        [self.idCollectionView reloadData];
        [self.idCollectionView layoutSubviews];
        [self.idCollectionView layoutIfNeeded];
        self.idCollectionView.hidden = NO;
        self.vipCollectionView.hidden = YES;
        self.idCollectionViewHeight.constant=self.idCollectionView.collectionViewLayout.collectionViewContentSize.height;
    }
    
}
-(void)getMemberCentreMemberAllNumberIdRequest{
    GetMemberCentreAllNumberIdRequest*request=[GetMemberCentreAllNumberIdRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[MemberCentreNumberIdSellInfo class] success:^(NSArray<MemberCentreNumberIdSellInfo*>* response) {
        self.allMemberNumberIdArray = [NSMutableArray arrayWithArray:response];
        [self switchAction:nil];
        [self reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)getMyUserInfo{
    [[UserInfoManager sharedManager]getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [QMUITipsTool showOnlyTextWithMessage:@"BuySuccess".icanlocalized inView:nil];
        if (self.showMemberType == ShowMemberTypeNumberId) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KBuyNumberIdNotification object:nil];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:KBuyVIPNotification object:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end

//
//  TimelinesNoneImageTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesContentTableViewCell.h"
#import "DZTextView.h"
#import "XMFaceManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "FriendDetailViewController.h"
#import "ShowAppleMapLocationViewController.h"
#import "MessageMenuView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TFHpple.h"
#import "DZPlayerLayerView.h"
#import "VideoCacheManager.h"

@interface TimelinesContentTableViewCell ()<MessageMenuViewDelegate>
@property(nonatomic, strong) MessageMenuView *menuView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *limitImageView;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIView *firstLabelBgView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView  * firstAllButtonView;
@property (weak, nonatomic) IBOutlet UIButton *firstLabelAllButton;

@property (weak, nonatomic) IBOutlet UIView *secondtLabelBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelBgViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIView  * secondAllButtonView;
@property (weak, nonatomic) IBOutlet UIButton *secondLabelAllButton;

//点赞
@property(nonatomic,weak)  IBOutlet UIControl * goodBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * goodIconView;
@property(weak, nonatomic) IBOutlet UIView *goodJiangeView;
@property(nonatomic,weak)  IBOutlet UILabel * goodLabel;

//评论
@property(nonatomic,weak)  IBOutlet UIControl * commentBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * commentIconView;
@property(weak, nonatomic) IBOutlet UIView *commentJiangeView;
@property(nonatomic,weak)  IBOutlet UILabel * commentLabel;
//分享
@property(nonatomic,weak)  IBOutlet UIControl * shareBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * shareIconView;
@property(weak, nonatomic) IBOutlet UIView *shareJianView;
@property(nonatomic,weak)  IBOutlet UILabel * shareLabel;

//第一张照片
@property(nonatomic, weak) IBOutlet UIView * firstBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewHeight;
//第二组照片
@property(nonatomic, weak) IBOutlet UIView * secondBgView;
@property (weak,nonatomic) IBOutlet UIImageView *secondOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * secondTwoImageView;

//第三组照片
@property(nonatomic,weak) IBOutlet UIView * thirdBgView;
@property(weak,nonatomic) IBOutlet UIImageView *thirdOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * thirdTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * thirdThreeImageView;
//第四组照片
@property(nonatomic, weak) IBOutlet UIView * fourthBgView;
@property(weak, nonatomic) IBOutlet UIImageView *fourthOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthThreeImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fourthFourImageView;
//第五组照片
@property(nonatomic,weak) IBOutlet UIView * fifthBgView;
@property(weak,nonatomic) IBOutlet UIImageView *fifthOneImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthTwoImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthThreeImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthFourImageView;
@property(nonatomic,weak)  IBOutlet UIImageView * fifthFiveImageView;

@property(nonatomic,weak)  IBOutlet UIView * coverView;
@property(nonatomic,weak)  IBOutlet UILabel * numberLabel;

@property(nonatomic, assign) BOOL longPressFirst;


@end

@implementation TimelinesContentTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.hidden=YES;
    [self.headImageView layerWithCornerRadius:50/2 borderWidth:0 borderColor:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
    [self.rightImageView addGestureRecognizer:tap];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.headImageView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLocationAction)];
    [self.adressLabel addGestureRecognizer:tap2];
    
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
    self.firstImageView.layer.cornerRadius = 4;
    self.secondOneImageView.layer.cornerRadius = 4;
    self.secondTwoImageView.layer.cornerRadius = 4;
    self.thirdOneImageView.layer.cornerRadius = 4;
    self.thirdTwoImageView.layer.cornerRadius = 4;
    self.thirdThreeImageView.layer.cornerRadius = 4;
    self.fourthOneImageView.layer.cornerRadius = 4;
    self.fourthTwoImageView.layer.cornerRadius = 4;
    self.fourthThreeImageView.layer.cornerRadius = 4;
    self.fourthFourImageView.layer.cornerRadius = 4;
    self.fifthOneImageView.layer.cornerRadius = 4;
    self.fifthTwoImageView.layer.cornerRadius = 4;
    self.fifthThreeImageView.layer.cornerRadius = 4;
    self.fifthFourImageView.layer.cornerRadius = 4;
    self.fifthFiveImageView.layer.cornerRadius = 4;
    UILongPressGestureRecognizer*longPress1=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction1)];
    [self.firstLabel addGestureRecognizer:longPress1];
    UITapGestureRecognizer*toDetailtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetailVc)];
    [self.secondLabel addGestureRecognizer:toDetailtap];
    
    UILongPressGestureRecognizer*longPress2=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction2)];
    [self.secondLabel addGestureRecognizer:longPress2];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"HiddenTimelineMenuViewNotification" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        self.firstLabel.backgroundColor = [UIColor whiteColor];
        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
        
    }];
    [self.firstLabelAllButton setTitle:@"SeeMore".icanlocalized forState:UIControlStateNormal];
    self.goodBgView.layer.cornerRadius = 9;
    self.commentBgView.layer.cornerRadius = 9;
    self.shareBgView.layer.cornerRadius = 9;
}
-(void)toDetailVc{
    
}
-(void)longPressAction1{
    self.longPressFirst = YES;
    self.firstLabel.backgroundColor = UIColor238Color;
    [self.menuView showTimelineMenuView:self.firstLabelBgView convertRectView:self.firstLabel];
}
-(void)longPressAction2{
    self.longPressFirst = NO;

    [self.menuView showTimelineMenuView:self.secondtLabelBgView convertRectView:self.secondLabel];
}
-(void)clickLikeButtonAction{
    NSInteger loveNumber = _listRespon.loveNum ;
    self.goodIconView.image = _listRespon.love?[UIImage imageNamed:@"icon_timeline_praise_sel"]:[UIImage imageNamed:@"icon_timeline_praise_nor"];
    _listRespon.loveNum = loveNumber;
    if (loveNumber !=0) {
        self.goodLabel.text = [NSString stringWithFormat:@"%zd",_listRespon.loveNum];
        self.goodLabel.hidden=NO;
        self.goodJiangeView.hidden=NO;
    }else{
        self.goodLabel.hidden=YES;
        self.goodJiangeView.hidden=YES;
    }
    
    
}
-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[MessageMenuView alloc]init];
        _menuView.messageMenuViewDelegate=self;
    }
    return _menuView;
}
-(void)didClickMesageMenuViewDelegate:(MenuItem *)item{
    if (self.longPressFirst) {
        self.firstLabel.backgroundColor = UIColor.whiteColor;
        UIPasteboard*pas=[UIPasteboard generalPasteboard];
        pas.string=[self.firstLabel.attributedText string];
    }else{
        
        UIPasteboard*pas=[UIPasteboard generalPasteboard];
        pas.string=[self.secondLabel.attributedText string];
    }
    
}
-(void)rightAction{
    if (self.topRightBlock) {
        self.topRightBlock();
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    }
}
-(void)imageAction:(UITapGestureRecognizer *)tap{
    if (self.lookPictureBlock) {
        self.lookPictureBlock(tap.view.tag);
    }
    
}
- (void)showLocationAction {
    LocationMessageInfo *info = [[LocationMessageInfo alloc] init];
    NSArray *names = [_listRespon.location.name componentsSeparatedByString:@","];
    info.name = names[0];
    if(names.count > 0) {
        for(int i=0; i < names.count; i++) {
            if(i>1) {
                info.address = [NSString stringWithFormat:@"%@, %@",info.address, names[i]];
            }else {
                info.address =  names[i];
            }
        }
    }
    info.mapUrl = NULL;
    info.latitude = [_listRespon.location.latitude doubleValue];
    info.longitude = [_listRespon.location.longitude doubleValue];
    ShowAppleMapLocationViewController *locatinVC = [ShowAppleMapLocationViewController new];
    locatinVC.locationMessageInfo = info;
    [[AppDelegate shared] pushViewController:locatinVC animated:true];
}

-(void)tapAction{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = _listRespon.belongsId;
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared] pushViewController:vc animated:YES];
    
}

- (void)setListRespon:(TimelinesListDetailInfo *)listRespon {
    _listRespon = listRespon;
    self.firstImageViewHeight.constant = listRespon.oneImageHeight;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:listRespon.headImgUrl] placeholderImage:[listRespon.gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
    self.nameLabel.text = listRespon.nickName;
    if (listRespon.location) {
        self.adressLabel.hidden = NO;
        self.adressLabel.text = listRespon.location.name;
    }else{
        self.adressLabel.hidden = YES;
    }
    self.limitImageView.image = UIImageMake(listRespon.visibleRangeImgStr);
    self.timeLabel.text = [GetTime timelinesTime:listRespon.publishTime];
    // If there is content to share
    self.firstAllButtonView.hidden = self.secondAllButtonView.hidden = self.secondtLabelBgView.hidden = NO;
    self.firstLabelBgView.backgroundColor = self.secondtLabelBgView.backgroundColor = UIColor.whiteColor;
    // Set text to hide or show
    if (listRespon.sharedMessage) {
        self.secondtLabelBgView.backgroundColor = self.secondAllButtonView.backgroundColor = UIColorBg243Color;
        // there is a text input when sharing
        if (listRespon.content) {
            self.firstLabel.hidden = NO;
            self.secondtLabelBgView.backgroundColor = UIColorBg243Color;
            if (listRespon.showAllButton) {
                self.firstAllButtonView.hidden = NO;
                if (_listRespon.clickShowAllButton) {
                    self.firstAllButtonView.hidden = YES;
                    self.firstLabelBgViewHeight.constant = listRespon.originContentHeight;
                }else{
                    self.firstAllButtonView.hidden = NO;
                    self.firstLabelBgViewHeight.constant = listRespon.contentHeight;
                }
            }else{
                self.firstAllButtonView.hidden = YES;
                self.firstLabel.hidden = NO;
                self.firstLabelBgViewHeight.constant = listRespon.originContentHeight;
            }
        }else{
            self.firstLabelBgViewHeight.constant = 10;
            self.firstLabel.hidden = YES;
            self.firstAllButtonView.hidden = YES;
        }
        if (listRespon.showShareAllButton) {
            self.secondtLabelBgView.hidden = NO;
            if (listRespon.clickShareShowAllButton) {
                self.secondAllButtonView.hidden = YES;
                self.secondLabelBgViewHeight.constant = listRespon.originShareContentHeight;
            }else{
                self.secondLabelBgViewHeight.constant = listRespon.shareContentHeight;
                self.secondAllButtonView.hidden = NO;
            }
        }else{
            self.secondAllButtonView.hidden = YES;
            self.secondLabelBgViewHeight.constant = listRespon.originShareContentHeight;
        }
    }else{ // The original post was not shared
        self.secondtLabelBgView.backgroundColor = self.secondAllButtonView.backgroundColor = UIColor.whiteColor;
        self.secondAllButtonView.hidden = YES;
        self.secondtLabelBgView.hidden = YES;
        //is exists text
        if (listRespon.content.length > 0) {
            self.firstLabel.hidden = NO;
            if (listRespon.showAllButton) {
                if (listRespon.clickShowAllButton) {
                    self.firstLabelBgViewHeight.constant = listRespon.originContentHeight;
                    self.firstAllButtonView.hidden = YES;
                }else{
                    self.firstLabelBgViewHeight.constant = listRespon.contentHeight;
                    self.firstAllButtonView.hidden = NO;
                }
            }else{
                self.firstLabelBgViewHeight.constant = listRespon.originContentHeight;
                self.firstAllButtonView.hidden = YES;
            }
        }else{
            self.firstAllButtonView.hidden = YES;
            self.firstLabelBgViewHeight.constant = 10;
            self.firstLabel.hidden = YES;
        }
    }
    if (listRespon.loveNum != 0) {
        self.goodLabel.text = [NSString stringWithFormat:@"%zd",listRespon.loveNum];
        self.goodLabel.hidden = NO;
        self.goodJiangeView.hidden = NO;
    }else{
        self.goodLabel.hidden=YES;
        self.goodJiangeView.hidden=YES;
    }
    self.goodLabel.textColor = listRespon.love?UIColorMake(29, 129, 249):UIColor252730Color;
    self.goodIconView.image = listRespon.love?[UIImage imageNamed:@"icon_timeline_praise_sel"]:[UIImage imageNamed:@"icon_timeline_praise_nor"];
    self.commentIconView.image = listRespon.comment?[UIImage imageNamed:@"icon_timeline_comment_sel"]:[UIImage imageNamed:@"icon_timeline_comment_nor"];
    self.commentLabel.textColor = listRespon.comment?UIColorMake(29, 129, 249):UIColor252730Color;
    if ([listRespon.visibleRange isEqualToString:@"Open"]) {
        self.shareIconView.image = UIImageMake(@"icon_timeline_share_nor");
    }else{
        self.shareIconView.image = UIImageMake(@"icon_timeline_share_dis");
    }
    if (listRespon.commentNum != 0) {
        self.commentLabel.text = [NSString stringWithFormat:@"%zd",listRespon.commentNum];
        self.commentLabel.hidden = NO;
        self.commentJiangeView.hidden = NO;
    }else{
        self.commentLabel.hidden = YES;
        self.commentJiangeView.hidden = YES;
        self.commentLabel.text = @"";
    }
    self.shareLabel.hidden = self.shareJianView.hidden = YES;
    if (listRespon.imageUrls.count == 0) {
        if (listRespon.atPeopleItems.count > 0) {
            NSString *firstUrl = [[NSString alloc] init];
            if([listRespon.atPeopleItems[0] length] >= 8) {
                NSString *first8 = [listRespon.atPeopleItems[0] substringWithRange:NSMakeRange(0, 8)];
                if([first8 isEqualToString:@"https://"]) {
                    firstUrl = [self createThumbnailDetails:listRespon.atPeopleItems[0]];
                }else {
                    firstUrl = [self createThumbnailDetails: [NSString stringWithFormat:@"@%@%@",@"https://",listRespon.atPeopleItems[0]]];
                }
            }
            [self.firstImageView setImageWithString:firstUrl placeholder:DefaultImg];
            self.firstImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.firstBgView.hidden = NO;
            self.firstImageViewHeight.constant = 400;
        }else {
            self.firstBgView.hidden = YES;
        }
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (listRespon.imageUrls.count == 1) {
        NSString *firstUrl = listRespon.imageUrls[0];
        [self.firstImageView setImageWithString:firstUrl placeholder:DefaultImg];
        self.firstBgView.hidden = NO;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (listRespon.imageUrls.count == 2) {
        NSString *firstUrl = listRespon.imageUrls[0];
        NSString *secondUrl = listRespon.imageUrls[1];
        [self.secondOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.secondTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = NO;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (listRespon.imageUrls.count == 3) {
        NSString *firstUrl = listRespon.imageUrls[0];
        NSString *secondUrl = listRespon.imageUrls[1];
        NSString *threeUrl = listRespon.imageUrls[2];
        [self.thirdOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.thirdTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        [self.thirdThreeImageView setImageWithString:threeUrl placeholder:DefaultImg];
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = NO;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (listRespon.imageUrls.count == 4 ) {
        NSString *firstUrl = listRespon.imageUrls[0];
        NSString *secondUrl = listRespon.imageUrls[1];
        NSString *threeUrl = listRespon.imageUrls[2];
        NSString *fourUrl = listRespon.imageUrls[3];
        
        [self.fourthOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.fourthTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        [self.fourthThreeImageView setImageWithString:threeUrl placeholder:DefaultImg];
        [self.fourthFourImageView setImageWithString:fourUrl placeholder:DefaultImg];
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = NO;
        self.fifthBgView.hidden = YES;
    }else {
        NSString *firstUrl = listRespon.imageUrls[0];
        NSString *secondUrl = listRespon.imageUrls[1];
        NSString *threeUrl = listRespon.imageUrls[2];
        NSString *fourUrl = listRespon.imageUrls[3];
        NSString *fiveUrl = listRespon.imageUrls[4];
        
        [self.fifthOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.fifthTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        [self.fifthThreeImageView setImageWithString:threeUrl placeholder:DefaultImg];
        [self.fifthFourImageView setImageWithString:fourUrl placeholder:DefaultImg];
        [self.fifthFiveImageView setImageWithString:fiveUrl placeholder:DefaultImg];
        self.firstBgView.hidden = YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"+%lu",listRespon.imageUrls.count-5];
        self.coverView.hidden = listRespon.imageUrls.count < 6;
        self.numberLabel.hidden = listRespon.imageUrls.count < 6;
    }
    if (listRespon.content) {
        [self.firstLabel yb_addAttributeTapActionWithStrings:listRespon.atPeopleItems tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            for (NSDictionary*dict in listRespon.atDictItems) {
                if ([string isEqualToString:dict.allValues.firstObject]) {
                    NSString*userId = dict.allKeys.firstObject;
                    FriendDetailViewController * vc = [FriendDetailViewController new];
                    vc.userId = userId;
                    vc.friendDetailType=FriendDetailType_push;
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                    return;
                }
            }
            [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"Whethertoopen".icanlocalized,string] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index == 1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:string] options:@{} completionHandler:^(BOOL success) {
                    }];
                }
            }];
        }];
        self.firstLabel.attributedText = listRespon.contentLabelAttString;
    }
    if (listRespon.sharedMessage) {
        [self.secondLabel yb_addAttributeTapActionWithStrings:listRespon.atSharePeopleItems tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            for (NSDictionary *dict in listRespon.atShareDictItems) {
                if ([string isEqualToString:dict.allValues.firstObject]) {
                    NSString *userId = dict.allKeys.firstObject;
                    FriendDetailViewController *vc = [FriendDetailViewController new];
                    vc.userId = userId;
                    vc.friendDetailType=FriendDetailType_push;
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                    return;
                }
            }
            [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"Whethertoopen".icanlocalized,string] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index == 1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:string] options:@{} completionHandler:^(BOOL success) {
                    }];
                }
            }];
        }];
        self.secondLabel.attributedText = listRespon.shareContentLabelAttString;
    }
}

- (NSString *)createThumbnailDetails:(NSString *)url {
    NSString *thumbnailImageUrl;
    NSURL *webUrl = [NSURL URLWithString:url];
    NSData *htmlData = [NSData dataWithContentsOfURL:webUrl];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *metaNodes = [parser searchWithXPathQuery:@"//meta"];
    for (TFHppleElement *element in metaNodes) {
        if([[element.attributes objectForKey:@"property"] isEqualToString:@"og:image"]){
            thumbnailImageUrl = [element.attributes objectForKey:@"content"];
            break;
        }
    }
    return thumbnailImageUrl;
}

/**
 点赞
 */
- (IBAction)goodAction {
    NSInteger loveNumber = _listRespon.loveNum;
    if (!_listRespon.love) {
        _listRespon.love= YES;
        loveNumber++;
        self.goodLabel.textColor = UIColorMake(29, 129, 249);
    }else{
        _listRespon.love= NO;
        loveNumber--;
        self.goodLabel.textColor = UIColor252730Color;
    }
    _listRespon.loveNum=loveNumber;
    !self.tapBlock?:self.tapBlock(0);
}
/**
 评论
 */
- (IBAction)commentAction {
    !self.tapBlock?:self.tapBlock(1);
}
/**
 分享
 */
- (IBAction)shareAction {
    if ([_listRespon.visibleRange isEqualToString:@"Open"]) {
        !self.tapBlock?:self.tapBlock(2);
    }
}
- (IBAction)lookgoods {
    !self.tapBlock?:self.tapBlock(3);
    
}
-(IBAction)firstAllButtonAction{
    _listRespon.clickShowAllButton=YES;
    QMUITableView*tableView=(QMUITableView*)[self superview];
    [tableView reloadData];
}
-(IBAction)secondAllButtonAction{
    _listRespon.clickShareShowAllButton =YES;
    QMUITableView*tableView=(QMUITableView*)[self superview];
    [tableView reloadData];
    
}

@end

//
//  TimelinesNoneImageTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesDetailContentTableViewCell.h"
#import "DZTextView.h"
#import "XMFaceManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "FriendDetailViewController.h"
#import "ShowAppleMapLocationViewController.h"
@interface TimelinesDetailContentTableViewCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *limitImageView;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIView *firstTextViewBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *firstTextView;

@property (weak, nonatomic) IBOutlet UIView *secondTextViewBgView;
@property (weak, nonatomic) IBOutlet UITextView *secondTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTextViewHeight;


@property(nonatomic,weak)  IBOutlet UIControl * goodBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * goodIconView;
@property(weak, nonatomic) IBOutlet UIView *goodJiangeView;
@property(nonatomic,weak)  IBOutlet UILabel * goodLabel;


@property(nonatomic,weak)  IBOutlet UIControl * commentBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * commentIconView;
@property(weak, nonatomic) IBOutlet UIView *commentJiangeView;
@property(nonatomic,weak)  IBOutlet UILabel * commentLabel;

@property(nonatomic,weak)  IBOutlet UIControl * shareBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * shareIconView;
@property(weak, nonatomic) IBOutlet UIView *shareJianView;
@property(nonatomic,weak)  IBOutlet UILabel * shareLabel;
/** 查看多少人 */

@property(nonatomic, weak) IBOutlet UIView * lineGoodView;
@property(nonatomic,weak)  IBOutlet UIImageView *  lookGoodIconView;
@property(nonatomic,weak)  IBOutlet UILabel * lookGoodLabel;
@property(weak, nonatomic) IBOutlet UIControl *lookGoodCon;

//第一张照片
@property(nonatomic, weak) IBOutlet UIView * firstBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * firstImageView;
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

@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end

@implementation TimelinesDetailContentTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.hidden=YES;
    [self.headImageView layerWithCornerRadius:50/2 borderWidth:0 borderColor:nil];
    self.firstTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.secondTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.firstTextView.delegate = self;
    self.secondTextView.delegate = self;
    self.lookGoodLabel.text = @"Viewlikes".icanlocalized;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.headImageView addGestureRecognizer:tap1];
    
    self.adressLabel.userInteractionEnabled = YES;
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
    self.secondTextView.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorThemeMainColor};
    self.firstTextView.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorThemeMainColor};
    self.goodBgView.layer.cornerRadius = 9;
    self.commentBgView.layer.cornerRadius = 9;
    self.shareBgView.layer.cornerRadius = 9;
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
    info.address = _listRespon.location.name;
    info.mapUrl = NULL;
    info.latitude = [_listRespon.location.latitude doubleValue];
    info.longitude = [_listRespon.location.longitude doubleValue];
    ShowAppleMapLocationViewController *locatinVC = [ShowAppleMapLocationViewController new];
    locatinVC.locationMessageInfo = info;
    [[AppDelegate shared] pushViewController:locatinVC animated:true];
}

-(void)tapAction{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = self.listRespon.belongsId;
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared] pushViewController:vc animated:YES];
    
}

-(void)setListRespon:(TimelinesListDetailInfo *)listRespon{
    _listRespon = listRespon;
    self.firstImageViewHeight.constant = listRespon.oneImageHeight;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:listRespon.headImgUrl] placeholderImage:[listRespon.gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
    self.nameLabel.text = listRespon.nickName;
    if (listRespon.location) {
        self.adressLabel.hidden = NO;
        self.adressLabel.text= listRespon.location.name;
    }else{
        self.adressLabel.hidden = YES;
    }
    self.limitImageView.image = UIImageMake(listRespon.visibleRangeImgStr);
    self.timeLabel.text = [GetTime timelinesTime:listRespon.publishTime];
    if (listRespon.sharedMessage) {
        //firstTextView的文字内容是listRespon.content
        self.firstTextView.attributedText = listRespon.contenttextAttributedString;
        self.secondTextViewBgView.backgroundColor=UIColorBg243Color;
        self.secondTextView.attributedText = listRespon.shareContenttextAttributedString;
        self.firstTextViewBgView.hidden = NO;
        self.firstTextViewHeight.constant = listRespon.originContentHeight;
        if (self.listRespon.sharedMessage.content.length == 0) {//需要隐藏第二个secondTextView
            self.secondTextViewBgView.hidden = YES;
        }else{
            self.firstTextViewBgView.hidden = NO;
            self.secondTextViewHeight.constant = listRespon.originShareContentHeight;
        }
        
    }else{
        self.secondTextViewBgView.hidden = YES;
        self.secondTextViewBgView.backgroundColor = UIColor.whiteColor;
        self.firstTextView.attributedText = listRespon.contenttextAttributedString;
        self.firstTextViewHeight.constant = listRespon.originContentHeight;
        if (listRespon.content==0) {
            self.firstTextViewHeight.constant = 10;
        }
    }
    if (listRespon.loveNum !=0) {
        self.goodLabel.text = [NSString stringWithFormat:@"%zd",listRespon.loveNum];
        self.goodLabel.hidden=NO;
        self.goodJiangeView.hidden=NO;
    }else{
        self.goodLabel.hidden=YES;
        self.goodJiangeView.hidden=YES;
    }
    
    self.goodLabel.textColor = listRespon.love?UIColorMake(29, 129, 249):UIColor252730Color;
    self.goodIconView.image = listRespon.love?[UIImage imageNamed:@"icon_timeline_praise_sel"]:[UIImage imageNamed:@"icon_timeline_praise_nor"];
    self.commentIconView.image=listRespon.comment?[UIImage imageNamed:@"icon_timeline_comment_sel"]:[UIImage imageNamed:@"icon_timeline_comment_nor"];
    self.commentLabel.textColor = listRespon.comment?UIColorMake(29, 129, 249):UIColor252730Color;
    if ([listRespon.visibleRange isEqualToString:@"Open"]) {
        
        self.shareIconView.image = UIImageMake(@"icon_timeline_share_nor");
    }else{
        
        self.shareIconView.image = UIImageMake(@"icon_timeline_share_dis");
    }
    if (listRespon.commentNum!=0) {
        self.commentLabel.text = [NSString stringWithFormat:@"%zd",listRespon.commentNum];
        self.commentLabel.hidden = NO;
        self.commentJiangeView.hidden = NO;
    }else{
        self.commentLabel.hidden = YES;
        self.commentJiangeView.hidden = YES;
        self.commentLabel.text = @"";
    }
    self.shareLabel.hidden = self.shareJianView.hidden=YES;
    self.lookGoodCon.hidden = !self.listRespon.loveNum;
    self.lineGoodView.hidden = !self.listRespon.loveNum;
    
    if (listRespon.imageUrls.count ==0 ) {
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
        
    }else if (listRespon.imageUrls.count == 1 ) {
        NSString * firstUrl = listRespon.imageUrls[0];
        [self.firstImageView setImageWithString:firstUrl placeholder:DefaultImg];
        self.firstBgView.hidden =NO;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
        if (listRespon.videoUrl) {
            self.playImageView.hidden = NO;
        }
    }else if (listRespon.imageUrls.count == 2 ) {
        NSString * firstUrl = listRespon.imageUrls[0];
        NSString * secondUrl = listRespon.imageUrls[1];
        [self.secondOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.secondTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = NO;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = YES;
    }else if (listRespon.imageUrls.count == 3 ) {
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
        NSString * firstUrl = listRespon.imageUrls[0];
        NSString * secondUrl = listRespon.imageUrls[1];
        NSString * threeUrl = listRespon.imageUrls[2];
        NSString * fourUrl = listRespon.imageUrls[3];
        
        [self.fourthOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.fourthTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        [self.fourthThreeImageView setImageWithString:threeUrl placeholder:DefaultImg];
        [self.fourthFourImageView setImageWithString:fourUrl placeholder:DefaultImg];
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = NO;
        self.fifthBgView.hidden = YES;
    }else {
        NSString * firstUrl = listRespon.imageUrls[0];
        NSString * secondUrl = listRespon.imageUrls[1];
        NSString * threeUrl = listRespon.imageUrls[2];
        NSString * fourUrl = listRespon.imageUrls[3];
        NSString * fiveUrl = listRespon.imageUrls[4];
        
        [self.fifthOneImageView setImageWithString:firstUrl placeholder:DefaultImg];
        [self.fifthTwoImageView setImageWithString:secondUrl placeholder:DefaultImg];
        [self.fifthThreeImageView setImageWithString:threeUrl placeholder:DefaultImg];
        [self.fifthFourImageView setImageWithString:fourUrl placeholder:DefaultImg];
        [self.fifthFiveImageView setImageWithString:fiveUrl placeholder:DefaultImg];
        self.firstBgView.hidden =YES;
        self.secondBgView.hidden = YES;
        self.thirdBgView.hidden = YES;
        self.fourthBgView.hidden = YES;
        self.fifthBgView.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"+%lu",listRespon.imageUrls.count-5];
        self.coverView.hidden = listRespon.imageUrls.count<6;
        self.numberLabel.hidden =listRespon.imageUrls.count<6;
    }
    
}


/**
 点赞
 */
- (IBAction)goodAction {
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
    if ([self.listRespon.visibleRange isEqualToString:@"Open"]) {
        !self.tapBlock?:self.tapBlock(2);
    }
}
- (IBAction)lookgoods {
    !self.tapBlock?:self.tapBlock(3);
    
}
//mailto:1257346646@qq.com 如果是email
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([URL.absoluteString containsString:@"icanuseid"]) {
        FriendDetailViewController * vc = [FriendDetailViewController new];
        vc.userId = [URL.absoluteString componentsSeparatedByString:@"_"].lastObject;
        vc.friendDetailType=FriendDetailType_push;
        [[AppDelegate shared] pushViewController:vc animated:YES];
        return NO;
    }else{
        [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"Whethertoopen".icanlocalized,URL.absoluteString] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                [[UIApplication sharedApplication]openURL:URL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }];
    }
    return NO;
}
@end

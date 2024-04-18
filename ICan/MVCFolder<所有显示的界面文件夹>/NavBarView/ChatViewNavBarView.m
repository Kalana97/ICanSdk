//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2019/11/20
 - ICan
 - File name:  ChatViewNavBarView.m
 - Description:
 - Function List:
 */


#import "ChatViewNavBarView.h"

@interface ChatViewNavBarView ()
@property (weak, nonatomic) IBOutlet UIView *bottonLineView;
/** ican的用户信息 */
@property(nonatomic, strong) UserMessageInfo *userMessageInfo;
@property(nonatomic, assign) BOOL dislikeMe;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property(nonatomic, strong) GroupListInfo *groupInfo;
/** 交友的用户信息 */
@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
/** 交友的用户信息 */
@property(nonatomic, strong) C2CUserInfo *c2cUserInfo;
@end
@implementation ChatViewNavBarView
-(void)awakeFromNib{
    [super awakeFromNib];
    if (WebSocketManager.sharedManager.hasNewWork == NO) {
        self.statusLabel.hidden = YES;
        self.statusImageView.hidden = YES;
    }
    self.backgroundColor = UIColorMakeHEXCOLOR(0xF6F6F6);
    self.bottonLineView.backgroundColor =  UIColorMakeHEXCOLOR(0xE0E0E0);
    self.nameLabel.textColor = UIColorThemeMainTitleColor;
    self.countLabel.textColor = UIColorThemeMainTitleColor;
    self.statusLabel.textColor = UIColorThemeMainSubTitleColor;
    [self.cancleButton setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImageViewTapAction)];
    self.iconImageView.userInteractionEnabled=YES;
    [self.iconImageView addGestureRecognizer:tap];
    self.viewBg.userInteractionEnabled=YES;
    [self.viewBg addGestureRecognizer:tap];
    [self.moreButton setBackgroundImage:UIImageMake(@"more") forState:UIControlStateNormal];
}
-(void)iconImageViewTapAction{
    if (self.iconImageViewTapBlock) {
        self.iconImageViewTapBlock();
    }
}

-(IBAction)buttonAction:(UIButton*)button{
    !self.chatViewNavBarViewButtonBlock?:self.chatViewNavBarViewButtonBlock(button.tag);
}
-(void)updateUiAfterSelectMore{
    self.voiceButton.hidden=
    self.videoButton.hidden=
    self.leftArrowButton.hidden=
    self.statusImageView.hidden=
    self.iconImageView.hidden=
    self.nameLabel.hidden=
    self.statusLabel.hidden=YES;
    self.cancleButton.hidden=NO;
    self.moreButton.hidden=YES;
}
-(void)updateUIWith:(UserMessageInfo*)userMessageInfo authorityType:(NSString*)authorityType{
    self.authorityType=authorityType;
    self.userMessageInfo=userMessageInfo;
    //自己是不是我行客服
    BOOL myIsService = UserInfoManager.sharedManager.cs;
    // 自己是不是钻石VIP
    BOOL isDiamond = UserInfoManager.sharedManager.diamondValid;
    //自己是不是第三方客服
    BOOL myIsThirdService = UserInfoManager.sharedManager.thirdPartySystemAppId.length>0&&myIsService;
    //对方是不是我行客服
    BOOL otherIsService = userMessageInfo.cs;
    //对方是不是第三方客服
    BOOL otherIsThirdService = userMessageInfo.thirdPartySystemAppId.length>0&&otherIsService;
    //如果不是好友 判断对方是不是钻石VIP
    NSTimeInterval current = [[NSDate date]timeIntervalSince1970]*1000;
    NSTimeInterval diamondTime = userMessageInfo.diamondMemberExpiration.floatValue;
    //对方是不是钻石会员
    BOOL otherDiamond = diamondTime>current;
    //如果被对方拉黑，将不能进行操作
    if (userMessageInfo.beBlock) {
        self.videoButton.enabled = NO;
        self.voiceButton.enabled = NO;
        self.moreButton.enabled  = NO;
        if([self.userNavType  isEqual: @"Seller"]){
            self.videoButton.hidden  = NO;
            self.voiceButton.hidden  = NO;
            self.videoButton.enabled = YES;
            self.voiceButton.enabled = YES;
        }else{
            self.videoButton.hidden  = NO;
            self.voiceButton.hidden  = NO;
        }
        self.moreButton.hidden   = NO;
        
        if([userMessageInfo.remarkName isEqual:@""] || userMessageInfo.remarkName == nil){
            self.nameLabel.text = userMessageInfo.nickname;
        }else{
            self.nameLabel.text = userMessageInfo.remarkName;
        }
        
        [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
    }else{
        if ([authorityType isEqualToString:AuthorityType_friend]) {
            ///如果是好友
            if (userMessageInfo.isFriend) {
                if([self.userNavType  isEqual: @"Seller"]){
                    self.voiceButton.hidden = NO;
                    self.videoButton.hidden = NO;
                }else{
                    self.voiceButton.hidden =! [UserInfoManager sharedManager].cloudLetterVoice;
                    self.videoButton.hidden =! [UserInfoManager sharedManager].cloudLetterVideo;
                }
                self.moreButton.hidden = NO;
            }else{
                if (myIsService||otherIsService||otherIsThirdService||myIsThirdService) {
                    self.voiceButton.hidden = NO;
                    self.videoButton.hidden = NO;
                    self.moreButton.hidden = NO;
                }else{
                    if (UserInfoManager.sharedManager.diamondValid) {
                        if([self.userNavType  isEqual: @"Seller"]){
                            self.voiceButton.hidden = NO;
                            self.videoButton.hidden = NO;
                        }else{
                            self.voiceButton.hidden =! [UserInfoManager sharedManager].cloudLetterVoice;
                            self.videoButton.hidden =! [UserInfoManager sharedManager].cloudLetterVideo;
                        }
                        self.moreButton.hidden = NO;
                    }else{
                        self.videoButton.enabled = NO;
                        self.voiceButton.enabled = NO;
                        self.moreButton.enabled  = NO;
                    }
                }
            }
            if([userMessageInfo.remarkName isEqual:@""] || userMessageInfo.remarkName == nil){
                self.nameLabel.text = userMessageInfo.nickname;
            }else{
                self.nameLabel.text = userMessageInfo.remarkName;
            }
            
            [self.iconImageView setDZIconImageViewWithUrl:userMessageInfo.headImgUrl gender:userMessageInfo.gender];
        }else if ([authorityType isEqualToString:AuthorityType_secret]){
            self.videoButton.hidden = YES;
            self.voiceButton.hidden = YES;
            if([userMessageInfo.remarkName isEqual:@""] || userMessageInfo.remarkName == nil){
                self.nameLabel.text = userMessageInfo.nickname;
            }else{
                self.nameLabel.text = userMessageInfo.remarkName;
            }
            [self.iconImageView setDZIconImageViewWithUrl:KSecretHeadImg gender:userMessageInfo.gender];
            [self.moreButton setBackgroundImage:UIImageMake(@"icon_chatView_private_del") forState:UIControlStateNormal];
        }
    }
    
}
-(void)updateUiAfterClickCancelButton:(NSString *)authorityType groupUserInfo:(GroupListInfo *)groupInfo{
    [self updateUIWith:self.userMessageInfo authorityType:authorityType];
    [self updateUiWithGroupInfo:groupInfo];
    self.leftArrowButton.hidden=
    self.statusLabel.hidden=
    self.statusImageView.hidden=
    self.statusLabel.hidden=
    self.iconImageView.hidden=
    self.nameLabel.hidden=NO;
    self.cancleButton.hidden=YES;
    
}
-(void)updateButtonStatusWithC2CUserInfo:(C2CUserInfo*)c2cUserInfo{
    self.c2cUserInfo = c2cUserInfo;
    self.nameLabel.text=c2cUserInfo.nickname;
    self.voiceButton.hidden = YES;
    self.videoButton.hidden = YES;
    self.moreButton.hidden  = YES;
    self.statusLabel.hidden = self.statusImageView.hidden = YES;
    [self.iconImageView setCircleIconImageViewWithUrl:c2cUserInfo.headImgUrl gender:@"Male"];
}
-(void)updateButtonStatusWith:(GetCircleDislikeMeInfo*)dislikeMeInfo circleUserInfo:(CircleUserInfo*)circleUserInfo{
    if (circleUserInfo) {
        self.circleUserInfo=circleUserInfo;
        if (circleUserInfo.deleted) {
            self.nameLabel.text=[NSString stringWithFormat:@"%@(%@)",circleUserInfo.nickname,@"ChatViewNavBarView.userDeleted".icanlocalized];
        }else{
            self.nameLabel.text=circleUserInfo.nickname;
        }
        
        [self.iconImageView setCircleIconImageViewWithUrl:circleUserInfo.avatar gender:circleUserInfo.gender];
    }
    
    if (circleUserInfo.deleted||dislikeMeInfo.dislikeMe) {
        self.videoButton.hidden=YES;
        self.voiceButton.hidden = YES;
        self.moreButton.hidden=YES;
    }else{
        if([self.userNavType  isEqual: @"Seller"]){
            self.videoButton.hidden = NO;
            self.voiceButton.hidden = NO;
        }else{
            self.videoButton.hidden = NO;
            self.voiceButton.hidden = NO;
        }
        self.moreButton.hidden = YES;
    }
}
/// 用户是否在线
/// @param onlineInfo onlineInfo description
-(void)updateUserOnline:(CheckUserOnlineInfo*)onlineInfo{
    NSString* offLineMessage=[GetTime getShowLastLoginTime:onlineInfo.lastOnlineTime];
    self.statusLabel.text=onlineInfo.online?NSLocalizedString(@"Online", 在线):offLineMessage;
    self.statusImageView.image=onlineInfo.online?UIImageMake(@"chat_online"):UIImageMake(@"chat_offline");
        self.statusLabel.hidden = NO;
        self.statusImageView.hidden = NO;
}

-(void) hideCallItems{
    self.userNavType = @"Seller";
    self.statusLabel.hidden = YES;
    self.statusImageView.hidden = YES;
    self.voiceButton.hidden = YES;
    self.videoButton.hidden = YES;
}
-(void) disableCallItems{
    self.userNavType = @"Seller";
    self.statusLabel.enabled = NO;
    self.statusImageView.enableMode = NO;
    self.voiceButton.enabled = NO;
    self.videoButton.enabled = NO;
}
-(void) hideMoreItems{
    self.moreButton.hidden = YES;
}

-(void)showMoreItems{
    self.moreButton.hidden = FALSE;
}

-(void)updateUiWithGroupInfo:(GroupListInfo*)groupInfo{
    if (groupInfo) {
        if (groupInfo.name){
            if(groupInfo.userCount){
                self.nameLabel.text = [NSString stringWithFormat:@"%@",groupInfo.name];
                self.countLabel.text = [NSString stringWithFormat:@"(%@)",groupInfo.userCount];
            }else{
                self.nameLabel.text = [NSString stringWithFormat:@"%@",groupInfo.name];
            }
        }else{
            self.nameLabel.text = @"";
        }
        self.moreButton.hidden=!groupInfo.isInGroup;
        self.statusImageView.hidden = YES;
        self.statusLabel.hidden = YES;
        [self.iconImageView setImageWithString:groupInfo.headImgUrl placeholder:GroupDefault];
    }
    if(groupInfo.mutedByAdmin == YES){
        self.moreButton.hidden = NO;
    }
    self.videoButton.hidden = self.voiceButton.hidden=YES;
}

@end

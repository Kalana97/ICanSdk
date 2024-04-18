//
//  TimelinesNoneImageTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesContentVideoTableViewCell.h"
#import "DZTextView.h"
#import "XMFaceManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "FriendDetailViewController.h"
#import "ShowAppleMapLocationViewController.h"
#import "MessageMenuView.h"
#import <ReactiveObjC/ReactiveObjC.h>

#import "DZPlayerLayerView.h"
#import "VideoCacheManager.h"
@interface TimelinesContentVideoTableViewCell ()<MessageMenuViewDelegate>
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
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageViewHeight;
@property(nonatomic, weak) IBOutlet DZPlayerLayerView * layerView;

@property(nonatomic, assign) BOOL longPressFirst;

@property(nonatomic, strong) AVPlayerItem * playerItem;
@property(nonatomic, strong) AVPlayerLayer * playerLayer;

@property(nonatomic, strong) AVPlayer * player;




@end

@implementation TimelinesContentVideoTableViewCell

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
    [self.firstImageView addGestureRecognizer:imageTap1];
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
    [self.layerView addPlayerLayer:self.playerLayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.goodBgView.layer.cornerRadius = 9;
    self.commentBgView.layer.cornerRadius = 9;
    self.shareBgView.layer.cornerRadius = 9;
}
-(void)setListRespon:(TimelinesListDetailInfo *)listRespon{
    _listRespon = listRespon;
    [self stopPlay];
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
    //如果存在分享的内容
    self.firstAllButtonView.hidden =
    self.secondAllButtonView.hidden = self.secondtLabelBgView.hidden = NO;
    self.firstLabelBgView.backgroundColor = self.secondtLabelBgView.backgroundColor = UIColor.whiteColor;
    //设置文字隐藏或者显示
    if (listRespon.sharedMessage) {
        self.secondtLabelBgView.backgroundColor = self.secondAllButtonView.backgroundColor = UIColorBg243Color;
        //并且存在分享时候 输入了文字
        if (listRespon.content) {
            self.firstLabel.hidden = NO;
            self.secondtLabelBgView.backgroundColor = UIColorBg243Color;
            if (listRespon.showAllButton) {
                self.firstAllButtonView.hidden = NO;
                if (self.listRespon.clickShowAllButton) {
                    self.firstAllButtonView.hidden = YES;
                    self.firstLabelBgViewHeight.constant = listRespon.originContentHeight;
                }else{
                    self.firstAllButtonView.hidden = NO;
                    self.firstLabelBgViewHeight.constant = listRespon.contentHeight;
                    
                }
            }else{
                self.firstAllButtonView.hidden=YES;
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
    }else{//原帖子并没有被分享
        self.secondtLabelBgView.backgroundColor = self.secondAllButtonView.backgroundColor = UIColor.whiteColor;
        self.secondAllButtonView.hidden = YES;
        self.secondtLabelBgView.hidden = YES;
        //存在文字
        if (listRespon.content.length>0) {
            
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
    NSString * firstUrl = listRespon.imageUrls[0];
    [self.firstImageView setImageWithString:firstUrl placeholder:DefaultImg];
    self.shareLabel.hidden = self.shareJianView.hidden=YES;
    self.playIcon.hidden = NO;
    self.layerView.hidden = YES;
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
                if (index==1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:string] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }];
        }];
        self.firstLabel.attributedText = listRespon.contentLabelAttString;
    }
    if (listRespon.sharedMessage) {
        [self.secondLabel yb_addAttributeTapActionWithStrings:listRespon.atSharePeopleItems tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            for (NSDictionary*dict in listRespon.atShareDictItems) {
                if ([string isEqualToString:dict.allValues.firstObject]) {
                    NSString*userId=dict.allKeys.firstObject;
                    FriendDetailViewController * vc = [FriendDetailViewController new];
                    vc.userId = userId;
                    vc.friendDetailType=FriendDetailType_push;
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                    return;
                }
            }
            [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"Whethertoopen".icanlocalized,string] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:string] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }];
        }];
        self.secondLabel.attributedText = listRespon.shareContentLabelAttString;
    }
    
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
    NSInteger loveNumber =self.listRespon.loveNum ;
    self.goodIconView.image = self.listRespon.love?[UIImage imageNamed:@"icon_timeline_praise_sel"]:[UIImage imageNamed:@"icon_timeline_praise_nor"];
    self.listRespon.loveNum = loveNumber;
    if (loveNumber !=0) {
        self.goodLabel.text = [NSString stringWithFormat:@"%zd",self.listRespon.loveNum];
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
    vc.userId = self.listRespon.belongsId;
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared] pushViewController:vc animated:YES];
    
}




/**
 点赞
 */
- (IBAction)goodAction {
    NSInteger loveNumber = self.listRespon.loveNum;
    if (!self.listRespon.love) {
        self.listRespon.love= YES;
        loveNumber++;
        self.goodLabel.textColor = UIColorMake(29, 129, 249);
    }else{
        self.listRespon.love= NO;
        loveNumber--;
        self.goodLabel.textColor = UIColor252730Color;
    }
    self.listRespon.loveNum=loveNumber;
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
-(IBAction)firstAllButtonAction{
    self.listRespon.clickShowAllButton=YES;
    QMUITableView*tableView=(QMUITableView*)[self superview];
    [tableView reloadData];
}
-(IBAction)secondAllButtonAction{
    self.listRespon.clickShareShowAllButton =YES;
    QMUITableView*tableView=(QMUITableView*)[self superview];
    [tableView reloadData];
    
}
-(void)startPlay{
    [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:self.listRespon.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
        
        AVPlayerItem * item ;
        if (hasCache) {
            item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:data]];
        }else{
            item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.listRespon.videoUrl]];
        }
        self.playerItem = item;
        [self addObserverWithPlayerItem:item];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        self.player.muted=YES;
        self.playIcon.hidden=YES;
        self.layerView.hidden=NO;
        ///注意object 只能是AVPlayerItem:  self.player.currentItem
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        ///设置当前的播放模式是不打断其他APP的播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        ///恢复其他APP的音频播放
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        [self.player play];
    }];
    
}
-(void)stopPlay{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.layerView.hidden=YES;
    [self.player pause];
    self.playIcon.hidden=NO;
    self.playerItem=nil;
    //恢复其他的APP播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    });
}
-(void)resumePlay{
    ///设置当前的播放模式是不打断其他APP的播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    ///恢复其他的APP播放
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [self.player play];
    
}
-(AVPlayer *)player{
    if (!_player) {
        _player=[[AVPlayer alloc]init];
    }
    return _player;
}
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame=CGRectMake(0, 0, ScreenWidth, 320);
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        //AVLayerVideoGravityResizeAspectFill 视频充满
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
    }
    return _playerLayer;
}
#pragma mark - 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    if (playerItem) {
        //        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//移除观察者
- (void)removeObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    //    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (Float64)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    Float64 startSeconds        = CMTimeGetSeconds(timeRange.start);
    Float64 durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    Float64 result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
// 监听变化方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        Float64 timeInterval = [self availableDuration];
        CMTime duration             = self.playerItem.duration;
        Float64 totalDuration       = CMTimeGetSeconds(duration);
        if (totalDuration >0) {
            float progress = timeInterval/totalDuration;
            if (progress >=0.9) {
                // 当缓冲好的时候
                if ([VideoCacheManager sharedCacheManager].downloadConcurrentQueue.isSuspended) {
                    [[VideoCacheManager sharedCacheManager].downloadConcurrentQueue setSuspended:NO];
                }
            }
        }
    }
}


-(void)playbackFinished:(NSNotification *)notification{
    // 播放完成后重复播放 跳到最新的时间点开始播放
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}
@end

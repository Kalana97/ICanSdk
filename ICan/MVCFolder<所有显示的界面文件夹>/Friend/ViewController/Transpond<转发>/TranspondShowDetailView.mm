//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 28/10/2019
 - File name:  TranspondDetailView.m
 - Description:
 - Function List:
 */


#import "TranspondShowDetailView.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "ChatListModel.h"
static NSString *const KTranspondDetailIconCollectionViewCell = @"TranspondDetailIconCollectionViewCell";
@interface TranspondDetailIconCollectionViewCell  : UICollectionViewCell
@property(nonatomic, strong) DZIconImageView *iconImageView;
@end
@implementation TranspondDetailIconCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:5 borderWidth:0 borderColor: nil];
    }
    return _iconImageView;
}
@end
@interface TranspondShowDetailView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet  UIView * containBgView;
@property (nonatomic, weak) IBOutlet  UILabel *headerTitleLabel;
//转发给单个人
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;

//转发给多人
@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

//转发的内容labe
@property (weak, nonatomic) IBOutlet UILabel  *contentTextLable;
//转发的是图片
@property (weak, nonatomic) IBOutlet UIView *contentImageVIewBgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
/** 转发的是视频的时候的提示imageView */
@property (nonatomic, weak) IBOutlet UIImageView *videoTipsImageView;
@property (nonatomic, weak) IBOutlet UIButton * sendButton;
@property (nonatomic, weak) IBOutlet UIButton * cancleButton;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@end
@implementation TranspondShowDetailView
-(void)awakeFromNib{
    [super awakeFromNib];
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.messageTextField layerWithCornerRadius:3 borderWidth:1 borderColor:UIColorSeparatorColor];
    [self.cancleButton setTitle:@"Cancel".icanlocalized forState:(UIControlStateNormal)];
    [self.sendButton setTitle:NSLocalizedString(@"Send", 发送) forState:(UIControlStateNormal)];
    self.messageTextField.placeholder = NSLocalizedString(@"LeaveMessage", 给朋友留言);
    [self.collectionView registerClass:[TranspondDetailIconCollectionViewCell class] forCellWithReuseIdentifier:KTranspondDetailIconCollectionViewCell];
}


-(void)setSelectMessageArray:(NSMutableArray *)selectMessageArray{
    _selectMessageArray=selectMessageArray;
    self.contentTextLable.hidden = NO;
    self.contentImageVIewBgView.hidden = YES;
    if (selectMessageArray.count == 1) {
        ChatModel*model=selectMessageArray.firstObject;
        NSString *type = model.messageType;
        if ([type isEqualToString:@"Image_Share"]) {
            self.contentImageVIewBgView.hidden = NO;
            self.contentTextLable.hidden = YES;
            self.contentImageView.image=[UIImage imageWithData:model.orignalImageData];
        }else if ([type containsString:ImageMessageType]) {// 图片消息
            self.contentImageVIewBgView.hidden = NO;
            self.contentTextLable.hidden = YES;
            if (model.isOutGoing) {
                NSString *imgCachePath = [ MessageImageCache(model.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"small_%@",model.fileCacheName]];
                self.contentImageView.image=[UIImage imageWithContentsOfFile:imgCachePath];
            }else{
                ImageMessageInfo*info=[ImageMessageInfo mj_objectWithKeyValues:model.messageContent];
                NSString*url=[NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_%.f,w_%.f,limit_1",info.imageUrl,600.0,(info.width/info.height)*600.0];
                [self.contentImageView setImageWithString:url placeholder:BoyDefault];
            }
            
        }else if ([type isEqualToString:VideoMessageType]){
            self.contentImageVIewBgView.hidden = NO;
            self.contentTextLable.hidden = YES;
            if (model.isOutGoing) {
                //获取本地资源缓存路径
                NSString *imgCachePath = [ MessageImageCache(model.chatID) stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[model.fileCacheName componentsSeparatedByString:@"."].firstObject]];
                NSData *imageData = [NSData dataWithContentsOfFile:imgCachePath];
                if (imageData.length ) {
                    self.contentImageView.image=[UIImage imageWithData:imageData];
                }else{
                    VideoMessageInfo*videoInfo=[VideoMessageInfo mj_objectWithKeyValues:model.messageContent];
                    [self.contentImageView setImageWithString:videoInfo.content placeholder:nil];
                }
            }else{
                VideoMessageInfo*videoInfo=[VideoMessageInfo mj_objectWithKeyValues:model.messageContent];
                [self.contentImageView setImageWithString:videoInfo.content placeholder:nil];
            }
        }  else if([type isEqualToString:TextMessageType]||[type isEqualToString:GamifyMessageType]||[type isEqualToString:AtAllMessageType]||[type isEqualToString:AtSingleMessageType]||[type isEqualToString:URLMessageType]||[type isEqualToString:AIMessageType]||[type isEqualToString:AIMessageQuestionType]){
            if ([model.showMessage containsString:@"Gamify_DICE_"]){
                self.contentTextLable.text = NSLocalizedString(@"GameTips",[ 图片 ]);
            }else {
                self.contentTextLable.text = model.showMessage;
            }
        }else if ([type isEqualToString:LocationMessageType]){
            LocationMessageInfo *locationInfoModel = [LocationMessageInfo mj_objectWithKeyValues:model.messageContent];
            NSString*locationStr=[NSString stringWithFormat:@"[%@]%@",NSLocalizedString(@"Location", 位置),locationInfoModel.name];
            self.contentTextLable.text = locationStr;
            
        }else if ([type isEqualToString:UserCardMessageType]){
            UserCardMessageInfo *userMessageInfo = [UserCardMessageInfo mj_objectWithKeyValues:model.messageContent];
            NSString*locationStr=[NSString stringWithFormat:@"[%@]%@",@"chatView.function.contactCard".icanlocalized,userMessageInfo.nickname];
            self.contentTextLable.text = locationStr;
        }else if([type isEqualToString:FileMessageType]){
            FileMessageInfo * fileInfo=[FileMessageInfo mj_objectWithKeyValues:model.messageContent];
            self.contentTextLable.text = [NSString stringWithFormat:@"[%@]%@",NSLocalizedString(@"File", 文件),fileInfo.name];
        }else if ([type isEqualToString:kChatOtherShareType]){
            ChatOtherUrlInfo*info=[ChatOtherUrlInfo mj_objectWithKeyValues:model.messageContent];
            self.contentTextLable.hidden = NO;
            self.contentImageVIewBgView.hidden = NO;
            self.contentTextLable.text = info.content;
            [self.contentImageView setImageWithString:info.imageUrl placeholder:nil];
        }else if ([type isEqualToString:kChat_PostShare]){
            //帖子
            self.contentTextLable.text = @"ChatViewController.replyText".icanlocalized;
        }
    } else {
        self.contentImageVIewBgView.hidden = YES;
        self.contentTextLable.hidden = NO;
        self.contentTextLable.text = [NSString stringWithFormat:@"[%@]%@ %ld %@",@"Repost one by one".icanlocalized,@"Total".icanlocalized, selectMessageArray.count,@"MessageMuch".icanlocalized];
    }
    
    
}
- (void)setUserArr:(NSArray *)userArr {
    _userArr =[userArr copy];
    if (_userArr.count == 1) {
        self.collectionView.hidden = YES;
        self.iconBgView.hidden = NO;
        self.headerTitleLabel.text = NSLocalizedString(@"SendTo", 发送给);
        id obj=userArr.firstObject;
        if ([obj isKindOfClass:[ChatListModel class]]) {
            ChatListModel*chatList=obj;
            if ([chatList.chatType isEqualToString:GroupChat]) {//群聊
                [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatList.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                    [self.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
                    self.nameLabel.text=[NSString stringWithFormat:@"%@(%@人)",info.name,info.userCount];
                }];
            }else{//单聊
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatList.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                    [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
                    self.nameLabel.text=[NSString stringWithFormat:@"%@",info.remarkName?:info.nickname];
                }];
            }
        }else if ([obj isKindOfClass:[GroupListInfo class]]){
            GroupListInfo*info=obj;
            if (info.userCount) {
                self.nameLabel.text=[NSString stringWithFormat:@"%@(%@人)",info.name,info.userCount];
            }else{
                self.nameLabel.text=[NSString stringWithFormat:@"%@",info.name];
            }
            [self.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
           
        }else{
            UserMessageInfo*info=obj;
            [self.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
            self.nameLabel.text=[NSString stringWithFormat:@"%@",info.remarkName?:info.nickname];
        }
        
    } else {
        self.collectionView.hidden = NO;
        self.iconBgView.hidden = YES;
        self.headerTitleLabel.text= @"Send separately to".icanlocalized;
        [self.collectionView reloadData];
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//设置section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TranspondDetailIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KTranspondDetailIconCollectionViewCell forIndexPath:indexPath];
    id obj=[self.userArr objectAtIndex:indexPath.item];
    if ([obj isKindOfClass:[ChatListModel class]]) {
        ChatListModel*chatList=obj;
        if ([chatList.chatType isEqualToString:GroupChat]) {//群聊
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatList.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                [cell.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
                
            }];
        }else{//单聊
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatList.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                [cell.iconImageView setImageWithString:info.headImgUrl placeholder:BoyDefault];
                
            }];
        }
    }else if ([obj isKindOfClass:[GroupListInfo class]]){
        GroupListInfo*info=obj;
        [cell.iconImageView setImageWithString:info.headImgUrl placeholder:GroupDefault];
    }else{
        UserMessageInfo*info=obj;
        [cell.iconImageView setImageWithString:info.headImgUrl placeholder:info.gender];
    }
    
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}


- (IBAction)cancelAction {
    [IQKeyboardManager sharedManager].enable = YES;
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [self endEditing:YES];
    [self hidden];
}
- (IBAction)sendAction {
    [IQKeyboardManager sharedManager].enable = YES;
    [self endEditing:YES];
    [self hidden];
    //如果用户输入了文字 那么创建多一个text类型的model
    ChatModel*model;
    if (self.messageTextField.text.length != 0 && [self.messageTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0) {
        model=[[ChatModel alloc]init];
        model.showMessage=self.messageTextField.text;
        model.messageType=TextMessageType;
        [self.selectMessageArray addObject:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kForwardingSendMessageNotification object:nil];
    if (self.sendBlock) {
        self.sendBlock(model);
    }
}

- (void)showTranspondDetailView{
    [IQKeyboardManager sharedManager].enable = NO;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
}
- (void)kbWillShow:(NSNotification *)noti {
    //显示的时候改变bottomContraint
    // 获取键盘高度
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.containBgView.centerY = (self.height - self.containBgView.height) / 2 > kbHeight ? self.centerY : self.height - kbHeight - self.containBgView.height / 2;
}

- (void)kbWillHide:(NSNotification *)noti {
    self.containBgView.centerY = self.centerY;
}


- (void)hidden {
    [self removeFromSuperview];
}

@end

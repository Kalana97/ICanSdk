//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/10/5
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  ChatFunctionView.m
 - Description:
 - Function List:
 - History:
 */


#import "ChatFunctionView.h"
#import "UIButton+HYQUIButton.h"
#import "UIView+HYQEx.h"
#import "ChatRecordTool.h"
#import "ChatMoreTagItem.h"
#import "ChatAlbumModel.h"
#import "PrivacyPermissionsTool.h"
#import "VoicePlayerTool.h"
#import "EmojyShowView.h"

#define kMaxHeight 100.0f
#define DefaultTextViewHeight 40
#define MaxTextViewHeight 96
#define DetaultChatBarBackGroundViewHeight 57
static CGFloat const KMoreViewHeight=180;
static CGFloat const KFaceViewHeight=300;
typedef NS_ENUM(NSInteger,ActionType){
    ActionType_More = 0,
    ActionType_Photograp,
    ActionType_Album,
    ActionType_Voice,
    ActionType_Face,
    ActionType_Send,
    ActionType_Reset,
    ActionType_Fast,
    ActionType_UsdTransfer,
};
@interface ChatFunctionView()<XMChatMoreViewDelegate,XMChatMoreViewDataSource,QMUITextViewDelegate,UIGestureRecognizerDelegate,ChatRecordToolDelegate>
/** 放置功能按钮 */
@property(strong, nonatomic) UIView *chatBarBackGroundView;
@property(nonatomic, strong) UIView *textViewBgView;

@property(nonatomic, strong) EmojyShowView *emojyShowView;
/**点击加号菜单栏数据源*/
@property(strong, nonatomic) NSMutableArray *moreMenuViewDatasources;

/** 安全区域的高度为了区分是否是iPhonex的机型 */
@property(nonatomic, assign) CGFloat starBarBottomHeight;
/** 菜单栏的高度(放置输入框和录音按钮的View的高度) */
@property(nonatomic,assign)  CGFloat chatBarBackGroundViewHeight;
/** textViewheight输入框的高度 */
@property(nonatomic,assign)  CGFloat textViewHeight;

/** 更多按钮 0*/
@property(strong, nonatomic) UIButton *moreBtn;
/** 拍照 1*/
/** 切换录音按钮 3*/
/** 切换表情按钮 4*/
/** 发送 5 */

/** 快捷消息 5 */
/** 重置button > */
/** 录音按钮*/
@property(strong, nonatomic) UIButton *recordButton;
@property(nonatomic, strong) ChatRecordTool *recordTool;
/**更多菜单*/
@property(strong, nonatomic) XMChatMoreView *moreMenuView;
/** 键盘的高度
 */
@property (nonatomic,assign) CGFloat kbHeight;
/** 自身的高度 不知道怎么命名 就这样子把
 */
@property (nonatomic,assign) CGFloat mineHeight;
/** 当前的高度
 */
@property (nonatomic,assign) CGFloat currentHeight;
/** 当前是否是表情输入
 */
@property (nonatomic,assign) BOOL isFaceInput;
/** 当前是否点击了录音按钮*/
@property (nonatomic,assign) BOOL isTranslateOn;
@property (nonatomic,assign) BOOL isRecordVoice;
/** 是不是显示更多的view
 */
@property(nonatomic, assign) BOOL  isShowMoreView;
/** textView的宽度
 */
@property(nonatomic, assign) CGFloat textViewWidth;
/** 键盘出现的时间
 */
@property(nonatomic, assign) CGFloat keyboardTime;
/** 当键盘高度改变的时候 是否需要动画
 */
@property(nonatomic, assign) BOOL needAnimation;
/** 放置在textView上面的view 添加一个手势 作用是当textView收回的时候 点击重新布局text
 */
@property(nonatomic, strong) UIView *textViewTapView;
@property(nonatomic, strong) UIView *chatFunctionTopBorder;
@property(nonatomic, assign) BOOL longPress;
/** 当前是否可以发送快捷消息 */
@property(nonatomic, assign) BOOL quickMessage;
/** textViewBgView距离右边的宽度 */
@property (nonatomic, strong) NSTimer *typingTimer;
@end


@implementation ChatFunctionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.isFaceInput = NO;
        self.backgroundColor = UIColorMakeHEXCOLOR(0xF6F6F6);
        //该手势仅仅是为了解决点击空白处 键盘弹出的问题
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        self.userInteractionEnabled=YES;
        [self addGestureRecognizer:tap];
        self.keyboardTime=0.25;
//        self.isShowLeftBgView=YES;
    }
    return self;
}
-(void)tapAction{
    
}
-(void)setChatFunctionViewType:(ChatFunctionViewType)chatFunctionViewType{
    _chatFunctionViewType=chatFunctionViewType;
    [self.moreMenuView reloadData];
}
-(void)configCirclecanSendMessageWith:(CircleUserInfo*)circleUserInfo dislikeMeInfo:(GetCircleDislikeMeInfo*)dislikeMeInfo draftMessage:(NSString*)draftMessage{
    if (circleUserInfo.deleted||dislikeMeInfo.dislikeMe) {
        [self configcanSendMessage:YES draftMessage:draftMessage];
        self.tipsLabel.text=@"";
    }else{
        [self configcanSendMessage:YES draftMessage:draftMessage];
    }
}
/**
 第三方客服可以在我行登录  第三方APP用户仅仅在网页端登录
 角色类型：
 1、好友
 2、客服
 3、第三方客服
 4、会员
 5、第三方用户
 6、普通用户

 权限：
 好友：图片、视频、文字(表情)、名片、位置、语音、视频、转账、红包、文件
 客服：图片、视频、文字(表情)、名片、转账、红包、文件
 第三方客服：图片、视频、文字(表情)
 VIP：图片、视频、文字(表情)、名片、位置、语音、视频、转账、红包、文件、保存（单人、群）消息、免添加可聊天、快捷消息
 非好友：图片、视频、文字(表情)


 好友：
 1、VS 好友-->走好友逻辑
 2、VS 客服--> 走好友逻辑
 3、VS 第三方客服-->走好友逻辑
 4、VS 会员--> 走会员逻辑
 5、VS 第三方用户-->走好友逻辑

 客服：
 1、VS 好友-->走好友逻辑
 2、VS 客服--> 走客服逻辑
 3、VS 第三方客服-->走客服逻辑
 4、VS 会员--> 走客服逻辑
 5、VS 第三方用户-->走客服逻辑

 第三方客服：
 1、VS 好友 --> 走好友逻辑（不过基本没这情况）
 2、VS 客服--> 走第三方客服逻辑
 3、VS 第三方客服--> 走第三方客服逻辑
 4、VS 会员--> 走第三方客服逻辑
 5、VS 第三方用户--> 走第三方客服逻辑

 会员：
 1、VS 好友 --> 走会员逻辑
 2、VS 客服 --> 走客服逻辑
 3、VS 第三方客服 --> 走第三方客服逻辑
 4、VS 会员 --> 走会员逻辑
 5、VS 第三方用户 --> 走会员逻辑（不过此情况基本不可能存在）
 6、VS 普通用户--> 走会员逻辑

 第三方用户：
 1、VS 好友 --> 走好友逻辑（不过此情况基本不可能存在）
 2、VS 客服 --> 走客服逻辑（不过此情况基本不可能存在）
 3、VS 第三方客服 --> 走第三方客服逻辑 (重点)
 4、VS 会员 --> 走会员逻辑（不过此情况基本不可能存在）
 5、VS 第三方用户 --> 走非好友逻辑（不过此情况基本不可能存在）


 普通用户：
 2、VS 客服 --> 走客服逻辑
 3、VS 第三方客服 --> 走第三方客服逻辑
 4、VS 会员 --> 走非好友逻辑
 5、VS 第三方用户 --> 不能聊天
 6、VS 普通用户--> 不能聊天

 */

-(void)configcanSendMessageWith:(UserMessageInfo*)userMessageInfo draftMessage:(NSString*)draftMessage{
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
    //自己已经被拉入黑名单 那么这个权限是最高的 显示对方已经把你拉黑
    if (userMessageInfo.beBlock) {
        isDiamond = TRUE;
        if (isDiamond) {
            self.fastButton.hidden = NO;
            self.fastButton.enabled = NO;
        }
        [self configcanSendMessage:NO draftMessage:draftMessage];
        self.tipsLabel.text=@"";
    }else{
        //如果是好友
        if (userMessageInfo.isFriend) {
            //for future use
           // self.chatFunctionViewType = ChatFunctionViewType_userChat;
            isDiamond = TRUE;
            if (isDiamond) {
                self.fastButton.hidden = NO;
                self.fastButton.enabled = YES;
            }
            [self configcanSendMessage:YES draftMessage:draftMessage];
        }else{///不是好友
            ///如果是第三方客服
            if (myIsThirdService||otherIsThirdService) {
                self.chatFunctionViewType = ChatFunctionViewType_thirdPartyService;
                isDiamond = TRUE;
                if (isDiamond) {///自己是会员 可以发送消息快捷消息
                    self.fastButton.hidden = NO;
                    self.fastButton.enabled = YES;
                }
                //是客服就可以发送消息
                [self configcanSendMessage:YES draftMessage:draftMessage];
            }else if (myIsService||otherIsService){///如果是我行客服
                self.chatFunctionViewType = ChatFunctionViewType_icanService;
                isDiamond = TRUE;
                if (isDiamond) {///自己是会员 可以发送消息快捷消息
                    self.fastButton.hidden = NO;
                    self.fastButton.enabled = YES;
                }
                //是客服就可以发送消息
                [self configcanSendMessage:YES draftMessage:draftMessage];
            }else{
                isDiamond = TRUE;
                if (isDiamond||otherDiamond) {///自己是会员 可以发送消息快捷消息
                    if (isDiamond) {///自己是会员 可以发送消息快捷消息
                        self.fastButton.hidden = NO;
                        self.fastButton.enabled = YES;
                    }
                    //for future use
                    //self.chatFunctionViewType = ChatFunctionViewType_userChat;
                    [self configcanSendMessage:YES draftMessage:draftMessage];
                }else{///陌生人不能聊天 啥都不能做
                    [self configcanSendMessage:NO draftMessage:draftMessage];
                }
            }
        }
    }
    
    [self setDefaultView];
}
-(void)configGroupWithGroupDetailInfo:(GroupListInfo*)groupDetailInfo draftMessage:(NSString*)draftMessage {
    self.tipsLabel.hidden=YES;
    self.recordButton.enabled = groupDetailInfo.isInGroup;
    self.faceButton.enabled = groupDetailInfo.isInGroup;
    self.voicedButton.enabled = groupDetailInfo.isInGroup;
    self.messageTextView.editable = groupDetailInfo.isInGroup;
    self.moreBtn.enabled=groupDetailInfo.isInGroup;
    self.messageTextView.userInteractionEnabled=groupDetailInfo.isInGroup;
    BOOL isDiamond = UserInfoManager.sharedManager.diamondValid;
    isDiamond = TRUE;
    if (!groupDetailInfo.isInGroup) {
        self.tipsLabel.text=@"";
        self.tipsLabel.hidden=NO;
        self.fastButton.hidden = YES;
        self.fastButton.enabled = NO;
    }else{
        self.recordButton.enabled = !groupDetailInfo.allShutUp;
        self.faceButton.enabled = !groupDetailInfo.allShutUp;
        self.voicedButton.enabled = !groupDetailInfo.allShutUp;
        self.messageTextView.editable = !groupDetailInfo.allShutUp;
        self.moreBtn.enabled=!groupDetailInfo.allShutUp;
        self.sendButton.enabled=!groupDetailInfo.allShutUp;
        self.messageTextView.userInteractionEnabled=!groupDetailInfo.allShutUp;
        if ([groupDetailInfo.role isEqualToString:@"0"]||[groupDetailInfo.role isEqualToString:@"1"]) {//群主和管理员
            self.recordButton.enabled = YES;
            self.faceButton.enabled = YES;
            self.voicedButton.enabled = YES;
            self.messageTextView.editable = YES;
            self.moreBtn.enabled=YES;
            self.messageTextView.userInteractionEnabled=YES;
            [self.messageTextView setText:draftMessage.length>0?draftMessage:@""];
            isDiamond = TRUE;
            if (isDiamond) {
                self.fastButton.hidden = NO;
                self.fastButton.enabled = YES;
            }
        }else{
            if (groupDetailInfo.allShutUp) {
                [self hiddenAllView];
                self.tipsLabel.hidden=NO;
                //禁言中
                self.tipsLabel.text=@"ChatViewController.tip.readOnly".icanlocalized;
                isDiamond = TRUE;
                if (isDiamond) {
                    self.fastButton.hidden = NO;
                    self.fastButton.enabled = NO;
                }
            }else{
                isDiamond = TRUE;
                if (isDiamond) {
                    self.fastButton.hidden = NO;
                    self.fastButton.enabled = YES;
                }
                [self.messageTextView setText:draftMessage.length>0?draftMessage:@""];
            }
        }
        [self checkSendButtonCanSend ];
    }
    if(groupDetailInfo.mutedByAdmin == YES){
        [self disableAllFunctions];
    }
    [self setDefaultView];
}
//不是好友时，相对应的按钮不能点击
-(void)configcanSendMessage:(BOOL)canSend draftMessage:(NSString*)draftMessage{
    self.tipsLabel.hidden=YES;
    self.recordButton.enabled = canSend;
    self.faceButton.enabled = canSend;
    self.voicedButton.enabled = canSend;
    self.messageTextView.editable = canSend;
    self.moreBtn.enabled=canSend;
    self.sendButton.enabled=canSend;
    self.messageTextView.userInteractionEnabled=canSend;
    if (canSend) {
        [self checkSendButtonCanSend ];
        [self.messageTextView setText:draftMessage.length>0?draftMessage:@""];
    }else{
        NSString * textViewStr=NSLocalizedString(@"UnFriendTips2", 你和他不是好友);
        self.tipsLabel.text=textViewStr;
        self.tipsLabel.hidden=NO;
    }
}

-(void)addNotification{
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)setUpView {
    [self addNotification];
    self.quickMessage = NO;
    self.textViewBgViewRightMargin = 75;
    self.textViewHeight = DefaultTextViewHeight;
    self.chatBarBackGroundViewHeight = DetaultChatBarBackGroundViewHeight;
    if (isIPhoneX) {
        self.starBarBottomHeight = 37;
    }else{
        self.starBarBottomHeight = 0;
    }
    self.currentHeight = 0.0;
    [self addSubview:self.chatBarBackGroundView];
    [self.chatBarBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(self.chatBarBackGroundViewHeight));
    }];
    [self.chatBarBackGroundView addSubview:self.leftBgView];
    [self.leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@235);
        make.left.equalTo(@0);
    }];
    [self.leftBgView addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.equalTo(@-12);
        make.width.height.equalTo(@28);
    }];
    [self.chatBarBackGroundView addSubview:self.voicedButton];
    [self.voicedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@28);
        make.right.equalTo(@-12.5);
        make.bottom.equalTo(@-12);
    }];
    [self.chatBarBackGroundView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@28);
        make.right.equalTo(@-12.5);
        make.bottom.equalTo(@-12);
    }];
    [self.chatBarBackGroundView addSubview:self.chatFunctionTopBorder];
    [self.chatFunctionTopBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@1);
        make.top.equalTo(self.chatBarBackGroundView.mas_top);
    }];
    [self.leftBgView addSubview:self.fastButton];
    [self.fastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreBtn.mas_right).offset(10);
        make.bottom.equalTo(@-12);
        make.width.height.equalTo(@28);
    }];
    [self.chatBarBackGroundView addSubview:self.textViewBgView];
    [self.textViewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //175+
        make.left.equalTo(self.fastButton.mas_right).offset(10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@(-self.textViewBgViewRightMargin));
    }];
    [self.textViewBgView addSubview:self.faceButton];
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-5);
        make.width.height.equalTo(@20);
    }];
    [self.textViewBgView addSubview:self.messageTextView];
    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@-5);
        make.top.equalTo(@5);
        make.right.equalTo(self.faceButton.mas_left).offset(-10);
    }];
    [self.messageTextView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.textViewBgView addSubview:self.textViewTapView];
    [self.textViewTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@-5);
        make.top.equalTo(@5);
        make.right.equalTo(self.faceButton.mas_left).offset(-8);
    }];
    [self.textViewBgView addSubview:self.recordButton];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self addSubview:self.moreMenuView];
    [self addSubview:self.emojyShowView];
}

-(void)ajustUIforAIChat{
    self.voicedButton.enabled = NO;
    self.fastButton.enabled = NO;
    self.moreBtn.enabled = NO;
    self.faceButton.enabled = NO;
}

-(void)disableAllFunctions{
    self.fastButton.enabled = NO;
    self.moreBtn.enabled = NO;
    self.faceButton.enabled = NO;
    self.sendButton.enabled = NO;
    self.voicedButton.enabled = NO;
    self.messageTextView.editable = NO;
}

-(void)enableAllFunctions{
    self.fastButton.enabled = YES;
    self.moreBtn.enabled = YES;
    self.faceButton.enabled = YES;
    self.sendButton.enabled = YES;
    self.voicedButton.enabled = YES;
    self.messageTextView.editable = YES;
}

- (void)checkSendButtonCanSend {
    if (self.messageTextView.text.length > 0) {
        self.sendButton.enabled = YES;
        [self.sendButton setBackgroundImage:UIImageMake(@"chat_funtion_send_enabled") forState:UIControlStateNormal];
    }
}

-(void)judgeIsPushSelectAtUser{
    //1:@前面是否是纯数字
    //2:@前后是否有字符
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.messageTextView.text.length>=2) {
            NSString*priorStr=[self.messageTextView.text substringWithRange:NSMakeRange(self.messageTextView.text.length-2, 1) ];
            if (priorStr) {
                NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
                NSString *filtered = [[priorStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                NSString *rawString = self.messageTextView.text;
                int rawStringLength = rawString.length;
                char set = [rawString characterAtIndex:rawStringLength-2];
                NSString* lastCharacter = [NSString stringWithFormat:@"%c",set];
                if (![priorStr isEqualToString:filtered]){
                    if( [lastCharacter isEqualToString:@""] || [lastCharacter isEqualToString:@" "] ){
                        [self pushSelectAtUser];
                    }
                }
            }
        }else{
            [self pushSelectAtUser];
        }
    });
}
//@功能
#pragma mark push->@群里的某个用户SelectAtUserTableViewController
-(void)pushSelectAtUser{
    if (!self.longPress) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(presentToAtUser)]) {
            [self.delegate presentToAtUser];
        }
    }
    
}
#pragma mark==  处理 @ 用户的 ==
- (void)dealWithAtUserMessageWithShowName:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress{
    self.longPress=longPress;
    NSString *message = self.messageTextView.text;
    NSArray * rangeArray=[self rangeOfSubString:@"@" inString:message];
    NSValue *rangeValue=[rangeArray lastObject];
    NSRange atRange =[rangeValue rangeValue];
    NSMutableString * messageMustr=[NSMutableString stringWithString:message];
    [messageMustr insertString:[NSString stringWithFormat:@"%@ ",showName] atIndex:atRange.location+1];
    self.messageTextView.text = messageMustr;
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:4];
    // 用户的user
    infoDic[@"userId"] = userId;
    // 用户的昵称
    infoDic[@"remark"] = showName;
    // 用户在textView的末尾位置
    infoDic[@"location"] = [NSNumber numberWithInteger: atRange.location+showName.length+1];
    // 用户所占的长度
    infoDic[@"length"] = [NSNumber numberWithInteger:showName.length + 2];
    [self.atMemberArr addObject:infoDic];
    [self.messageTextView becomeFirstResponder];
}

- (void)dealWithAtUserMessageWithShowNameAll:(NSString *)showName userId:(NSString *)userId longPress:(BOOL)longPress usersDatas: (NSArray<GroupMemberInfo *>*) groupMemberInfo {
    self.longPress=longPress;
    NSString *message = self.messageTextView.text;
    NSArray * rangeArray=[self rangeOfSubString:@"@" inString:message];
    NSValue *rangeValue=[rangeArray lastObject];
    NSRange atRange =[rangeValue rangeValue];
    NSMutableString * messageMustr=[NSMutableString stringWithString:message];
    [messageMustr insertString:[NSString stringWithFormat:@"%@ ",showName] atIndex:atRange.location+1];
    self.messageTextView.text = messageMustr;
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:4];
    // 用户的user
    infoDic[@"userId"] = userId;
    // 用户的昵称
    infoDic[@"remark"] = showName;
    // 用户在textView的末尾位置
    infoDic[@"location"] = [NSNumber numberWithInteger: atRange.location+showName.length+1];
    // 用户所占的长度
    infoDic[@"length"] = [NSNumber numberWithInteger:showName.length + 2];
    
    for (GroupMemberInfo *userInfo in groupMemberInfo) {
        NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
        
        infoDictionary[@"userId"] = userInfo.userId;
        // 用户的昵称
        infoDictionary[@"remark"] = userInfo.groupRemark?:userInfo.nickname;
        
        NSString *userShowName = userInfo.groupRemark?:userInfo.nickname;
        // 用户在textView的末尾位置
        infoDictionary[@"location"] = [NSNumber numberWithInteger: atRange.location+userShowName.length+1];
        // 用户所占的长度
        infoDictionary[@"length"] = [NSNumber numberWithInteger:userShowName.length + 2];
        [self.atMemberArr addObject:infoDictionary];
    }
    [self.messageTextView becomeFirstResponder];
}

- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}

#pragma mark - Lazy
-(UIView *)chatBarBackGroundView{
    if (!_chatBarBackGroundView) {
        _chatBarBackGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.chatBarBackGroundViewHeight)];
        _chatBarBackGroundView.backgroundColor = UIColorMakeHEXCOLOR(0xF6F6F6);
    }
    return _chatBarBackGroundView;
}
-(UIView *)textViewBgView{
    if (!_textViewBgView) {
        _textViewBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.chatBarBackGroundViewHeight)];
        _textViewBgView.backgroundColor = UIColor.whiteColor;
        [_textViewBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    return _textViewBgView;
}
- (UIView *)chatFunctionTopBorder {
    if (!_chatFunctionTopBorder) {
        _chatFunctionTopBorder = [[UIView alloc]init];
        _chatFunctionTopBorder.backgroundColor = UIColorMakeHEXCOLOR(0xE6E6E6);
    }
    return _chatFunctionTopBorder;
}
-(UIView *)leftBgView{
    if (!_leftBgView) {
        _leftBgView=[[UIView alloc]init];
        _leftBgView.backgroundColor= UIColorMakeHEXCOLOR(0xF6F6F6);
    }
    return _leftBgView;
}
-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:8 target:self action:@selector(buttonAction:)];
        _moreBtn.tag=ActionType_More;
        [_moreBtn setBackgroundImage:UIImageMake(@"chat_funtion_more_select") forState:UIControlStateNormal];
        
        
        
    }return _moreBtn;
}


-(UIButton *)voicedButton{
    if (!_voicedButton) {
        _voicedButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 target:self action:@selector(buttonAction:)];
        [_voicedButton setBackgroundImage:UIImageMake(@"chat_funtion_voice_select") forState:UIControlStateNormal];
        _voicedButton.tag=ActionType_Voice;
    }
    return _voicedButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(buttonAction:)];
        [_faceButton setBackgroundImage:UIImageMake(@"chat_funtion_expression_select") forState:UIControlStateNormal];
        _faceButton.tag = ActionType_Face;
    }return _faceButton;
}

-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(buttonAction:)];
        _sendButton.tag=ActionType_Send;
        [_sendButton setBackgroundImage:UIImageMake(@"chat_funtion_send_disabled") forState:UIControlStateNormal];
        _sendButton.enabled=NO;
        
    }
    return _sendButton;
}
-(UIButton *)fastButton{
    if (!_fastButton) {
        _fastButton=[UIButton functionButtonWithTitle:nil image:nil backgroundColor:nil titleFont:9 target:self action:@selector(buttonAction:)];
        _fastButton.tag=ActionType_Fast;
        _fastButton.hidden=NO;
        [_fastButton setBackgroundImage:UIImageMake(@"chat_funtion_fast") forState:UIControlStateNormal];

    }
    return _fastButton;
}

-(NSMutableArray *)atMemberArr{
    if (!_atMemberArr) {
        _atMemberArr=[NSMutableArray array];
    }
    return _atMemberArr;
}
-(UIView *)textViewTapView{
    if (!_textViewTapView) {
        _textViewTapView=[[UIView alloc]init];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textViewTapViewAction)];
        _textViewTapView.hidden=NO;
        [_textViewTapView addGestureRecognizer:tap];
    }
    return _textViewTapView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel leftLabelWithTitle:@"" font:16 color:UIColor153Color];
        _tipsLabel.hidden=YES;
    }
    return _tipsLabel;
}
-(QMUITextView *)messageTextView{
    if (!_messageTextView) {
        _messageTextView=[[QMUITextView alloc]initWithFrame:CGRectMake(55, 5, ScreenWidth-200, 40)];
        _messageTextView.delegate=self;
        _messageTextView.textColor=UIColorThemeMainTitleColor;
        _messageTextView.font=[UIFont systemFontOfSize:16];
        _messageTextView.maximumHeight=MaxTextViewHeight;
        _messageTextView.backgroundColor=UIColor.clearColor;
        _messageTextView.returnKeyType= UIReturnKeyDefault;
        _messageTextView.textContainerInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _messageTextView.placeholderColor=UIColorThemeMainSubTitleColor;
        
        
        
    }return _messageTextView;
}
- (XMChatMoreView *)moreMenuView {
    if (!_moreMenuView) {
        _moreMenuView = [[XMChatMoreView alloc] initWithFrame:(CGRectMake(0, ScreenHeight, ScreenWidth, KMoreViewHeight))];
        _moreMenuView.delegate = self;
        _moreMenuView.dataSource = self;
        _moreMenuView.backgroundColor = UIColorViewBgColor;
    }
    return _moreMenuView;
}
-(EmojyShowView *)emojyShowView{
    if (!_emojyShowView) {
        _emojyShowView=[[EmojyShowView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight+self.starBarBottomHeight)];
        @weakify(self);
        _emojyShowView.selectEmojyBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            self.messageTextView.text = [self.messageTextView.text stringByAppendingString:text];
        };
        _emojyShowView.deleteBlock = ^{
            @strongify(self);
            if (self.messageTextView.text.length>0) {
                NSRange lastRange = [self.messageTextView.text rangeOfComposedCharacterSequenceAtIndex:self.messageTextView.text.length-1];
                self.messageTextView.text = [self.messageTextView.text stringByReplacingCharactersInRange:lastRange withString:@""];
            }
           
        };
        _emojyShowView.sendBlock = ^{
            @strongify(self);
            NSString *text = self.messageTextView.text;
            if (!text || text.length == 0) {
                return;
            }
            if (self.delegate&&[self.delegate respondsToSelector:@selector(clickSendMessageWithText:)]) {
                [self.delegate clickSendMessageWithText:text];
            }
        };
    }
    return _emojyShowView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton functionButtonWithTitle:NSLocalizedString(@"HoldToTalk", 按住 说话) image:nil backgroundColor:UIColorBg243Color titleFont:16 target:self action:nil];
        _recordButton.backgroundColor = UIColor.clearColor;
        _recordButton.frame = CGRectMake(45, 5, ScreenWidth-135, 40);
        [_recordButton setTitleColor:UIColorThemeMainTitleColor forState:UIControlStateNormal];
        // Press the record button
        [_recordButton addTarget:self action:@selector(audioLpButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        // Take your finger off the record button, but don't let it go
        [_recordButton addTarget:self action:@selector(audioLpButtonMoveOut:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchDragOutside];
        // Take your finger off the record button, release
        [_recordButton addTarget:self action:@selector(audioLpButtonMoveOutTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        // Return your finger to the record button, but don't let go
        [_recordButton addTarget:self action:@selector(audioLpButtonMoveInside:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragEnter];
        // Finger back to the record button, release
        [_recordButton addTarget:self action:@selector(audioLpButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        _recordButton.hidden = YES;
    }
    return _recordButton;
}

//录音工具
- (ChatRecordTool *)recordTool{
    if (!_recordTool) {
        _recordTool = [ChatRecordTool chatRecordTool];
        _recordTool.delegate=self;
    }
    return _recordTool;
}
#pragma mark - Event
-(void)setButtonNoSelect{
    self.moreBtn.selected=NO;
    self.faceButton.selected=NO;
    self.voicedButton.selected=NO;
    [self.moreBtn setBackgroundImage:UIImageMake(@"chat_funtion_more_select") forState:UIControlStateNormal];
    [self.voicedButton setBackgroundImage:UIImageMake(@"chat_funtion_voice_select") forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:UIImageMake(@"chat_funtion_expression_select") forState:UIControlStateNormal];
}
-(void)buttonAction:(UIButton*)button{
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    button.selected=!button.selected;
    self.isRecordVoice=NO;
    switch (button.tag) {
            /**点击了更多按钮 默认显示更多View*/
        case ActionType_More:{
            [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
            [self voiceBtnRestore];
            self.faceButton.selected = NO;
            [self.messageTextView resignFirstResponder];
            [self hideFaceViewWithduration];
            self.chatBarBackGroundViewHeight=self.textViewHeight+10;
            if (!self.isShowMoreView) {
                [self showMoreMenuViewWithduration:0.5];
            }
            
        }
            break;
            
        case ActionType_Photograp:{//拍照
            [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(moreItemClickWithXMChatMoreItemType:)]) {
                [self.delegate moreItemClickWithXMChatMoreItemType:XMChatMoreItemCamera];
            }
            
        }
            break;
            
        case ActionType_UsdTransfer:{
            //implement to be
        }
            break;
            
        case ActionType_Album:{//相册
            [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(moreItemClickWithXMChatMoreItemType:)]) {
                [self.delegate moreItemClickWithXMChatMoreItemType:XMChatMoreItemPicture];
            }
        }
            break;
        case ActionType_Voice:{//录音
            [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
            [self hideFaceViewWithduration];
            [self hideMoreMenuViewWithduration];
            self.recordButton.hidden = !button.selected;
            self.messageTextView.hidden = button.selected;
            if (button.selected) {
                [self.messageTextView resignFirstResponder];
                self.isRecordVoice=YES;
                self.faceButton.selected=NO;
                self.mineHeight=DetaultChatBarBackGroundViewHeight+self.starBarBottomHeight;
                [self updateChatFunctionViewConstaint];
            } else {
                self.isRecordVoice=NO;
                self.chatBarBackGroundViewHeight=DetaultChatBarBackGroundViewHeight;
                self.mineHeight=self.chatBarBackGroundViewHeight+self.starBarBottomHeight;
                [self updateChatFunctionViewConstaint];
                
            }
        }
            break;
        case ActionType_Face:{
            [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
            [self voiceBtnRestore];
            [self hideMoreMenuViewWithduration];
            self.chatBarBackGroundViewHeight=self.textViewHeight+10;
            if (button.selected) {
                [_faceButton setBackgroundImage:UIImageMake(@"chat_funtion_keyboard_select") forState:UIControlStateNormal];
                [self.messageTextView resignFirstResponder];
                [self showFaceViewWithduration:self.keyboardTime?:0.4];
            } else {
                [_faceButton setBackgroundImage:UIImageMake(@"chat_funtion_expression_select") forState:UIControlStateNormal];
                [self.messageTextView becomeFirstResponder];
                [self hideFaceViewWithduration];
            }
        }
            break;
        case ActionType_Send:{//发送
            if (self.delegate&&[self.delegate respondsToSelector:@selector(clickSendMessageWithText:)]) {
                [self.delegate clickSendMessageWithText:self.messageTextView.text];
            }
            
        }
            break;
       
        case ActionType_Fast:{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(clickFastBtn:)]) {
                [self.delegate clickFastBtn:self];
            }
        }
            break;
    }
    
    
}
-(NSArray*)setMoreMenuViewDatasources{
    //  照片 拍摄 视频 红包 转账 名片
    NSMutableArray*array=[NSMutableArray array];
    //图片
    ChatMoreTagItem*pictureItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.picture".icanlocalized imageStr:@"chat_moreView_picture" tag:XMChatMoreItemPicture];
    //拍照
    ChatMoreTagItem*cameraItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.camera".icanlocalized imageStr:@"chat_moreView_photo" tag:XMChatMoreItemCamera];
    //dicegame
    ChatMoreTagItem *diceItem = [ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.dice".icanlocalized imageStr:@"dice_img" tag:XMChatMoreItemDiceGame];
    //转账
    ChatMoreTagItem*transferItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.transfer.cnt".icanlocalized imageStr:@"CNT Transfer" tag:XMChatMoreItemTransfer];
    //名片
    ChatMoreTagItem*vcardItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.contactCard".icanlocalized imageStr:@"chat_moreView_card" tag:XMChatMoreItemUserVcard];
    
    ChatMoreTagItem*transferUSDItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.transfer.usdt".icanlocalized imageStr:@"USDT Transfer" tag:XMChatMoreItemUSDTransfer];
    //位置
    ChatMoreTagItem*locationItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.location".icanlocalized imageStr:@"location" tag:XMChatMoreItemLocation];
    //红包
    ChatMoreTagItem*redRevelopeItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.redPacket".icanlocalized imageStr:@"red pack" tag:XMChatMoreItemSendRedEnvelope];
    //文件
    ChatMoreTagItem*fileItem=[ChatMoreTagItem chatMoreItemWithTitle:@"chatView.function.file".icanlocalized imageStr:@"chat_moreView_file" tag:XMChatMoreItemPaoFile];
    switch (self.chatFunctionViewType) {
        case ChatFunctionViewType_chatOther:{
            [array addObject:pictureItem];
            [array addObject:cameraItem];
            [array addObject:vcardItem];
        }
            break;
        case ChatFunctionViewType_group:{
            [array addObject:pictureItem];
            [array addObject:cameraItem];
            [array addObject:vcardItem];
            [array addObject:locationItem];
            [array addObject:redRevelopeItem];
            [array addObject:fileItem];
            [array addObject:diceItem];
        }
            break;
        case ChatFunctionViewType_secret:{
            [array addObject:pictureItem];
            [array addObject:cameraItem];
            [array addObject:vcardItem];
            [array addObject:locationItem];
            [array addObject:fileItem];
            [array addObject:diceItem];
        }
            break;
        case ChatFunctionViewType_userChat:{
            if ([UserInfoManager sharedManager].openTransfer) {
                if(self.chatFunctionViewType != ChatFunctionViewType_chatOther ){
                    [array removeAllObjects];
                    [array addObject:transferUSDItem];
                    [array addObject:transferItem];
                    [array addObject:redRevelopeItem];
                    [array addObject:vcardItem];
                    [array addObject:pictureItem];
                    [array addObject:cameraItem];
                    [array addObject:locationItem];
                    [array addObject:fileItem];
                    [array addObject:diceItem];
                }
            }else{
                [array addObject:pictureItem];
                [array addObject:cameraItem];
                [array addObject:vcardItem];
                [array addObject:locationItem];
                [array addObject:redRevelopeItem];
                [array addObject:fileItem];
                [array addObject:diceItem];
            }
        }
            break;
        case ChatFunctionViewType_icanService:{
//            客服：图片、视频、文字(表情)、名片、转账、红包、文件
            [array removeAllObjects];
            [array addObject:pictureItem];
            [array addObject:vcardItem];
            [array addObject:transferItem];
            [array addObject:redRevelopeItem];
            [array addObject:fileItem];
        }
            break;
        case ChatFunctionViewType_circle:{
            [array addObject:pictureItem];
            [array addObject:cameraItem];
            [array addObject:vcardItem];
            [array addObject:locationItem];
            if ([UserInfoManager sharedManager].cloudLetterVoice) {
            }
            if ([UserInfoManager sharedManager].cloudLetterVideo) {
            }
            [array addObject:fileItem];
            [array addObject:diceItem];
        }
            break;
        case ChatFunctionViewType_c2c:{
            [array removeAllObjects];
            [array addObject:pictureItem];
            [array addObject:cameraItem];
        }
            break;
        case ChatFunctionViewType_thirdPartyService:{
            [array removeAllObjects];
            [array addObject:pictureItem];
        }
            break;
    }
    return array;
}
- (NSArray *)itemsOfMoreView:(XMChatMoreView *)moreView {
    return [self setMoreMenuViewDatasources];
}
- (void)moreView:(XMChatMoreView *)moreView selectIndex:(XMChatMoreItemType)itemType{
    [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(moreItemClickWithXMChatMoreItemType:)]) {
        [self.delegate moreItemClickWithXMChatMoreItemType:itemType];
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return [self messageTextView:textView shouldChangeTextInRange:range replacementText:text];
}
- (BOOL)messageTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(clickSendMessageWithText:)]) {
//            [self.delegate clickSendMessageWithText:textView.text];
//        }
        return YES;
    }
    if ([text isEqualToString:@"@"]) {
        [self judgeIsPushSelectAtUser];
        return YES;
    }else if (text.length == 0){
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        if ([deleteText isEqualToString:@"]"]) {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            NSString *subText;
            while (YES) {
                if (location == 0) {
                    return YES;
                }
                location -- ;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            return NO;
        }else{
            for (NSDictionary *infoDic in self.atMemberArr) {
                if ([infoDic[@"location"] integerValue] == range.location) {
                    NSInteger indexLocation = [infoDic[@"location"] integerValue];
                    NSInteger length = [infoDic[@"length"] integerValue];
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(indexLocation - (length -1) , length - 1 ) withString:@""];
                    [textView setSelectedRange:NSMakeRange(indexLocation, 0)];
                    [self.atMemberArr removeObject:infoDic];
                    return YES;
                }
            }
        }
    }
    return YES;
}
#pragma mark - 语音按钮点击
- (void)audioLpButtonTouchDown:(UIButton *)audioLpButton{
    //Please set to allow APP to access your microphone
    [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
        if (self.recordTool) {
            self.recordTool=nil;
        }
        [self.recordTool beginRecord];
    } notDetermined:^{
        
    } failure:^{
        
    }];
    
}
// - 手指离开录音按钮 , 但不松开
- (void)audioLpButtonMoveOut:(UIButton *)audioLpButton{
    [self.recordTool moveOut];
}
// - 手指离开录音按钮 , 松开
- (void)audioLpButtonMoveOutTouchUp:(UIButton *)audioLpButton{
    [self.recordTool cancelRecord];
}
// - 手指回到录音按钮,但不松开
- (void)audioLpButtonMoveInside:(UIButton *)audioLpButton{
    [self.recordTool continueRecord];
}
// - 手指回到录音按钮 , 松开
- (void)audioLpButtonTouchUpInside:(UIButton *)audioLpButton{
    if (self.recordTool.beginRecoder) {
        [self.recordTool stopRecord];
    }
    
}
-(void)endConvertWithData:(NSData *)voiceData seconds:(NSTimeInterval)time localPath:(NSString *)localPath{
    ChatAlbumModel *audio = [[ChatAlbumModel alloc]init];
    audio.audioData = voiceData;
    audio.duration  = [@(time)stringValue];
    audio.name=localPath.lastPathComponent;
    //重置其他APP的语音播放
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendVoiceWithChatAlbumModel:)]) {
        [self.delegate sendVoiceWithChatAlbumModel:audio];
    }
    
}
- (void)voiceBtnRestore {
    self.voicedButton.selected=NO;
    self.recordButton.hidden = !self.voicedButton.selected;
    self.messageTextView.hidden = self.voicedButton.selected;
}

- (void)showFaceViewWithduration:(CGFloat)duration {
    self.isFaceInput = YES;
    [self.emojyShowView changeButtonUI:self.messageTextView.text.length > 0];
    [UIView animateWithDuration:self.keyboardTime animations:^{
        self.emojyShowView.frame = CGRectMake(0, self.chatBarBackGroundViewHeight, ScreenWidth, KFaceViewHeight + self.starBarBottomHeight);
        self.mineHeight = self.chatBarBackGroundViewHeight+KFaceViewHeight+self.starBarBottomHeight;
        [self updateChatFunctionViewConstaint];
    }];
    [self.faceButton setHidden: NO];
}

- (void)hideFaceViewWithduration {
    self.isFaceInput=NO;
    [self.emojyShowView changeButtonUI:self.messageTextView.text.length>0];
    [UIView animateWithDuration:self.keyboardTime animations:^{
        //self.faceView.frame =CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight);
        self.emojyShowView.frame=CGRectMake(0, ScreenHeight, ScreenWidth, KFaceViewHeight);
    }];
}


- (void)hideMoreMenuViewWithduration {
    self.isShowMoreView=NO;
    [UIView animateWithDuration:self.keyboardTime animations:^{
        self.moreMenuView.frame =CGRectMake(0, ScreenHeight, ScreenWidth, KMoreViewHeight);
    }];
}
- (void)showMoreMenuViewWithduration:(CGFloat)duration{
    self.isShowMoreView=YES;
    [UIView animateWithDuration:self.keyboardTime animations:^{
        self.moreMenuView.frame = CGRectMake(0, self.chatBarBackGroundViewHeight, ScreenWidth, KMoreViewHeight + self.starBarBottomHeight);
        self.mineHeight=KMoreViewHeight + self.starBarBottomHeight+self.chatBarBackGroundViewHeight;
        [self updateChatFunctionViewConstaint];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - 所有的freme的改变都在这里
#pragma mark - 点击了重置按钮

-(void)setDefaultView{
    [self.leftBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@235);
    }];
   
    [self.textViewBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fastButton.mas_right).offset(10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@(-self.textViewBgViewRightMargin));
    }];
}

#pragma mark keyboard notification
- (void)keyboardWillHide:(NSNotification *)noti {
    self.chatBarBackGroundViewHeight = DetaultChatBarBackGroundViewHeight;
    self.textViewHeight = DefaultTextViewHeight;
    self. kbHeight = 0;
    self.mineHeight = self.chatBarBackGroundViewHeight+self.starBarBottomHeight;
    self.textViewTapView.hidden = NO;
    NSDictionary *userInfo = [noti userInfo];
    // Take out the time of the keyboard animation
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardTime = duration;
    self.mineHeight = self.chatBarBackGroundViewHeight + self. starBarBottomHeight;
    [self.chatBarBackGroundView setNeedsUpdateConstraints];
    [self.chatBarBackGroundView updateConstraintsIfNeeded];
    self.isShowLeftBgView = YES;
    [self setDefaultView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.chatBarBackGroundView layoutIfNeeded];
    }];
    self.textViewTapView.hidden = NO;
    [self updateChatFunctionViewConstaint];
    self.moreBtn.selected = NO;
    [self.faceButton setHidden: YES];
    [self.voicedButton setHidden: NO];
    if(self.messageTextView.text.length > 0) {
        [self.sendButton setHidden: NO];
        [self.fastButton setHidden: YES];
    }else {
        [self.sendButton setHidden: YES];
        [self.fastButton setHidden: NO];
    }
    [self.textViewBgView setHidden: NO];
    [self.textViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fastButton.mas_right).offset(10);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(@(-self.textViewBgViewRightMargin));
    }];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    // Get the height of the keyboard
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self. kbHeight = [value CGRectValue].size.height;
    // Take out the time of the keyboard animation
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardTime = duration;
    [self hideFaceViewWithduration];
    [self hideMoreMenuViewWithduration];
    self.isFaceInput = NO;
    self.isRecordVoice = NO;
    self.faceButton.selected = NO;
    self.needAnimation = NO;
    self.leftBgView.hidden = NO;
    self.isShowLeftBgView = YES;
    [self changeTextViewFrame];
    [self.faceButton setHidden: NO];
    [self.voicedButton setHidden: NO];
    if(self.messageTextView.text.length > 0) {
        [self.sendButton setHidden: NO];
        [self.fastButton setHidden: YES];
        [self.voicedButton setHidden:YES];
        [self.textViewBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moreBtn.mas_right).offset(10);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@(-self.textViewBgViewRightMargin));
        }];
    }else {
        [self.sendButton setHidden: YES];
        [self.fastButton setHidden: NO];
    }
}

- (void)keyboardDidShow:(NSNotification *)noti {
    // Get the height of the keyboard
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self. kbHeight = [value CGRectValue].size.height;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardTime = duration;
    self.mineHeight = self.kbHeight+self.chatBarBackGroundViewHeight;
    self.needAnimation = YES;
    [self changeTextViewFrame];
}

- (void)textViewDidChange:(UITextView *)textView {
    if(self.isTranslateOn == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"translationStarted" object:nil];
        [self.typingTimer invalidate]; // Invalidate the previous timer
        self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(userStoppedTyping:) userInfo:textView.text repeats:NO];
    }else{
        if (self.textViewDidChangeBlock) {
            self.textViewDidChangeBlock(textView.text);
        }
    }
    self.needAnimation = NO;
    [self checkSendButtonCanSend];
    [self changeTextViewFrame];
    [self.emojyShowView changeButtonUI:self.messageTextView.text.length > 0];
    if(self.messageTextView.text.length == 0) {
        [self.sendButton setHidden: YES];
        [self.fastButton setHidden: NO];
        [self.voicedButton setHidden:NO];
        [self.textViewBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fastButton.mas_right).offset(10);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@(-self.textViewBgViewRightMargin));
        }];
    }else {
        [self.voicedButton setHidden:YES];
        [self.textViewBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moreBtn.mas_right).offset(10);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@(-self.textViewBgViewRightMargin));
        }];
        [self.sendButton setHidden: NO];
        [self.fastButton setHidden: YES];
    }
}

- (void)userStoppedTyping:(NSTimer *)timer {
    if (self.textViewDidChangeBlock) {
        self.textViewDidChangeBlock(timer.userInfo);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
//改变textview的Frame
-(void)changeTextViewFrame{
    //这里传递的宽度是ScreenWidth-140的原因是因为当textView编辑的时候 textView的宽度一定是ScreenWidth-140
    CGFloat resultHeight;
    resultHeight = self.messageTextView.contentSize.height;
    CGFloat lineH=self.messageTextView.font.lineHeight;
    //23
    CGFloat line=resultHeight/lineH;
    self.textViewHeight=resultHeight;
    if (self.textViewHeight<=DefaultTextViewHeight) {
        self.textViewHeight=DefaultTextViewHeight;
    }else if (self.textViewHeight>=MaxTextViewHeight){
        self.textViewHeight=MaxTextViewHeight;
    }
    if (line<2) {
        self.chatBarBackGroundViewHeight=self.textViewHeight+15;
    }else{
        self.chatBarBackGroundViewHeight=self.textViewHeight+30;
    }
    if (self.isFaceInput) {
        self.mineHeight=KFaceViewHeight+self.chatBarBackGroundViewHeight+self.starBarBottomHeight;
        
    }else{
        if (self.kbHeight>10) {
            self.mineHeight=self.kbHeight+self.chatBarBackGroundViewHeight;
        }else{
            self.mineHeight=self.starBarBottomHeight+self.chatBarBackGroundViewHeight;
        }
        
    }
    self.isShowLeftBgView=NO;
    [self updateChatFunctionViewConstaint];
}
-(void)hiddenAllView{
    
    [self.moreBtn setBackgroundImage:UIImageMake(@"chat_funtion_more_select") forState:UIControlStateNormal];
    [self.voicedButton setBackgroundImage:UIImageMake(@"chat_funtion_voice_select") forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:UIImageMake(@"chat_funtion_expression_select") forState:UIControlStateNormal];
    [self hideFaceViewWithduration];
    [self hideMoreMenuViewWithduration];
    self.chatBarBackGroundViewHeight=DetaultChatBarBackGroundViewHeight;
    self.mineHeight=self.chatBarBackGroundViewHeight+self.starBarBottomHeight;
    [self.chatBarBackGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(60));
    }];
    self.isShowLeftBgView=YES;
    [self setDefaultView];
    if (self.isFaceInput||self.isShowMoreView||[self.messageTextView isFirstResponder]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.chatBarBackGroundView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.messageTextView scrollRangeToVisible:NSMakeRange(self.messageTextView.text.length, 1)];
        }];
    }else{
        [self.messageTextView scrollRangeToVisible:NSMakeRange(self.messageTextView.text.length, 1)];
    }
    [self updateChatFunctionViewConstaint];
    
}

-(void)hideAllBtn{
    self.chatFunctionType = @"Seller";
}
-(void)disableSendBtn{
    self.sendButton.enabled = NO;
}
-(void)enableSendBtn{
    self.sendButton.enabled = YES;
}

- (void)updateTranslateOnstatus:(BOOL)statusTranslate {
    self.isTranslateOn = statusTranslate;
}

-(void)updateChatFunctionViewConstaint{
    if (self.isFaceInput) {
        self.emojyShowView.frame=CGRectMake(0, self.chatBarBackGroundViewHeight, ScreenWidth, KFaceViewHeight + self.starBarBottomHeight);
    }
    self.frame=CGRectMake(0, ScreenHeight-self.mineHeight, ScreenWidth, self.mineHeight);
    [self.chatBarBackGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(self.chatBarBackGroundViewHeight));
    }];
    if (self.currentHeight ==self.mineHeight) {
        return;
    }
    self.currentHeight=self.mineHeight;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(frameHasChangeWithHeight:keyboardTime:)]) {
        if([UserInfoManager.sharedManager.chatID isEqual:@"100"]){
            [self.delegate frameHasChangeWithHeight:self.mineHeight-40 keyboardTime:self.keyboardTime];
        }else {
            [self.delegate frameHasChangeWithHeight:self.mineHeight keyboardTime:self.keyboardTime];
        }
    }
}
-(void)textViewTapViewAction{
    self.textViewTapView.hidden=YES;
    [self setButtonNoSelect];
    [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
    if (self.kbHeight>10) {
        [self changeTextViewFrame];
    }else{
        [self.messageTextView becomeFirstResponder];
    }
    
}

-(void)moreViewAction{
    [[VoicePlayerTool sharedManager]playChatFunctionViewVoice];
    [self voiceBtnRestore];
    self.faceButton.selected = NO;
    [self.messageTextView resignFirstResponder];
    [self hideFaceViewWithduration];
    self.chatBarBackGroundViewHeight = self.textViewHeight + 10;
    if (!self.isShowMoreView) {
        [self showMoreMenuViewWithduration:0.5];
    }
}
@end

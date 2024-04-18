
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 14/7/2021
- File name:  TimeLineDetailCommentTableViewCell.m
- Description:
- Function List:
*/
        

#import "TimeLineDetailCommentTableViewCell.h"
#import "XMFaceManager.h"
#import "MessageMenuView.h"
#import "HJCActionSheet.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MenuItem.h"
#import "WCDBManager+TimelinesCommentInfo.h"
#import "TimelinesCommentInfo.h"
@interface TimeLineDetailCommentTableViewCell ()<MessageMenuViewDelegate,HJCActionSheetDelegate>
@property(nonatomic, strong) MessageMenuView *menuView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *translateLabel;
@property (weak, nonatomic) IBOutlet UIView *oneLineView;
@property (weak, nonatomic) IBOutlet UIView *twoLineView;
@property (weak, nonatomic) IBOutlet UIView *fiveLineView;
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property (weak, nonatomic) IBOutlet UIView *translateStatusBgView;
@property (weak, nonatomic) IBOutlet UILabel *translateStatusLabel;
@property (weak, nonatomic) IBOutlet UIStackView *bgTextContentView;
@property(nonatomic, assign) BOOL isLongContentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@end

@implementation TimeLineDetailCommentTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden=YES;
    [self.iconImgView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replyAction)];
//    [self.contentLabel addGestureRecognizer:tap];
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
//    [self.contentLabel addGestureRecognizer:longPress];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"HiddenTimelineMenuViewNotification" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        self.contentLabel.backgroundColor=[UIColor whiteColor];
        self.bgContentView.backgroundColor=[UIColor whiteColor];
        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
        
    }];
//    UILongPressGestureRecognizer*tlongPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tlongPressAction)];
//    [self.translateLabel addGestureRecognizer:tlongPress];
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"HiddenTimelineMenuViewNotification" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
//        self.translateLabel.backgroundColor=[UIColor whiteColor];
//        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
//
//    }];
    
    [self.contentView addGestureRecognizer:longPress];
    self.contentView.userInteractionEnabled=YES;
    [self.contentView addGestureRecognizer:tap];
    
}
-(void)tlongPressAction{
    self.isLongContentLabel=NO;
    self.translateLabel.backgroundColor=UIColor238Color;
    [self.menuView showTimelineCommentMenuView:self.contentView convertRectView:self.contentView isMine:NO showTranslate:NO isShowOrigin:NO];
}
-(void)longPressAction{
    self.isLongContentLabel=YES;
//    self.contentLabel.backgroundColor=UIColor238Color;
    self.bgContentView.backgroundColor=UIColor238Color;
    BOOL isMine=NO;
    if ([self.detailInfo.belongsId isEqualToString:UserInfoManager.sharedManager.userId]) {
        isMine=YES;
    }
    if ([self.comment.belongsId isEqualToString:UserInfoManager.sharedManager.userId]) {
        isMine=YES;
    }
    BOOL isShowOrigin=NO;
    if (self.comment.translateStatus==1) {
        isShowOrigin=YES;
    }
    [self.menuView showTimelineCommentMenuView:self.contentView convertRectView:self.bgContentView isMine:isMine showTranslate:self.comment.translateStatus!=1 isShowOrigin:isShowOrigin];
}
-(void)replyAction{
    if ([UserInfoManager.sharedManager.userId isEqualToString:self.comment.belongsId]) {
        self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:@[@"Delete".icanlocalized]];
        [self.hjcActionSheet show];
    }else{
        if (self.replyBlock) {
            self.replyBlock(self.comment.belongsNickName, self.comment.ID);
        }
    }
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
#pragma mark - Setter
-(void)setComment:(TimelinesCommentInfo *)comment{
    if (comment) {
        _comment = comment;
        [self.iconImgView setDZIconImageViewWithUrl:comment.belongsHeadImgUrl gender:comment.belongsGender];
        self.nameLabel.text = comment.belongsNickName;
        self.timeLabel.text = [GetTime timelinesTime:comment.publishTime];
        self.translateLabel.text=comment.translateMsg;
//        "TimeLineDetailCommentTableViewCellTranslateSuccess"="翻译成功";
//        "TimeLineDetailCommentTableViewCellFail"="翻译失败";
        switch (comment.translateStatus) {
            case 0:{
                self.twoLineView.hidden=self.translateStatusBgView.hidden=self.translateLabel.hidden=YES;
            }
                break;
            case 1:{//翻译成功
                self.twoLineView.hidden=self.translateStatusBgView.hidden=self.translateLabel.hidden=NO;
                self.translateStatusLabel.text=@"TimeLineDetailCommentTableViewCellTranslateSuccess".icanlocalized;
                
            }
                break;
            case 2:{
                //翻译失败
                self.twoLineView.hidden=YES;
                self.translateStatusBgView.hidden=NO;
                self.translateStatusLabel.text=@"TimeLineDetailCommentTableViewCellFail".icanlocalized;
                self.translateLabel.hidden=YES;
            }
                break;
        }
        
        //这个字段不为空就是回复
        if (comment.targetCommentId) {
            NSMutableAttributedString *textAttributedString = [XMFaceManager emotionStrWithString:comment.content];
            NSMutableAttributedString*contentStr=[[NSMutableAttributedString alloc]initWithString:@"Reply".icanlocalized];
            [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:comment.replyToNickName]];
            [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:@":"]];
            [contentStr appendAttributedString:textAttributedString];
            [contentStr addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(@"Reply".icanlocalized.length, comment.replyToNickName.length)];
            self.contentLabel.attributedText=contentStr;
        }else{
            NSMutableAttributedString *textAttributedString = [XMFaceManager emotionStrWithString:comment.content];
            [textAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, textAttributedString.length)];
            self.contentLabel.attributedText=textAttributedString;
        }
    }
    
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[MessageMenuView alloc]init];
        _menuView.messageMenuViewDelegate=self;
//        self.contentLabel.backgroundColor=UIColor238Color;
//        [self.menuView showTimelineMenuView:self.contentView convertRectView:self.contentLabel];
    }
    return _menuView;
}
-(void)didClickMesageMenuViewDelegate:(MenuItem *)item{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    switch (item.selectMessageType) {
        case SelectMessageTypeCopy:{
            if (self.comment.translateStatus==1) {
                UIPasteboard*pas=[UIPasteboard generalPasteboard];
                NSString*contentString;
                if (self.comment.targetCommentId) {
                    NSMutableAttributedString*contentStr=[[NSMutableAttributedString alloc]initWithString:@"Reply".icanlocalized];
                    [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:self.comment.replyToNickName]];
                    [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:@":"]];
                    contentString=[self.contentLabel.attributedText string];
                    contentString=[contentString substringFromIndex:contentStr.length];
                }else{
                    contentString=[self.contentLabel.attributedText string];
                }
                
                NSString*trans=self.translateLabel.attributedText.string;
                pas.string=[contentString stringByAppendingFormat:@"\n%@",trans];
                
            }else{
                UIPasteboard*pas=[UIPasteboard generalPasteboard];
                NSString*contentString;
                if (self.comment.targetCommentId) {
                    NSMutableAttributedString*contentStr=[[NSMutableAttributedString alloc]initWithString:@"Reply".icanlocalized];
                    [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:self.comment.replyToNickName]];
                    [contentStr appendAttributedString:[[NSAttributedString alloc]initWithString:@":"]];
                    contentString=[self.contentLabel.attributedText string];
                    contentString=[contentString substringFromIndex:contentStr.length];
                }else{
                    contentString=[self.contentLabel.attributedText string];
                }
                pas.string=contentString;
            }
            self.bgContentView.backgroundColor=UIColor.whiteColor;
          
        }
            break;
        case SelectMessageTypeDelete:{
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }
            break;
        case SelectMessageTypeTranslate:{
            [[NetworkRequestManager shareManager]translateGeogleLanguageWithText:self.comment.content success:^(NSString *translateText) {
                self.comment.translateMsg=translateText;
                self.comment.translateStatus=1;
                [[WCDBManager sharedManager]insertTimelinesCommentInfo:self.comment];
                self.translateLabel.text=translateText;
                QMUITableView*tableView=(QMUITableView*)self.superview;
                [tableView reloadData];
               } failure:^(NSError *error) {
                   
               }];
        }
            break;
        case SelectMessageTypeTranslateHide:{
            self.comment.translateStatus=0;
            QMUITableView*tableView=(QMUITableView*)self.superview;
            [tableView reloadData];
        }
            break;
        case SelectMessageTypeOriginText:{
            self.comment.translateMsg=@"";
            self.comment.translateStatus=0;
            [[WCDBManager sharedManager]insertTimelinesCommentInfo:self.comment];
            QMUITableView*tableView=(QMUITableView*)self.superview;
            [tableView reloadData];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - Event

@end

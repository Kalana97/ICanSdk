//
//  ChatLeftTxtMsgTableViewCell.m
//  ICan
//
//  Created by dzl on 23/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightTxtMsgTableViewCell.h"
#import "DZTextView.h"
#import "XMFaceManager.h"
#import "MenuItem.h"
#import "WCDBManager+ChatModel.h"
@interface ChatRightTxtMsgTableViewCell()<UITextViewDelegate>
@property(nonatomic, strong) UIView *textBgView;
//底部imageView
@property(nonatomic,strong)  UIImageView * containBgImageView;
@property(nonatomic, strong) UIStackView *textContentVerticalStackView;

@property(nonatomic,strong)  DZTextView * textView;
/** 翻译分割线 */
@property(nonatomic,strong)  UIView *translateSegmentationView;
@property(nonatomic,strong)  UIView *translateLineView;
/** 翻译状态文字 */
@property(strong, nonatomic)  UIView *translateTextBgView;
/** 放置翻译文字的label */
@property(nonatomic,strong)  UILabel *translateLabel;
///
@property(strong,nonatomic)  UIView *translateStateBgView;
@property(strong,nonatomic)  UIButton *translateBtn;
@property(nonatomic,strong)  UILabel *statueLabel;
@property(nonatomic,strong)  UILabel *timeLabel;
@property(nonatomic,strong)  UILabel *timeLabelDown;
@property(nonatomic, strong) UIView *timeLableBgView;
@property(nonatomic, strong) UIView *replyViewContainer;
@property(nonatomic, strong) UIView *replyView;
@property(nonatomic, strong) UIStackView *replyHorizontalView;
@property(nonatomic, strong) UIStackView *replyVerticalView;
@property(nonatomic, strong) UIView *replyLeftLineView;
@property(nonatomic, strong) UILabel *repliedUserLbl;
@property(nonatomic, strong) UILabel *replyTextLbl;
@property(nonatomic, strong) UIView *repliedUserLblContainer;
@property(nonatomic, strong) UIView *replyLblContainer;
/** 翻译之后的状态imageView */
@property(nonatomic,strong)  UIImageView *translateStatueImageView;
@property(nonatomic,assign)  NSInteger fontSize;

@end
@implementation ChatRightTxtMsgTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setTranslateState];
    self.fontSize = UserInfoManager.sharedManager.fontSize.intValue;
    self.currentChatModel.attrStr = [XMFaceManager emotionStrWithString:self.currentChatModel.showMessage isOutGoing:self.currentChatModel.isOutGoing];
    self.currentChatModel.attrStr = [NSString getUrl:self.currentChatModel.attrStr];
    if (self.searchText&&self.shouldHightShow) {
        NSRange rang=[self.currentChatModel.attrStr.string rangeOfString:self.searchText];
        [self.currentChatModel.attrStr addAttribute:NSBackgroundColorAttributeName value:UIColorMake(99, 174, 252) range:rang];
    }
    [self.textView setAttributedText:self.currentChatModel.attrStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 0;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:[self.currentChatModel.attrStr string]
                                                                             attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    self.textView.attributedText = attributedText;
    self.textView.textColor = [UIColor blackColor];
    self.textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    if(self.fontSize != 0){
            if(self.fontSize == 19){
                self.textView.font = [UIFont systemFontOfSize:19.0];
            }else if (self.fontSize == 17) {
                self.textView.font = [UIFont systemFontOfSize:17.0];
            }else if (self.fontSize == 16) {
                self.textView.font = [UIFont systemFontOfSize:16.0];
            }
    }else {
            self.textView.font = [UIFont systemFontOfSize:17.0];
            UserInfoManager.sharedManager.fontSize = @"17";
    }
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabel.text = [GetTime getTime:date];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.textContentVerticalStackView addArrangedSubview:self.timeLableBgView];
    [self.timeLableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
    }];
    [self.textView addSubview:self.timeLabel];
    [self.timeLableBgView addSubview:self.timeLabelDown];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textContentVerticalStackView.mas_right).offset(-10);
        make.bottom.equalTo(self.textContentVerticalStackView.mas_bottom).offset(-2);
    }];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textContentVerticalStackView.mas_right).offset(-10);
        make.bottom.equalTo(self.textContentVerticalStackView.mas_bottom).offset(-2);
    }];
    [self setTextViewHeight];
    [self setTimeLable];
    [self setReactions:self.currentChatModel];
    [self setupReplyUI];
}

-(void)setupReplyUI{
    self.replyViewContainer.hidden = !self.isReplay;
    if(self.isReplay){
        self.repliedUserLbl.text = self.replierName;
        self.replyTextLbl.text = self.replyText;
    }
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)setTimeLable{
    if(self.timeLableFlag) {
        self.timeLableBgView.hidden = NO;
        self.timeLabel.hidden = YES;
    }else {
        self.timeLableBgView.hidden = YES;
        self.timeLabel.hidden = NO;
    }
}

-(void)replayLabelAction{
    if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(clickReplyActionByCell:)]) {
        [self.msgDelegate clickReplyActionByCell:self];
    }
}

-(void)setTextViewHeight{
    CGFloat height, width;
    if([UserInfoManager.sharedManager.fontSize isEqualToString: @"19"]){
        width = [NSString widthWithAttrbuteString:self.currentChatModel.attrStr height:23 cgflotTextFont:19.0];
        width = width+19.0 > KTextMaxWidth ? KTextMaxWidth : width+19.0;
        height = [NSString heightWithAttrbuteString:self.currentChatModel.attrStr width:width+8 cgflotTextFont:19.0];
    }else if([UserInfoManager.sharedManager.fontSize isEqualToString: @"17"]){
        width = [NSString widthWithAttrbuteString:self.currentChatModel.attrStr height:21 cgflotTextFont:17.0];
        width = width+17.0 > KTextMaxWidth ? KTextMaxWidth : width+17.0;
        height = [NSString heightWithAttrbuteString:self.currentChatModel.attrStr width:width+6 cgflotTextFont:17.0];
    }else{
        width = [NSString widthWithAttrbuteString:self.currentChatModel.attrStr height:20 cgflotTextFont:16.0];
        width = width+16.0 > KTextMaxWidth ? KTextMaxWidth : width+16.0;
        height = [NSString heightWithAttrbuteString:self.currentChatModel.attrStr width:width+5 cgflotTextFont:16.0];
    }
    [self.textBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width+55));
    }];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height>30?height:30));
    }];
}

-(void)setTranslateState{
    switch (self.currentChatModel.translateStatus) {
        case 0:{
            self.translateStateBgView.hidden = YES;
            self.translateTextBgView.hidden = YES;
            self.translateSegmentationView.hidden=YES;
        }
            break;
        case 1:{
            self.translateStateBgView.hidden = NO;
            self.translateTextBgView.hidden=NO;
            self.translateSegmentationView.hidden=NO;
            self.statueLabel.textColor=UIColor.blackColor;
            self.statueLabel.text=NSLocalizedString(@"Translation successful", 翻译成功);
            self.translateLabel.text=self.currentChatModel.translateMsg;
            self.translateStatueImageView.image=UIImageMake(@"translate_success_right");
        }
            break;
        case 2:{
            self.translateStateBgView.hidden = YES;
            self.translateTextBgView.hidden = NO;
            self.translateSegmentationView.hidden=NO;
            self.translateLabel.text=@"";
            self.statueLabel.text=NSLocalizedString(@"Retranslate", 重新翻译);
            self.statueLabel.textColor=UIColor244RedColor;
            self.translateStatueImageView.image=UIImageMake(@"chat_sendfailure_btn");
        }
            break;
            
    }
}

-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView = self.containBgImageView;
        self.textView.selectedRange=NSMakeRange(0, [self.currentChatModel.attrStr string].length);
        [self.textView becomeFirstResponder];
        [super longPress:longPressGes];
    }
}

-(void)clickMessageMunuView:(MenuItem *)item{
    if (item.selectMessageType ==SelectMessageTypeCopy) {
        UIPasteboard * pasterBoard = [UIPasteboard generalPasteboard];
        pasterBoard.string = [self.currentChatModel.showMessage substringWithRange:self.textView.selectedRange];
    }else if (item.selectMessageType==SelectMessageTypeTranslateHide){
        [self translateHideAction];
    }else if (item.selectMessageType==SelectMessageTypeTranslate){
        [self translateAction];
    }else if (item.selectMessageType==SelectMessageTypeAll){
        [self allChoseAction];
    }
}
///翻译文字
-(void)translateAction{
    [[NetworkRequestManager shareManager]translateGeogleLanguageWithText:self.currentChatModel.attrStr.string success:^(NSString *translateText) {
        CGFloat tipsWidth=[NSString widthForString:NSLocalizedString(@"Translation successful", 翻译成功) withFontSize:13 height:20]+36;
        //1：判断原来的长度和原文字的长度 如果都小于最短长度 那么以最小长度为准
        //2:如果原来的文字长度是最大长度，那么翻译的label就以最大长度为准
        //3:如果翻译的长度是最大长度 但是那么需要重新计算原来的文字的高度
        //4:16+15+5+50 翻译之后的最小宽度就是80 最大的宽度就是KTextMaxWidth
        CGFloat translateWidth = [NSString widthForString:translateText withFontSize:16 height:20];
        translateWidth = translateWidth+16 > KTextMaxWidth ? KTextMaxWidth : translateWidth+16;
        translateWidth=translateWidth>tipsWidth?translateWidth:tipsWidth;
        //确保最小为宽度为80
        if (translateWidth>self.currentChatModel.layoutWidth||translateWidth==self.currentChatModel.layoutWidth) {
            self.currentChatModel.layoutWidth=translateWidth;
        }
        self.currentChatModel.translateStatus=1;
        self.currentChatModel.translateMsg=translateText;
        
        DDLogInfo(@"翻译成功=%@",translateText);
        QMUITableView*tableView=(QMUITableView*)self.superview;
        [tableView reloadData];
        [[WCDBManager sharedManager]updateTranslateWithChatmodel:self.currentChatModel];
    } failure:^(NSError *error) {
        self.currentChatModel.translateStatus=2;
        CGFloat tipsWidth=[NSString widthForString: NSLocalizedString(@"Translation failure", 翻译失败) withFontSize:13 height:20];
        if (self.currentChatModel.layoutWidth<=tipsWidth) {
            self.currentChatModel.layoutWidth=tipsWidth;
        }
        
        [[WCDBManager sharedManager]updateTranslateWithChatmodel:self.currentChatModel];
        QMUITableView*tableView=(QMUITableView*)self.superview;
        [tableView reloadData];
    }];
}

-(void)translateHideAction{
    self.currentChatModel.translateStatus=0;
    [[WCDBManager sharedManager]updateTranslateWithChatmodel:self.currentChatModel];
    QMUITableView*tableView=(QMUITableView*)self.superview;
    [tableView reloadData];
}

-(void)allChoseAction{
    self.textView.selectedRange = NSMakeRange(0, self.textView.text.length);
}
-(void)addItmes{
    if(self.longpressStatus){
        [self.menuView showMessageMenuView:self.contentView convertRectView:self.containBgImageView ChatModel:self.currentChatModel showTime:self.isShowTime];
    }
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.selectedRange.location>0 && textView.selectedRange.location <textView.text.length) {
        self.textView.selectedRange = textView.selectedRange;
    }
    if (textView.selectedRange.location==0 && textView.selectedRange.length==textView.text.length) {
        self.currentChatModel.isSelectAll = YES;
    }else{
        self.currentChatModel.isSelectAll = NO;
    }
    
    NSRange range=NSMakeRange(self.currentChatModel.attrStr.length, 0);
    if (textView.selectedRange.length!=0) {
        if (![[NSValue valueWithRange:range]isEqualToValue:[NSValue valueWithRange:textView.selectedRange]]) {
//            [self addItmes]; --> No need of message menu for double tab gestures.
        }
    }
}
-(void)setUpUI{
    [super setUpUI];
    [self.bodyContentView addSubview:self.textBgView];
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@0);
        make.top.equalTo(@1);
        make.bottom.equalTo(@0);
    }];
    [self.textBgView addSubview:self.containBgImageView];
    [self.containBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.textBgView addSubview:self.textContentVerticalStackView];
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
    }];
    [self.textContentVerticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.textContentVerticalStackView addArrangedSubview:self.replyViewContainer];
    [self.replyViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@70);
        make.width.equalTo(@20);
    }];
    [self.replyViewContainer addSubview:self.replyView];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.replyViewContainer).with.insets(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    [self.replyView addSubview:self.replyHorizontalView];
    [self.replyHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.replyHorizontalView addArrangedSubview:self.replyLeftLineView];
    [self.replyLeftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@5);
    }];
    [self.replyHorizontalView addArrangedSubview:self.replyVerticalView];
    [self.replyVerticalView addArrangedSubview:self.repliedUserLblContainer];
    [self.repliedUserLblContainer addSubview:self.repliedUserLbl];
    [self.repliedUserLblContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
    }];
    [self.repliedUserLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@5);
        make.centerY.equalTo(self.repliedUserLblContainer.mas_centerY); // Center vertically
    }];
    [self.replyVerticalView addArrangedSubview:self.replyLblContainer];
    [self.replyLblContainer addSubview:self.replyTextLbl];
    [self.replyTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.top.equalTo(@3);
        make.bottom.equalTo(@-3);
    }];
    [self.textContentVerticalStackView addArrangedSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
    }];
    [self.textContentVerticalStackView addArrangedSubview:self.translateSegmentationView];
    [self.translateSegmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
    }];
    [self.translateSegmentationView addSubview:self.translateLineView];
    [self.translateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
    [self.textContentVerticalStackView addArrangedSubview:self.translateTextBgView];
    [self.translateTextBgView addSubview:self.translateLabel];
    [self.translateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@8);
        make.bottom.right.equalTo(@-8);
    }];
    [self.textContentVerticalStackView addArrangedSubview:self.translateStateBgView];
    [self.translateStateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
    }];
    [self.translateStateBgView addSubview:self.translateBtn];
    [self.translateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.translateStateBgView addSubview:self.translateStatueImageView];
    [self.translateStatueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(_translateStateBgView.mas_centerY);
    }];
    [self.translateStateBgView addSubview:self.statueLabel];
    [self.statueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.translateStatueImageView.mas_right).offset(10);
        make.centerY.equalTo(_translateStateBgView.mas_centerY);
    }];
    UILongPressGestureRecognizer *textViewLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.containBgImageView.userInteractionEnabled = YES;
    textViewLongGesture.minimumPressDuration = 0.3;
    [self.containBgImageView addGestureRecognizer:textViewLongGesture];
    [self.textBgView addGestureRecognizer:textViewLongGesture];
    [self.textContentVerticalStackView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-8);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@25);
    }];
}
-(UIView *)textBgView{
    if (!_textBgView) {
        _textBgView = [[UIView alloc]init];
    }
    return _textBgView;
}
-(UIImageView *)containBgImageView{
    if (!_containBgImageView) {
        _containBgImageView = [[UIImageView alloc]init];
        _containBgImageView.layer.cornerRadius = 10;
        _containBgImageView.layer.masksToBounds = YES;
        _containBgImageView.backgroundColor = [UIColor qmui_colorWithHexString:@"#DDEBFF"];
    }
    return _containBgImageView;
}

-(UIStackView *)textContentVerticalStackView{
    if (!_textContentVerticalStackView) {
        _textContentVerticalStackView = [[UIStackView alloc]init];
        _textContentVerticalStackView.axis = UILayoutConstraintAxisVertical;
    }
    return _textContentVerticalStackView;
}
-(DZTextView *)textView{
    if (!_textView) {
        _textView = [[DZTextView alloc]init];
        _textView.backgroundColor = UIColor.clearColor;
        _textView.delegate=self;
        _textView.textContainerInset=UIEdgeInsetsMake(8, 5, 8, 5);
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.userInteractionEnabled = YES;
        
    }
    return _textView;
}
-(UIView *)translateSegmentationView{
    if (!_translateSegmentationView) {
        _translateSegmentationView = [[UIView alloc]init];
        _translateSegmentationView.backgroundColor = UIColor.clearColor;
        
    }
    return _translateSegmentationView;
}
-(UIView *)translateLineView{
    if (!_translateLineView) {
        _translateLineView = [[UIView alloc]init];
        _translateLineView.backgroundColor = UIColor.blackColor;
    }
    return _translateLineView;
}
- (UIView *)timeLableBgView {
    if (!_timeLableBgView) {
        _timeLableBgView = [[UIView alloc]init];
        _timeLableBgView.backgroundColor = UIColor.clearColor;
        [_timeLableBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    return _timeLableBgView;
}
- (UILabel *)statueLabel {
    if (!_statueLabel) {
        _statueLabel = [UILabel leftLabelWithTitle:nil font:13 color:UIColor.blackColor];
    }
    return _statueLabel;
}
-(UIView *)translateTextBgView{
    if (!_translateTextBgView) {
        _translateTextBgView = [[UIView alloc]init];
        _translateTextBgView.backgroundColor = UIColor.clearColor;
        
    }
    return _translateTextBgView;
}
-(UILabel *)translateLabel{
    if (!_translateLabel) {
        _translateLabel = [UILabel leftLabelWithTitle:nil font:16 color:UIColor.blackColor];
        _translateLabel.numberOfLines = 0;
    }
    return _translateLabel;
}
- (UIView *)translateStateBgView{
    if (!_translateStateBgView) {
        _translateStateBgView = [[UIView alloc]init];
        _translateStateBgView.backgroundColor  = UIColor.clearColor;
        
    }
    return _translateStateBgView;
}
-(UIButton *)translateBtn{
    if (!_translateBtn) {
        _translateBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(translateBtnAction)];
    }
    return _translateBtn;
}
-(void)translateBtnAction{
    if (self.currentChatModel.translateStatus==2) {
        [self translateAction];
    }
}
-(UIImageView *)translateStatueImageView{
    if (!_translateStatueImageView) {
        _translateStatueImageView = [[UIImageView alloc]init];
    }
    return _translateStatueImageView;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.blackColor];
    }
    return _timeLabel;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.blackColor];
    }
    return _timeLabelDown;
}

- (UIView *)replyViewContainer{
    if (!_replyViewContainer) {
        _replyViewContainer = [[UIView alloc]init];
        _replyViewContainer.layer.masksToBounds = YES;
        _replyViewContainer.layer.cornerRadius = 10;
        UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replayLabelAction)];
        [_replyViewContainer addGestureRecognizer:replyTap];
    }
    return _replyViewContainer;
}

- (UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc]init];
        _replyView.backgroundColor = UIColorMake(243, 243, 243);
        _replyView.layer.masksToBounds = YES;
        _replyView.layer.cornerRadius = 10;
    }
    return _replyView;
}

- (UIView *)replyLeftLineView{
    if(!_replyLeftLineView){
        _replyLeftLineView = [[UIView alloc]init];
        _replyLeftLineView.backgroundColor = UIColorThemeMainColor;
    }
    return _replyLeftLineView;
}

-(UIStackView *)replyHorizontalView{
    if (!_replyHorizontalView) {
        _replyHorizontalView = [[UIStackView alloc]init];
        _replyHorizontalView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _replyHorizontalView;
}

-(UIStackView *)replyVerticalView{
    if (!_replyVerticalView) {
        _replyVerticalView = [[UIStackView alloc]init];
        _replyVerticalView.axis = UILayoutConstraintAxisVertical;
    }
    return _replyVerticalView;
}

-(UILabel *)replyTextLbl{
    if (!_replyTextLbl) {
        _replyTextLbl = [[UILabel alloc]init];
        _replyTextLbl.numberOfLines = 2;
    }
    return _replyTextLbl;
}

- (UIView *)replyLblContainer{
    if (!_replyLblContainer) {
        _replyLblContainer = [[UIView alloc]init];
        _replyLblContainer.backgroundColor = UIColorMake(243, 243, 243);
    }
    return _replyLblContainer;
}

- (UIView *)repliedUserLblContainer{
    if (!_repliedUserLblContainer) {
        _repliedUserLblContainer = [[UIView alloc]init];
        _repliedUserLblContainer.backgroundColor = UIColorMake(243, 243, 243);
    }
    return _repliedUserLblContainer;
}

-(UILabel *)repliedUserLbl{
    if (!_repliedUserLbl) {
        _repliedUserLbl = [[UILabel alloc] init];
        _repliedUserLbl.textColor = UIColorThemeMainColor;
        _repliedUserLbl.numberOfLines = 1;
    }
    return _repliedUserLbl;
}

-(ReactionBar *)reactionBar{
    if(!_reactionBar){
        _reactionBar = [[ReactionBar alloc] init];
        _reactionBar.backgroundColor = UIColorMake(243, 243, 243);
    }
    return _reactionBar;
}

@end

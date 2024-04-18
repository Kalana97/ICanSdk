//
//  TimelinesSubCommentTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesSubCommentTableViewCell.h"
#import "XMFaceManager.h"
#import "DZTextView.h"
#import "FriendDetailViewController.h"
@interface TimelinesSubCommentTableViewCell()

@property(nonatomic,strong)UIView * bgGrayView;//灰色背景
@property(nonatomic,strong)DZIconImageView * iconView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton *replyBtn;

@property(nonatomic,strong)UIButton * deleteBtn;


@end

@implementation TimelinesSubCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.lineView.hidden =YES;
    }
    
    return self;
}

-(void)setupView{
    [self.contentView addSubview:self.bgGrayView];
    [self.bgGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.top.equalTo(@0);
        make.bottom.equalTo(@-30);
        make.right.equalTo(@-45);
    }];
    [self.contentView addSubview:self.replyBtn];
    CGFloat width=[self.replyBtn getButtonTextWith];
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgGrayView.mas_bottom).offset(0);
        make.left.equalTo(@10);
        make.height.equalTo(@30);
        make.width.equalTo(@(width));
    }];
    CGFloat dwidth=[self.deleteBtn getButtonTextWith];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.replyBtn.mas_centerY);
        make.width.equalTo(@(dwidth));
        make.height.equalTo(@30);
        make.left.equalTo(self.replyBtn.mas_right).offset(10);
        
        
    }];
    [self.bgGrayView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.left.equalTo(@10);
        make.top.equalTo(@15);
        
    }];
    
    [self.bgGrayView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(@-100);
    }];
    
    [self.bgGrayView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView.mas_centerY);
        make.right.equalTo(@-10);
    }];
    
    [self.bgGrayView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(self.iconView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
    
    
}


-(void)setReplyVOsInfo:(ReplyVOsInfo *)replyVOsInfo{
    _replyVOsInfo = replyVOsInfo;
    [self.iconView setDZIconImageViewWithUrl:replyVOsInfo.belongsHeadImgUrl gender:replyVOsInfo.belongsGender];
    self.nameLabel.text = replyVOsInfo.belongsNickName;
    if ([[UserInfoManager sharedManager].userId isEqualToString:replyVOsInfo.belongsId]) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    self.timeLabel.text = [GetTime timelinesTime:replyVOsInfo.publishTime];
    NSMutableAttributedString *textAttributedString = [XMFaceManager emotionStrWithString:replyVOsInfo.content];
    [textAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, textAttributedString.length)];
    [self.textView setAttributedText:textAttributedString];
    
}
-(UIView *)bgGrayView{
    if (!_bgGrayView) {
        _bgGrayView = [UIView new];
        _bgGrayView.backgroundColor =UIColorBg243Color;
        [_bgGrayView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    
    return _bgGrayView;
}

-(DZIconImageView *)iconView{
    if (!_iconView) {
        _iconView = [[DZIconImageView alloc]init];
        [_iconView addTap];
        @weakify(self);
        _iconView.tapBlock = ^{
            @strongify(self);
            FriendDetailViewController * vc = [FriendDetailViewController new];
            vc.userId = self.replyVOsInfo.belongsId;
            vc.friendDetailType=FriendDetailType_push;
            [[AppDelegate shared] pushViewController:vc animated:YES];
        };
        ViewRadius(_iconView, 35/2);
    }
    
    return _iconView;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel leftLabelWithTitle:@"" font:15.0 color:UIColor252730Color];
    }
    
    return _nameLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:15.0];
        _textView.scrollEnabled = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = UIColor252730Color;
        _textView.backgroundColor = UIColorBg243Color;
        _textView.editable= NO;
    }
    return _textView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel rightLabelWithTitle:@"" font:12.0 color:UIColor153Color];
    }
    
    return _timeLabel;
}


-(void)replyAction{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(replyMegWith:commentId:nickName:)]) {
        [self.delegate replyMegWith:self.replyVOsInfo.ID commentId:self.commentId nickName:self.replyVOsInfo.belongsNickName];
    }
    
}

-(UIButton *)replyBtn{
    if (!_replyBtn) {
        _replyBtn = [UIButton dzButtonWithTitle:@"Reply".icanlocalized image:nil backgroundColor:nil titleFont:14.0 titleColor:UIColor252730Color target:self action:@selector(replyAction)];
    }
    
    return _replyBtn;
}


-(void)deleteAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteReplyMegWith:)]) {
        [self.delegate deleteReplyMegWith:self.replyVOsInfo.ID];
    }
    
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton dzButtonWithTitle:@"Delete".icanlocalized image:nil backgroundColor:nil titleFont:14.0 titleColor:UIColorMake(29, 129, 245) target:self action:@selector(deleteAction)];
    }
    return _deleteBtn;
}


@end

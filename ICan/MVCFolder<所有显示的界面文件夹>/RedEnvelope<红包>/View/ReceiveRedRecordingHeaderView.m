//
//  ReceiveRedRecordingHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "ReceiveRedRecordingHeaderView.h"

@interface ReceiveRedRecordingHeaderView ()

@property(nonatomic,strong)UIImageView * timeImageView;
/** 头像 */
@property(nonatomic,strong)DZIconImageView * headImageView;
/** 姓名 */
@property(nonatomic,strong)UILabel *nameLabel;
/** 总金额 */
@property(nonatomic,strong)UILabel *totalAmountLabel;
/** 遮盖层 */
@property(nonatomic,strong)UIView * clearView;

/** 收到的红包个数 */
@property(nonatomic,strong)UILabel *receiveCountLabel;
/** 收到的红包提示语 */
@property(nonatomic,strong)UILabel *receiveTipLabel;
/** 手气最佳 个数*/
@property(nonatomic,strong)UILabel *luckyCountLabel;
/** 手气最佳提示 */
@property(nonatomic,strong)UILabel *luckyTipLabel;
/** 发出的红包提示 */
@property(nonatomic,strong)UILabel *totalSendTipsLabel;
@end

@implementation ReceiveRedRecordingHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpview];
        [self showGrabRedPacketTips];
    }
    
    return self;
}
-(void)showGrabRedPacketTips{
    self.receiveCountLabel.hidden=self.receiveTipLabel.hidden=
    self.luckyCountLabel.hidden=self.luckyTipLabel.hidden=NO;
    self.totalSendTipsLabel.hidden=YES;
}
-(void)showSendRedPacketTips{
    self.receiveCountLabel.hidden=self.receiveTipLabel.hidden=
    self.luckyCountLabel.hidden=self.luckyTipLabel.hidden=YES;
    self.totalSendTipsLabel.hidden=NO;
}
-(void)setRedPacketSummaryInfo:(RedPacketSummaryInfo *)redPacketSummaryInfo{
    _redPacketSummaryInfo=redPacketSummaryInfo;
    self.totalAmountLabel.text=[NSString stringWithFormat:@"%.2f",[redPacketSummaryInfo.money doubleValue]];
    self.receiveCountLabel.text=redPacketSummaryInfo.count;
    self.luckyCountLabel.text=redPacketSummaryInfo.goodLuck;
    NSMutableAttributedString*attstr;
    if (BaseSettingManager.isChinaLanguages) {
        NSString*totalSendTipsStr=  [NSString stringWithFormat:@"发出的红包%@个",redPacketSummaryInfo.count];
        attstr=[[NSMutableAttributedString alloc]initWithString:totalSendTipsStr];
        [attstr addAttribute:NSForegroundColorAttributeName value:UIColorMake(205, 175, 113) range:NSMakeRange(5, redPacketSummaryInfo.count.length)];
    }else{
        NSString*totalSendTipsStr=  [NSString stringWithFormat:@"%@ %@",@"Sent red packet".icanlocalized,redPacketSummaryInfo.count];
        attstr=[[NSMutableAttributedString alloc]initWithString:totalSendTipsStr];
        [attstr addAttribute:NSForegroundColorAttributeName value:UIColorMake(205, 175, 113) range:NSMakeRange(attstr.length-redPacketSummaryInfo.count.length, redPacketSummaryInfo.count.length)];
    }
   
   
    self.totalSendTipsLabel.attributedText=attstr;
}
-(void)setUpview{
    self.backgroundColor = UIColorBg243Color;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.equalTo(@-10);
    }];
    
    [self addSubview:self.timeImageView];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.timeLabel.mas_centerX);
        make.width.height.equalTo(@15);
    }];
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@55);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.timeImageView.mas_bottom);
    }];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.totalAmountLabel];
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    [self addSubview:self.totalSendTipsLabel];
    [self.totalSendTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.totalAmountLabel.mas_bottom).offset(25);
    }];
    [self addSubview:self.receiveCountLabel];
    [self.receiveCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-100);
        make.top.equalTo(self.totalAmountLabel.mas_bottom).offset(20);
    }];
    
    [self addSubview:self.receiveTipLabel];
    [self.receiveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.receiveCountLabel.mas_centerX);
        make.top.equalTo(self.receiveCountLabel.mas_bottom).offset(10);
    }];
    [self addSubview:self.luckyCountLabel];
    [self.luckyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(100);
        make.centerY.equalTo(self.receiveCountLabel.mas_centerY).offset(0);
    }];
    [self addSubview:self.luckyTipLabel];
    [self.luckyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.luckyCountLabel.mas_centerX);
        make.centerY.equalTo(self.receiveTipLabel.mas_centerY).offset(0);
    }];
    [self addSubview:self.clearView];
    [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.timeImageView);
        make.height.width.equalTo(@30);
    }];
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
        NSString * year = [GetTime stringFromDate:date withDateFormat:@"yyyy"];
        
        _timeLabel = [UILabel rightLabelWithTitle:[NSString stringWithFormat:@"%@",year] font:15.0 color:UIColorMake(191, 157, 94)];
        _timeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMoreTimeAction)];
        [_timeLabel addGestureRecognizer:tap];
    }
    return _timeLabel;
}

-(UIImageView *)timeImageView{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red_choice"]];
        _timeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMoreTimeAction)];
        [_timeImageView addGestureRecognizer:tap];
    }
    return _timeImageView;
}

-(void)showMoreTimeAction{
    !self.showMoreTimeBlock?:self.showMoreTimeBlock();
}

-(DZIconImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[DZIconImageView alloc]initWithImage:[UIImage imageNamed:BoyDefault]];
        ViewRadius(_headImageView, 55/2);
        [_headImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
        
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel centerLabelWithTitle:@"" font:16.5 color:UIColorThemeMainTitleColor];
        if (BaseSettingManager.isChinaLanguages) {
            _nameLabel.text=[NSString stringWithFormat:@"%@的红包",[UserInfoManager sharedManager].nickname];
        }else{
            _nameLabel.text=[NSString stringWithFormat:@"%@'s %@",[UserInfoManager sharedManager].nickname,@"showReceiveRedPacketTip".icanlocalized];
        }
       
    }
    return _nameLabel;
}

-(UILabel *)totalAmountLabel{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [UILabel centerLabelWithTitle:@"8888.88" font:45 color:UIColorThemeMainTitleColor];
    }
    return _totalAmountLabel;
}

-(UILabel *)receiveCountLabel{
    if (!_receiveCountLabel) {
        _receiveCountLabel = [UILabel centerLabelWithTitle:@"110" font:25 color:UIColorThemeMainSubTitleColor];
    }
    return _receiveCountLabel;
}

-(UILabel *)receiveTipLabel{
    if (!_receiveTipLabel) {
        _receiveTipLabel = [UILabel centerLabelWithTitle:@"Received red packet".icanlocalized font:15 color:UIColorThemeMainSubTitleColor];
    }
    return _receiveTipLabel;
}
-(UILabel *)luckyCountLabel{
    if (!_luckyCountLabel) {
        _luckyCountLabel = [UILabel centerLabelWithTitle:@"15" font:25 color:UIColorThemeMainSubTitleColor];
    }
    return _luckyCountLabel;
}
-(UILabel *)luckyTipLabel{
    if (!_luckyTipLabel) {
        _luckyTipLabel = [UILabel centerLabelWithTitle:@"Luckiest Draw".icanlocalized font:15 color:UIColorThemeMainSubTitleColor];
    }
    return _luckyTipLabel;
}
-(UILabel *)totalSendTipsLabel{
    if (!_totalSendTipsLabel) {
        _totalSendTipsLabel = [UILabel centerLabelWithTitle:@"发出红包 198 个" font:18 color:UIColorThemeMainSubTitleColor];
    }
    return _totalSendTipsLabel;
    
}
-(UIView *)clearView{
    if (!_clearView) {
        _clearView = [UIView new];
        _clearView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMoreTimeAction)];
        [_clearView addGestureRecognizer:tap];
    }
    
    return _clearView;
}

@end

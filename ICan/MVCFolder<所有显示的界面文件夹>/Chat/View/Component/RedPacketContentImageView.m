//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 31/3/2020
 - File name:  RedPacketContentImageView.m
 - Description:
 - Function List:
 */


#import "RedPacketContentImageView.h"
#import "ChatModel.h"
@interface RedPacketContentImageView()
@property(nonatomic, strong) UIImageView *tipImageView;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, strong) UILabel *commentLabel;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic,strong) UILabel *timeLabelDown;

@end
@implementation RedPacketContentImageView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpUI];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
-(void)setChatModel:(ChatModel *)chatModel{
    SingleRedPacketMessageInfo*info=[SingleRedPacketMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
    self.commentLabel.text=info.comment;
    NSString*statusLabelText;
    if (chatModel.showRedState) {
        //"expired", "红包已经过期" "received", "请勿重复领取" "empty","已经被抢完" success 表示成功抢到红包
        self.bgImageView.image=UIImageMake(@"icon_red_packet_bg_other");
        self.tipImageView.image=UIImageMake(@"icon_red_packet_other");
        self.statusLabel.hidden=NO;
        if ([chatModel.redPacketState isEqualToString:Kexpired]) {
            statusLabelText=@"Expired";
            statusLabelText=@"Expired".icanlocalized;
        }else if ([chatModel.redPacketState isEqualToString:Kreceived]){//红包已经领取了
            statusLabelText=KreceivedDescription;
        }else if ([chatModel.redPacketState isEqualToString:KEmpty]){
            statusLabelText=@"Already received";
            statusLabelText=@"Already received".icanlocalized;
        }else{//success
            if ([chatModel.chatType isEqualToString:GroupChat]) {
                statusLabelText=@"Received".icanlocalized;
            }else{
                statusLabelText=chatModel.isOutGoing?@"Already received".icanlocalized:@"Received".icanlocalized;
            }
            
        }
        
        self.lineView.backgroundColor=UIColorMake(254, 235, 212);
        
        self.statusLabel.text=statusLabelText;
        [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipImageView.mas_right).offset(10);
            make.right.equalTo(@-10);
            make.centerY.equalTo(self.tipImageView.mas_centerY).offset(-10);
        }];
    }else{
        self.lineView.backgroundColor=UIColorMake(253, 178, 103);
        [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipImageView.mas_right).offset(10);
            make.right.equalTo(@-10);
            make.centerY.equalTo(self.tipImageView.mas_centerY);
        }];
        self.statusLabel.hidden=YES;
        self.bgImageView.image=UIImageMake(@"icon_red_packet_bg_normal");
        self.tipImageView.image=UIImageMake(@"icon_red_packet_normal");
    }
    NSDate*date=[GetTime dateConvertFromTimeStamp:chatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@73);
        make.right.equalTo(@-5);
    }];

    
}
-(void)setUpUI{
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.bgImageView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.top.equalTo(@12);
        make.width.equalTo(@(67/2.0));
        make.height.equalTo(@(77/2.0));
    }];
    [self.bgImageView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.tipImageView.mas_centerY);
    }];
    
    [self.bgImageView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.right.equalTo(@-12.5);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@-25);
    }];
    [self.bgImageView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.bottom.equalTo(@0);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    [self.bgImageView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipImageView.mas_bottom);
        make.left.equalTo(self.tipImageView.mas_right).offset(10);
        make.right.equalTo(@-10);
    }];
}

-(UIImageView *)tipImageView{
    if (!_tipImageView) {
        _tipImageView=[[UIImageView alloc]init];
    }
    return _tipImageView;
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView=[[UIImageView alloc]init];
    }
    return _bgImageView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel leftLabelWithTitle:@"chatView.function.redPacket".icanlocalized font:12 color:UIColor.whiteColor];
    }
    return _tipsLabel;
    
}
-(UILabel *)commentLabel{
    if (!_commentLabel) {
        
        _commentLabel=[UILabel leftLabelWithTitle:@"" font:16 color:UIColor.whiteColor];
    }
    return _commentLabel;
}
-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[UILabel leftLabelWithTitle:@"红包已领取" font:12 color:UIColor.whiteColor];
    }
    return _statusLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        //没有做任何操作的时候
        _lineView.backgroundColor=UIColorMake(253, 178, 103);
        //做了操作的时候
        //        UIColorMake(254, 235, 212)
    }
    return _lineView;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}
@end

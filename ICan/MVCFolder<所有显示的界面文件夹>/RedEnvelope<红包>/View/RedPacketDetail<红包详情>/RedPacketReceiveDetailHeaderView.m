//
//  RedPacketReceiveDetailHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/3.
//  Copyright © 2020 dzl. All rights reserved.
//  
/*
 自己发的（文案）
 1、X个红包共XX元，xx秒被领完（领完）
 2、已领取X/XX个，共xx/xx元（未领完）
 3、改红包已过期，已领取x/xx个，共xx/xx元（未领完已过期）
 别人发的（文案）
 1、领取x/x个 （未领完）
 2、x个红包，x分钟被领完（领完）
 3、领取x/x个 （未领完已过期）
 单人红包
 发包：x个红包共x元（已领取）
 发包：红包金额x元，等待对方领取（未领取）底部文案为“未领取的红包过期后会发起退款”
 发包：该红包已过期，已领取x/x个，共xx/xx元（未领取已过期），底部文案“未领取的红包过期后会发起退款”
 领包：无文案
 
 聊天窗点击过期的红包，显示“该红包已过期”
 */
#import "RedPacketReceiveDetailHeaderView.h"
#import "WalletViewController.h"
#import "IcanWalletPageViewController.h"
@interface RedPacketReceiveDetailHeaderView()
@property(nonatomic,strong)UIImageView * topImageView;
@property(nonatomic,strong)DZIconImageView * headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
/** 凭手气的红包 */
@property(nonatomic,strong)UIImageView * rightNameImageView;
/** 备注 */
@property(nonatomic,strong)UILabel *blessingLabel;
/** 抢到的金额 */
@property(nonatomic,strong)UILabel *moneyLabel;
/** 如果是抢到金额 */
@property(nonatomic,strong)UILabel *tipsLabel;

@property(nonatomic,strong)UIImageView * rightArrowImageView;//
/**分割线 */
@property(nonatomic, strong) UIView *lineView;
/** 领取状态 */
@property(nonatomic, strong) UILabel *receiveStatesLabel;
/** 底部的横线 */
@property(nonatomic, strong) UIView *bottomLineView;
@end

@implementation RedPacketReceiveDetailHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpview];
    }
    return self;
}
-(void)setRedPacketDetailInfo:(RedPacketDetailInfo *)redPacketDetailInfo{
    _redPacketDetailInfo=redPacketDetailInfo;
    [self.headImageView setDZIconImageViewWithUrl:redPacketDetailInfo.sendUserHeadImgUrl gender:redPacketDetailInfo.sendUserGender];
   
    NSString*nameStr;
    if (BaseSettingManager.isChinaLanguages) {
        nameStr= [NSString stringWithFormat:@"%@的红包",redPacketDetailInfo.sendUserNickname];
    }else{
        nameStr= [NSString stringWithFormat:@"%@'s red packet",redPacketDetailInfo.sendUserNickname];
    }
   
    CGFloat width=[NSString widthForString:nameStr withFontSize:20 height:10]+10;
    
    if (width>(ScreenWidth-80)) {
        width=ScreenWidth-80;
    }
    
    self.nameLabel.text=nameStr;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
       make.top.equalTo(self.topImageView.mas_bottom).offset(30);
        make.width.equalTo(@(width));
    }];
    self.blessingLabel.text=self.redPacketDetailInfo.comment;
    NSString*moneyString;
    NSMutableAttributedString*attStr;
    if (BaseSettingManager.isChinaLanguages) {
        moneyString=[NSString stringWithFormat:@"%.2f元",[redPacketDetailInfo.money floatValue]];
        attStr=[[NSMutableAttributedString alloc]initWithString:moneyString];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(attStr.length-1, 1)];
    }else{
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            moneyString = [NSString stringWithFormat:@"%.2fCNY",[redPacketDetailInfo.money floatValue]];
         }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            moneyString = [NSString stringWithFormat:@"%.2fCNT",[redPacketDetailInfo.money floatValue]];
        }
        attStr = [[NSMutableAttributedString alloc]initWithString:moneyString];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(attStr.length-3, 3)];
    }
    
    self.moneyLabel.attributedText = attStr;
    if ([redPacketDetailInfo.type isEqualToString:@"g"]&&[redPacketDetailInfo .roomRedPacketType isEqualToString:@"RANDOM"]) {
        self.rightNameImageView.hidden = NO;
    }
    
    //如果自己抢到钱
    if (redPacketDetailInfo.money) {
        self.moneyLabel.hidden = NO;
        self.tipsLabel.hidden = NO;
        self.rightArrowImageView.hidden = NO;
        
    }
    if ([redPacketDetailInfo.type isEqualToString:@"s"]) {//单人红包
        if ([redPacketDetailInfo.sendUserId isEqualToString:[UserInfoManager sharedManager].userId]) {
            if (redPacketDetailInfo.done) {//已经完成
                if (BaseSettingManager.isChinaLanguages) {
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"1%@%@%@%.2f%@",@"GE".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"共".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNYChat".icanlocalized];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"1%@%@%@%.2f%@",@"GE".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"共".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNY".icanlocalized];
                    }
                }else{
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"1 red packet, a total of %.2f CNY",[redPacketDetailInfo.totalMoney doubleValue]];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"1 red packet, a total of %.2f CNT",[redPacketDetailInfo.totalMoney doubleValue]];
                    }
                }
               
            }else if (redPacketDetailInfo.rejectTime){//返回过期时间就是已经过期了
                //该红包已过期，已领取x/x个，共xx/xx元（未领取已过期）
                if (BaseSettingManager.isChinaLanguages) {
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"%@，%@0/1%@，共0.00/%.2f %@",@"该红包已过期".icanlocalized,@"Received".icanlocalized,@"GE".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNYChat".icanlocalized];                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"%@，%@0/1%@，共0.00/%.2f %@",@"该红包已过期".icanlocalized,@"Received".icanlocalized,@"GE".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNY".icanlocalized];                    }
                    
                }else{
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"The red packet has expired, 0/1 has been received, a total of 0.00/%.2f CNY",[redPacketDetailInfo.totalMoney doubleValue]];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"The red packet has expired, 0/1 has been received, a total of 0.00/%.2f CNT",[redPacketDetailInfo.totalMoney doubleValue]];
                    }
                }
                
            }else{//红包金额x元，等待对方领取（未领取）
                if (BaseSettingManager.isChinaLanguages) {
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"%@%.2f%@，%@",@"Red packet amount".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNYChat".icanlocalized,@"Waiting for the other party to receive".icanlocalized];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"%@%.2f%@，%@",@"Red packet amount".icanlocalized,[redPacketDetailInfo.totalMoney doubleValue],@"CNY".icanlocalized,@"Waiting for the other party to receive".icanlocalized];
                    }
                }else{
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"Red packet amount %.2f CNY, waiting for the other party to receive",[redPacketDetailInfo.totalMoney doubleValue]];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        self.receiveStatesLabel.text = [NSString stringWithFormat:@"Red packet amount %.2f CNT, waiting for the other party to receive",[redPacketDetailInfo.totalMoney doubleValue]];
                    }
                }
               
            }
        }else{//没有提示语 单人领取红包之后 没有提示语
            self.receiveStatesLabel.hidden = YES;
            self.bottomLineView.hidden = YES;
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@10);
                make.left.right.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
        }
    }
}
-(NSString*)getRedAllGrabTime:(NSInteger)count{
    NSString* timeStr=nil;
    if (count<=60) {
        timeStr=[NSString stringWithFormat:@"%ld%@",(long)count,@"seconds".icanlocalized];
    }else if (count>60&&count<3600){
        timeStr=[NSString stringWithFormat:@"%ld%@",(long)count/60,@"minutes".icanlocalized];
    }
    else if (count>=3600){
        timeStr=[NSString stringWithFormat:@"%ld%@",(long)count/3600,@"hour".icanlocalized];
    }
    return timeStr;
}
-(void)setRedPacketDetailMemberListInfo:(RedPacketDetailMemberListInfo *)redPacketDetailMemberListInfo{
    _redPacketDetailMemberListInfo=redPacketDetailMemberListInfo;
    
    NSString*receiveStatesLabelStr;
    if ([self.redPacketDetailInfo.type isEqualToString:@"g"]) {
        if ([self.redPacketDetailInfo.sendUserId isEqualToString:[UserInfoManager sharedManager].userId]) {
            if (self.redPacketDetailInfo.done) {//已经完成
                NSInteger nowtime=[self.redPacketDetailInfo.createTime integerValue]/1000;
                NSInteger done=[self.redPacketDetailInfo.doneTime integerValue]/1000;
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@个红包共%.2f元，%@被抢完",self.redPacketDetailInfo.count,[self.redPacketDetailInfo.totalMoney doubleValue],[self getRedAllGrabTime:done-nowtime]];
                }else{
//                    5 red envelopes totaling 10 yuan, robbed in 5 seconds
                    //IcanChat
                    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                        receiveStatesLabelStr=[NSString stringWithFormat:@"Opend %@ red packets %.2f CNY in total,in %@",self.redPacketDetailInfo.count,[self.redPacketDetailInfo.totalMoney doubleValue],[self getRedAllGrabTime:done-nowtime]];
                     }

                    //IcanMeta
                    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                        receiveStatesLabelStr=[NSString stringWithFormat:@"Opend %@ red packets %.2f CNT in total,in %@",self.redPacketDetailInfo.count,[self.redPacketDetailInfo.totalMoney doubleValue],[self getRedAllGrabTime:done-nowtime]];
                    }
                }
               
                
            }else if (self.redPacketDetailInfo.rejectTime){//返回过期时间就是已经过期了
                //该红包已过期，已领取x/x个，共xx/xx元（未领取已过期）
                //                self.receiveStatesLabel.text=[NSString stringWithFormat:@"该红包已过期，已领取%@/1个",redPacketDetailInfo.];
                
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"该红包已过期，已领取%@/%@个",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }else{
                    receiveStatesLabelStr=[NSString stringWithFormat:@"The red envelope has expired,%@/%@ has been received",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }
            }else{//红包金额x元，等待对方领取（未领取）
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"已领取%@/%@个",redPacketDetailMemberListInfo.totalElements,self .redPacketDetailInfo.count];
                }else{
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@/%@ have been received",redPacketDetailMemberListInfo.totalElements,self .redPacketDetailInfo.count];
                }
                
            }
        }else{
            if (self.redPacketDetailInfo.done) {//已经完成
                NSInteger nowtime=[self.redPacketDetailInfo.createTime integerValue]/1000;
                NSInteger done=[self.redPacketDetailInfo.doneTime integerValue]/1000;
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@个红包，%@被抢完",self.redPacketDetailInfo.count,[self getRedAllGrabTime:done-nowtime]];
                }else{
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@ red packet，robbed in %@",self.redPacketDetailInfo.count,[self getRedAllGrabTime:done-nowtime]];
                }
                
            }else if (self.redPacketDetailInfo.rejectTime){//返回过期时间就是已经过期了
                //该红包已过期，已领取x/x个，共xx/xx元（未领取已过期）
                //                self.receiveStatesLabel.text=[NSString stringWithFormat:@"该红包已过期，已领取%@/1个",redPacketDetailInfo.];
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"已领取%@/%@个",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }else{
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@/%@ have been received",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }
                
            }else{//红包金额x元，等待对方领取（未领取）
                if (BaseSettingManager.isChinaLanguages) {
                    receiveStatesLabelStr=[NSString stringWithFormat:@"已领取%@/%@个",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }else{
                    receiveStatesLabelStr=[NSString stringWithFormat:@"%@/%@ have been received",redPacketDetailMemberListInfo.totalElements,self.redPacketDetailInfo.count];
                }
               
            }
        }
        self.receiveStatesLabel.text=receiveStatesLabelStr;
    }
    
    
}
-(void)setUpview{
    self.backgroundColor=  UIColorViewBgColor;
    [self addSubview:self.topImageView];
    CGFloat defautMargin=isIPhoneX?25:0;
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(100+defautMargin));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topImageView.mas_bottom).offset(30);
        make.width.equalTo(@100);
    }];
    
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.height.equalTo(@25);
    }];
    
    [self addSubview:self.rightNameImageView];
    [self.rightNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@18);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
    }];
    [self addSubview:self.blessingLabel];
    [self.blessingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.blessingLabel.mas_bottom).offset(25);
    }];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
    }];
    [self addSubview:self.rightArrowImageView];
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsLabel.mas_right);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.tipsLabel.mas_centerY);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-40);
    }];
    
    [self addSubview:self.receiveStatesLabel];
    [self.receiveStatesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.height.equalTo(@40);
    }];
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red_details_bg"]];
    }
    return _topImageView;
}
-(DZIconImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[DZIconImageView alloc]initWithImage:[UIImage imageNamed:BoyDefault]];
        [_headImageView layerWithCornerRadius:25/2.0 borderWidth:0 borderColor:nil];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel centerLabelWithTitle:@"" font:20.0 color:UIColorThemeMainTitleColor];
        _nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
-(UIImageView *)rightNameImageView{
    if (!_rightNameImageView) {
        _rightNameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red_pin"]];
        _rightNameImageView.hidden=YES;
    }
    return _rightNameImageView;
}

-(UILabel *)blessingLabel{
    if (!_blessingLabel) {
        _blessingLabel = [UILabel centerLabelWithTitle:@"" font:15.0 color:UIColorThemeMainSubTitleColor];
    }
    return _blessingLabel;
}

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel centerLabelWithTitle:@"" font:50 color:UIColorMake(191,157,94)];
        _moneyLabel.hidden=YES;
    }
    return _moneyLabel;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        
        _tipsLabel = [UILabel centerLabelWithTitle:@"Transferred to wallet".icanlocalized font:15 color:UIColorMake(205,175,113)];
        _tipsLabel.hidden=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToWallete)];
        [_tipsLabel addGestureRecognizer:tap];
        _tipsLabel.userInteractionEnabled=YES;
    }
    return _tipsLabel;
}

-(void)pushToWallete{
    IcanWalletPageViewController * walletVc = [[IcanWalletPageViewController alloc]init];
    walletVc.hidesBottomBarWhenPushed = YES;
    [[AppDelegate shared]pushViewController:walletVc animated:YES];
}

-(UIImageView *)rightArrowImageView{
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_red_details"]];
        _rightArrowImageView.hidden=YES;
    }
    return _rightArrowImageView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColor10PxClearanceBgColor;
    }
    return _lineView;
}
-(UILabel *)receiveStatesLabel{
    if (!_receiveStatesLabel) {
        _receiveStatesLabel=[UILabel leftLabelWithTitle:@"" font:14 color:UIColorThemeMainSubTitleColor];
        _receiveStatesLabel.numberOfLines=0;
    }
    return _receiveStatesLabel;
}
-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView=[[UIView alloc]init];
        _bottomLineView.backgroundColor=UIColorSeparatorColor;
    }
    return _bottomLineView;
}
@end

//
//  RedEnVelopeButton.m
//  CaiHongApp
//
//  Created by lidazhi on 2019/1/4.
//  Copyright © 2019 DW. All rights reserved.
//

#import "ChatTransferButton.h"
#import "ChatModel.h"
@interface ChatTransferButton()
@property (nonatomic,strong) UILabel * remarkLabel;
@property (nonatomic,strong) UILabel * tipsLabel;
@property (nonatomic,strong) UILabel * redEnvelopeLabel;
@property (nonatomic,strong) UIImageView * tipsImageView;
@property(nonatomic,strong) UILabel *timeLabelDown;
@end

@implementation ChatTransferButton
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpView];
}
-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel = chatModel;
    TranferMessageInfo*info = [TranferMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
    if (info.currencyCode) {
        if([info.currencyCode  isEqual: @"USDT"]){
            NSString *usdt = @"₮";
            NSNumberFormatter *convertedVal = [[NSNumberFormatter alloc] init];
            convertedVal.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *myNumber = [convertedVal numberFromString:info.money];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 20;
            NSString *result = [formatter stringFromNumber:myNumber];
            self.remarkLabel.text = [NSString stringWithFormat:@"%@ %@",usdt,result];
        }else{
            self.remarkLabel.text = [NSString stringWithFormat:@"%@%.2f",[[UserInfoManager sharedManager]getSymbol:info.currencyCode],[info.money floatValue]];
        }
    }else{
        self.remarkLabel.text = [NSString stringWithFormat:@"￥%.2f",[info.money floatValue]];
    }
    
    self.redEnvelopeLabel.text = NSLocalizedString(@"Transfer", 转账);
    self.tipsImageView.image = UIImageMake(@"icon_chat_transfer_tips");
    self.tipsLabel.text = info.content;
    NSDate*date=[GetTime dateConvertFromTimeStamp:self.chatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@73);
        make.right.equalTo(@-5);
    }];
}

-(void)setUpView{
    [self addSubview:self.tipsImageView];
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(@12);
        make.top.equalTo(@15);
        make.width.equalTo(@34);
        
    }];
    [self addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.top.equalTo(@15);
        make.right.equalTo(@-20);
    }];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(3);
        make.left.equalTo(@60);
        make.right.equalTo(@-20);
    }];
    [self addSubview:self.redEnvelopeLabel];
    [self.redEnvelopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@-5);
    }];
}

-(UIImageView *)tipsImageView{
    if (!_tipsImageView) {
        _tipsImageView=[[UIImageView alloc]init];
       
    }
    return _tipsImageView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[[UILabel alloc]init];
        _tipsLabel.textColor=[UIColor whiteColor];
        _tipsLabel.font=[UIFont systemFontOfSize:14];
        
    }
    return _tipsLabel;
}
-(UILabel *)redEnvelopeLabel{
    if (!_redEnvelopeLabel) {
        _redEnvelopeLabel=[[UILabel alloc]init];
        _redEnvelopeLabel.textColor=UIColorMake(133, 133, 133);
        _redEnvelopeLabel.font=[UIFont systemFontOfSize:12];
        
    }
    return _redEnvelopeLabel;
}
-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel=[[UILabel alloc]init];
        _remarkLabel.textColor=[UIColor whiteColor];
        _remarkLabel.font=[UIFont systemFontOfSize:16];
        
    }
    return _remarkLabel;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}
@end

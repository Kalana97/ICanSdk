//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 29/10/2019
 - File name:  ChatWithdrawTableViewCell.m
 - Description:
 - Function List:
 */


#import "ChatWithdrawTableViewCell.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "ChatModel.h"
@interface ChatWithdrawTableViewCell ()
@property (nonatomic,strong) UILabel * cmdLabel;
@property (nonatomic,strong) UIView  * bgView;
@property(nonatomic, strong) UIButton *tapButton;
@end
@implementation ChatWithdrawTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.contentView.backgroundColor = UIColorViewBgColor;
    }
    return self;
}
-(void)setUpUI{
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.height.equalTo(@25);
    }];
    [self.bgView addSubview: self.cmdLabel];
    [self.cmdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(2);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-2);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        
    }];
    [self.bgView addSubview:self.tapButton];
    [self.tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(2);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-2);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
}
-(void)setChatModel:(ChatModel *)chatModel{
    
    NSMutableAttributedString*attri;
    if (chatModel.isOutGoing) {
        long maxTime = 0;
        if([chatModel.chatType isEqualToString:UserChat]) {
            maxTime = 259200;
        }else if ([chatModel.chatType isEqualToString:GroupChat]) {
            maxTime = 180;
        }
        //只有3个小时内的可以撤回
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && [chatModel.messageType containsString: TextMessageType]) {
            self.tapButton.enabled=YES;
            NSString*string1=NSLocalizedString(@"YouHaveWithdrawnAMessage",你撤回了一条消息);
            NSString*string2=@"Re-Edit".icanlocalized;
            NSString * string=[NSString stringWithFormat:@"%@ %@",string1,string2];
            attri=[[NSMutableAttributedString alloc]initWithString:string];
            NSRange rang1=[string rangeOfString:string2];
            [attri addAttributes:@{NSForegroundColorAttributeName:UIColorThemeMainColor} range:rang1];
            self.cmdLabel.attributedText=attri;
            [self.cmdLabel yb_addAttributeTapActionWithStrings:@[string] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
                if (self.tapBlock) {
                    self.tapBlock();
                }
            }];
            
        }else{
            self.tapButton.enabled=NO;
            attri=[[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"YouHaveWithdrawnAMessage",你撤回了一条消息)];
            self.cmdLabel.attributedText=attri;
        }
        
    }else{
        self.tapButton.enabled=NO;
        attri=[[NSMutableAttributedString alloc]initWithString:chatModel.showMessage];
        self.cmdLabel.attributedText=attri;
    }
    CGFloat width=[NSString widthWithAttrbuteString:attri height:20 cgflotTextFont:13.5];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width+23));
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@(23));
    }];
    
}
-(UIButton *)tapButton{
    if (!_tapButton) {
        _tapButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(tapAction)];
    }
    return _tapButton;
}
-(void)tapAction{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
-(UILabel *)cmdLabel{
    if (!_cmdLabel) {
        _cmdLabel=[UILabel leftLabelWithTitle:@"" font:13.5 color:[UIColor whiteColor]];
        _cmdLabel.numberOfLines=0;
        //        _cmdLabel.userInteractionEnabled=YES;
    }
    return _cmdLabel;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor=[UIColor lightGrayColor];
        ViewRadius(_bgView, 5);
    }
    return _bgView;
}


@end

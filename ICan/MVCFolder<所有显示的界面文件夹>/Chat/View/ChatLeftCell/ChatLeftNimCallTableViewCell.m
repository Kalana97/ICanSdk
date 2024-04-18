//
//  ChatLeftNimCallTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftNimCallTableViewCell.h"
@interface ChatLeftNimCallTableViewCell()
@property(nonatomic, strong) UIView *nimBgView;
@property(nonatomic, strong) UIImageView *nimBgImgView;
@property(nonatomic, strong) UIStackView *nimBodyHorizontalStackView;
@property(nonatomic, strong) UIImageView *callTypeImgView;
@property(nonatomic, strong) UILabel *callLab;
@property(nonatomic,strong)  UILabel *timeLabelDown;
@end
@implementation ChatLeftNimCallTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setChatCallMessageType];
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.nimBgView addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nimBgView.mas_right).offset(-5);
        make.top.equalTo(self.nimBgView.mas_top).offset(25);
    }];
}
//设置云信通话的布局显示
-(void)setChatCallMessageType{
    self.callLab.text = self.currentChatModel.showMessage;
    NSString*stateImageStr;
    ChatCallMessageInfo*info=[ChatCallMessageInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    if ([info.callType isEqualToString:@"VOICE"]) {
        stateImageStr=@"tips_audio_other";
    }else{
        stateImageStr=@"tips_video_other";
    }
    
    self.callTypeImgView.image = [UIImage imageNamed:stateImageStr];
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVerticalStackView addArrangedSubview:self.nimBgView];
    [self.nimBgView addSubview:self.nimBgImgView];
    [self.nimBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.nimBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
    }];
    [self.nimBgView addSubview:self.nimBodyHorizontalStackView];
    [self.nimBodyHorizontalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-40);
        make.top.bottom.equalTo(@0);
    }];
    [self.nimBodyHorizontalStackView addArrangedSubview:self.callTypeImgView];
    [self.callTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
    }];
    [self.nimBodyHorizontalStackView addArrangedSubview:self.callLab];
    
    
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    self.convertRectView = self.nimBgImgView;
    [super longPress:longPressGes];
}
-(UIView *)nimBgView{
    if (!_nimBgView) {
        _nimBgView = [[UIView alloc]init];
        _nimBgView.backgroundColor = UIColor.clearColor;
        _nimBgView.layer.cornerRadius = 10;
        _nimBgView.clipsToBounds = YES;
    }
    return _nimBgView;
}
-(UIImageView *)nimBgImgView{
    if (!_nimBgImgView) {
        _nimBgImgView = [[UIImageView alloc]initWithImage:UIImageMake(@"chat_message_content_other_bg")];
        //给语音通话的view添加手势
        UILongPressGestureRecognizer *nimLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        _nimBgImgView.userInteractionEnabled=YES;
        _nimBgImgView.layer.cornerRadius = 10;
        _nimBgImgView.clipsToBounds = YES;
        nimLongGesture.minimumPressDuration=0.5;
        [_nimBgImgView addGestureRecognizer:nimLongGesture];
        UITapGestureRecognizer *nimTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMessageCell)];
        [_nimBgImgView addGestureRecognizer:nimTap];
    }
    return _nimBgImgView;
}
-(UIStackView *)nimBodyHorizontalStackView{
    if (!_nimBodyHorizontalStackView) {
        _nimBodyHorizontalStackView = [[UIStackView alloc]init];
        _nimBodyHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _nimBodyHorizontalStackView.alignment = UIStackViewAlignmentCenter;
        _nimBodyHorizontalStackView.spacing = 10;
        _nimBodyHorizontalStackView.userInteractionEnabled = NO;
        
    }
    return _nimBodyHorizontalStackView;
}
-(UIImageView *)callTypeImgView{
    if (!_callTypeImgView) {
        _callTypeImgView = [[UIImageView alloc]initWithImage:UIImageMake(@"tips_audio_other")];
    }
    return _callTypeImgView;
}
-(UILabel *)callLab{
    if (!_callLab) {
        _callLab = [UILabel leftLabelWithTitle:nil font:15 color:UIColor252730Color];
    }
    return _callLab;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}
@end

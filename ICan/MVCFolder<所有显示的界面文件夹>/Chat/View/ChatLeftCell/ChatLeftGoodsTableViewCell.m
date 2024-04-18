//
//  ChatLeftGoodsTableViewCell.m
//  ICan
//
//  Created by dzl on 25/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftGoodsTableViewCell.h"
@interface ChatLeftGoodsTableViewCell()
@property(nonatomic, strong)  UIView *goodsBgContentView;
@property(nonatomic, strong)  UIStackView *goodsVerticalStackView;
@property(nonatomic, strong)  UIStackView *goodsHorizontalStackView;
@property(nonatomic, strong)  UIImageView *shopIconImageView;
@property(nonatomic, strong)  UILabel *shopNameLabel;
@property(nonatomic, strong)  UILabel *goodsLabel;
@property(nonatomic, strong)  UIImageView *goodsImageView;
@end
@implementation ChatLeftGoodsTableViewCell

-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setGoodMessageType];
}
-(void)setGoodMessageType{
    ChatOtherUrlInfo*goodsInfo=[ChatOtherUrlInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.appLogo] placeholderImage:nil];
    self.shopNameLabel.text=goodsInfo.appName;
    self.goodsLabel.text=goodsInfo.content;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.imageUrl] placeholderImage:nil];
}
-(void)setUpUI{
    [super setUpUI];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVerticalStackView addArrangedSubview:self.goodsBgContentView];
    [self.goodsBgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@160);
    }];
    [self.goodsBgContentView addSubview:self.goodsVerticalStackView];
    [self.goodsVerticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@7);
        make.bottom.right.equalTo(@-7);
    }];
    [self.goodsVerticalStackView addArrangedSubview:self.goodsHorizontalStackView];
    [self.goodsHorizontalStackView addArrangedSubview:self.shopIconImageView];
    [self.shopIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
    }];
    [self.goodsHorizontalStackView addArrangedSubview:self.shopNameLabel];
    [self.goodsVerticalStackView addArrangedSubview:self.goodsLabel];
    [self.goodsVerticalStackView addArrangedSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.width.equalTo(@145);
    }];
    //分享的是商品
    UITapGestureRecognizer*shopTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMessageCell)];
    [self.goodsBgContentView addGestureRecognizer:shopTap];
    UILongPressGestureRecognizer *shopLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.goodsBgContentView addGestureRecognizer:shopLongGesture];
    [self.goodsBgContentView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    self.goodsBgContentView.backgroundColor = UIColorChatLeftBgColor;
    [self.shopIconImageView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView = self.goodsBgContentView;
        [super longPress:longPressGes];
    }
}
-(void)clickMessageCell{
    ChatOtherUrlInfo*goodsInfo=[ChatOtherUrlInfo mj_objectWithKeyValues:self.currentChatModel.messageContent];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:goodsInfo.link]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:goodsInfo.link] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}
-(UIView *)goodsBgContentView{
    if (!_goodsBgContentView) {
        _goodsBgContentView = [[UIView alloc]init];
        _goodsBgContentView.backgroundColor = UIColor.clearColor;
    }
    return _goodsBgContentView;
}
-(UIStackView *)goodsVerticalStackView{
    if (!_goodsVerticalStackView) {
        _goodsVerticalStackView = [[UIStackView alloc]init];
        _goodsVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _goodsVerticalStackView.alignment = UIStackViewAlignmentLeading;
    }
    return _goodsVerticalStackView;
}
-(UIStackView *)goodsHorizontalStackView{
    if (!_goodsHorizontalStackView) {
        _goodsHorizontalStackView = [[UIStackView alloc]init];
        _goodsHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _goodsHorizontalStackView.alignment = UIStackViewAlignmentFill;
        _goodsHorizontalStackView.spacing = 5;
    }
    return _goodsHorizontalStackView;
}
-(UIImageView *)shopIconImageView{
    if (!_shopIconImageView) {
        _shopIconImageView = [[UIImageView alloc]init];
        _shopIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shopIconImageView;
}
-(UILabel *)shopNameLabel{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel leftLabelWithTitle:nil font:14 color:UIColor252730Color];
    }
    return _shopNameLabel;
}
-(UIImageView *)goodsImageView{
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}
-(UILabel *)goodsLabel{
    if (!_goodsLabel) {
        _goodsLabel = [UILabel leftLabelWithTitle:nil font:15 color:UIColor252730Color];
        _goodsLabel.numberOfLines =2;
    }
    return _goodsLabel;
}
@end

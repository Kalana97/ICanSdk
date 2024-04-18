//
//  PostMessageChoseFriendView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "PostMessageChoseFriendView.h"

@interface PostMessageChoseFriendView ()

@end

@implementation PostMessageChoseFriendView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
    }
    
    return self;
}

-(void)setUpView{
    ViewBorder(self, UIColor153Color, 1);
    ViewRadius(self, 5);
    [self addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@2);
        make.bottom.equalTo(@-2);
        make.right.equalTo(@-2);
        make.left.equalTo(@2);
        
    }];
    NSAttributedString*nullString= [[NSAttributedString alloc]initWithString:@" "];
    NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithAttributedString:nullString];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    textAttachment.image = [UIImage imageNamed:@"icon_timeline_post_setting_open"];
    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
    textAttachment.bounds = CGRectMake(0, 0, 11 , 11);
    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [att appendAttributedString:imageStr];
    [att appendAttributedString:nullString];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"Public".icanlocalized]];
    NSTextAttachment *righttextAttachment = [[NSTextAttachment alloc] init];
    //给附件添加图片
    righttextAttachment.image = [UIImage imageNamed:@"icon_posttimeline_arrow_down"];
    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
    righttextAttachment.bounds = CGRectMake(0,0, 8 , 8);
    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
    NSAttributedString *rightimageStr = [NSAttributedString attributedStringWithAttachment:righttextAttachment];
    [att appendAttributedString:nullString];
    [att appendAttributedString:rightimageStr];
    [att appendAttributedString:nullString];
    self.centerLabel.attributedText=att;
}

-(UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [UILabel leftLabelWithTitle:@"Public".icanlocalized font:12 color:UIColor252730Color];
        
    }
    
    return _centerLabel;
}



@end

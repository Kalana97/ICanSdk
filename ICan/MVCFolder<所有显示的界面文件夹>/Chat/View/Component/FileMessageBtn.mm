//
//  FileMessageBtn.m
//  CaiHongApp
//
//  Created by young on 6/6/2019.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import "FileMessageBtn.h"
#import "ChatModel.h"
@interface FileMessageBtn ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *iconImageView;

@end

@implementation FileMessageBtn
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
    [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    return self;
}


-(void)initUI{
    
    [self addSubview:self.nameLabel];
    self.backgroundColor=UIColorBg243Color;
    [self addSubview:self.iconImageView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.right.equalTo(@-10);
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel leftLabelWithTitle:nil font:15 color:[UIColor blackColor]];
        _nameLabel.numberOfLines=2;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLabel;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(void)setChatModel:(ChatModel *)chatModel{
    if (chatModel) {
       if (chatModel.isOutGoing) {
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@80);
                make.top.equalTo(@10);
                make.right.equalTo(@-15);
                
            }];
            
            [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(@10);
                make.width.equalTo(@60);
                make.height.equalTo(@60);
            }];
        }else{
            [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.top.equalTo(@10);
                make.right.equalTo(@-75);
                
            }];
            [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(@(KFileButtonWidth-60-10));
                make.width.equalTo(@60);
                make.height.equalTo(@60);
            }];
        }
        NSString * fileName =chatModel.showFileName;// 新方法
        self.nameLabel.text = fileName;
        NSString * suffixName = fileName.pathExtension;
        //根据后缀名设置文件的icon  file_pdf
        if ([suffixName isEqualToString:@"pdf"]) {
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_pdf"]];
        }else if([suffixName isEqualToString:@"ppt"]||[suffixName isEqualToString:@"pptx"]){
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_ppt"]];
        }else if ([suffixName isEqualToString:@"txt"]||[suffixName isEqualToString:@"rtf"]){
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_tst"]];
        }else if ([suffixName isEqualToString:@"docx"]){
             [_iconImageView setImage:[UIImage imageNamed:@"chat_file_word"]];
        }else if ([suffixName isEqualToString:@"xls"]||[suffixName isEqualToString:@"xlsx"]){
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_xle"]];
        }else if ([suffixName isEqualToString:@"zip"]||[suffixName isEqualToString:@"rar"]||[suffixName isEqualToString:@"gz"]||[suffixName isEqualToString:@"7z"]){
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_zip"]];
        }else{
            [_iconImageView setImage:[UIImage imageNamed:@"chat_file_unknown"]];
        }
    }
}



@end

//
//  MyCollectionTimelinesTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/24.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "MyCollectionTimelinesImageTableViewCell.h"
@interface MyCollectionTimelinesImageTableViewCell ()

@property(weak, nonatomic) IBOutlet UIView *contentHeadBgView;
@property(nonatomic,weak)  IBOutlet UIImageView * headImageView;
@property(nonatomic,weak)  IBOutlet UILabel * nameLabel;
@property(nonatomic,weak)  IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)  IBOutlet UILabel * addressLabel;
@property(nonatomic,weak)  IBOutlet UILabel *contentLabel;
@property(nonatomic,weak)  IBOutlet UIImageView * playImageView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headImageWidth;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headImageHeight;
@property (weak, nonatomic) IBOutlet UIView *line10pxView;

@end

@implementation MyCollectionTimelinesImageTableViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.hidden = YES;
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor = UIColorThemeMainSubTitleColor;
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.addressLabel.textColor = UIColorThemeMainSubTitleColor;
    self.contentLabel.textColor = UIColorThemeMainTitleColor;
    self.line10pxView.backgroundColor = UIColor10PxClearanceBgColor;
    self.lineView.backgroundColor = UIColorSeparatorColor;

}
-(void)setResponse:(CollectionListDetailResponse *)response{
    _response = response;
    self.timeLabel.text =  [GetTime convertDateWithString:[NSString stringWithFormat:@"%lu",response.createTime] dateFormmate:@"yyyy-MM-dd HH:mm"];;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:response.imageUrl]];
    [self.nameLabel setAttributedText:response.nameLabelText];
    self.contentLabel.attributedText =response.contentLabelText;
    self.nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    self.contentLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    PoiInfo * poi = response.poi;
    self.addressLabel.text = [NSString stringWithFormat:@"%@",poi.name];
    if (response.videoUrl) {
        self.playImageView.hidden = NO;
    }else{
        self.playImageView.hidden = YES;
    }
    self.playImageView.hidden = YES;
    self.contentHeadBgView.hidden = NO;
    self.contentLabel.hidden = NO;
    self.addressLabel.hidden = YES;
    self.headImageWidth.constant = 50;
    self.headImageHeight.constant = 50;
    if ([response.favoriteType isEqualToString:@"TimeLine"]) {
        self.headImageWidth.constant = 90;
        self.headImageHeight.constant = 75;
        self.playImageView.hidden = !response.videoUrl;
        self.addressLabel.hidden = !response.poi;
    }else if ([response.favoriteType isEqualToString:@"Txt"]) {
        //只有文字
        self.contentHeadBgView.hidden = YES;
        self.contentLabel.hidden = NO;
        
    }else if ([response.favoriteType isEqualToString:@"Video"]||[response.favoriteType isEqualToString:@"Image"]){
        self.contentLabel.hidden = YES;
        
    }else if ([response.favoriteType isEqualToString:@"Voice"]){
        
        self.contentLabel.text =@"chatView.function.voice".icanlocalized;
        [self.headImageView setImage:[UIImage imageNamed:@"icon_mine_collect_voice"]];
        
    }else if ([response.favoriteType isEqualToString:@"File"]){
       
        self.contentLabel.text =response.content;
        [self.headImageView setImage:[UIImage imageNamed:@"icon_mine_collet_file"]];
        NSString * suffixName = response.content.pathExtension;
        //根据后缀名设置文件的icon  file_pdf
        if ([suffixName isEqualToString:@"pdf"]) {
            [self.headImageView setImage:[UIImage imageNamed:@"chat_file_pdf"]];
        }else if([suffixName isEqualToString:@"ppt"]||[suffixName isEqualToString:@"pptx"]){
            [self.headImageView setImage:[UIImage imageNamed:@"chat_file_ppt"]];
        }else if ([suffixName isEqualToString:@"txt"]||[suffixName isEqualToString:@"rtf"]){
            [self.headImageView setImage:[UIImage imageNamed:@"chat_file_tst"]];
        }else if ([suffixName isEqualToString:@"docx"]){
             [self.headImageView setImage:[UIImage imageNamed:@"chat_file_word"]];
        }else if ([suffixName isEqualToString:@"xls"]||[suffixName isEqualToString:@"xlsx"]){
            self.headImageView.image = UIImageMake(@"chat_file_xle");
        }else if ([suffixName isEqualToString:@"zip"]||[suffixName isEqualToString:@"rar"]||[suffixName isEqualToString:@"gz"]||[suffixName isEqualToString:@"7z"]){

            [self.headImageView setImage:[UIImage imageNamed:@"chat_file_zip"]];
        }else{
            [self.headImageView setImage:[UIImage imageNamed:@"chat_file_unknown"]];
        }
        
        
    }else if ([response.favoriteType isEqualToString:@"UserCard"]){
        self.contentLabel.text =@"chatView.function.contactCard".icanlocalized;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:response.userCardHeadImgUrl] placeholderImage:[response.gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
        
    }else if ([response.favoriteType isEqualToString:@"POI"]){
        self.addressLabel.hidden = YES;
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",response.poi.address,response.poi.name];
        [self.headImageView setImage:[UIImage imageNamed:@"icon_mine_collet_map"]];
    }
    
}
-(IBAction)tapAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showHjcActionSheetWith:)]) {
        [self.delegate showHjcActionSheetWith:self.response];
    }
    
}

@end

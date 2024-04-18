//
//  ChatLeftFileTableViewCell.m
//  ICan
//
//  Created by dzl on 24/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftFileTableViewCell.h"
#import "ChatViewHandleTool.h"
#import "FileMessageBtn.h"
#import "ReactionBar.h"
@interface ChatLeftFileTableViewCell()
@property(nonatomic, strong) UIView *fileBgView;
@property(nonatomic, strong) FileMessageBtn *fileBtn;
@property(nonatomic, strong) UILabel *downloadLab;
@property(nonatomic,strong)  UILabel *timeLabelDown;
@property(nonatomic, strong) UIView *reactionView;
@property(nonatomic, strong) ReactionBar *reactionBar;
@end
@implementation ChatLeftFileTableViewCell

-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    [super setcurrentChatModel:currentChatModel isShowName:isShowName isGroup:isGroup isShowTime:isShowTime];
    [self setFileMessageType];
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self.fileBgView addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fileBgView.mas_right).offset(-10);
        make.top.equalTo(self.fileBgView.mas_top).offset(92);
    }];
    [self.fileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@110);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)setFileMessageType{
    self.fileBtn.chatModel = self.currentChatModel;
    if (self.currentChatModel.totalUnitCount>1024*1024) {
        self.downloadLab.text=[NSString stringWithFormat:@"%.1fMB",self.currentChatModel.totalUnitCount/1024.0/1024.0];
    }else{
        self.downloadLab.text=[NSString stringWithFormat:@"%.1fKB",self.currentChatModel.totalUnitCount/1024.0];
    }
    [self calculateFileDownloadTipsLabel];
}
//计算收到的文件进度
-(void)calculateFileDownloadTipsLabel{
    //大于1024*1024 单位是MB
    if (self.currentChatModel.fileCacheName) {
        if (self.currentChatModel.totalUnitCount>1024*1024) {
            self.downloadLab.text=[NSString stringWithFormat:@"%.1fMB",self.currentChatModel.totalUnitCount/1024.0/1024.0];
        }else{
            self.downloadLab.text=[NSString stringWithFormat:@"%.1fKB",self.currentChatModel.totalUnitCount/1024.0];
        }
    }else{
        if (self.currentChatModel.totalUnitCount>1024*1024) {
            self.downloadLab.text=[NSString stringWithFormat:@"%.1fMB/%.1fMB",self.currentChatModel.completedUnitCount/1024.0/1024.0,self.currentChatModel.totalUnitCount/1024.0/1024.0];
        }else{
            self.downloadLab.text=[NSString stringWithFormat:@"%.1fKB/%.1fKB",self.currentChatModel.completedUnitCount/1024.0,self.currentChatModel.totalUnitCount/1024.0];
        }
    }
}
-(void)setUpUI{
    [super setUpUI];
    [self.contentVerticalStackView addArrangedSubview:self.fileBgView];
    [self.fileBgView addSubview:self.fileBtn];
    [self.fileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.width.equalTo(@(KFileButtonWidth));
        make.height.equalTo(@80);
    }];
    [self.fileBgView addSubview:self.downloadLab];
    [self.downloadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-22);
        make.left.equalTo(@18);
    }];
    [self.fileBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(self.contentVerticalStackView.mas_bottom).offset(15);
    }];
}
-(UIView *)fileBgView{
    if (!_fileBgView) {
        _fileBgView = [[UIView alloc]init];
    }
    return _fileBgView;
}
-(FileMessageBtn *)fileBtn{
    if (!_fileBtn) {
        _fileBtn = [[FileMessageBtn alloc]init];
        
        [_fileBtn addTarget:self action:@selector(clickMessageCell) forControlEvents:(UIControlEventTouchUpInside)];
        UILongPressGestureRecognizer *fileLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_fileBtn addGestureRecognizer:fileLongGesture];
    }
    return _fileBtn;
}
-(UILabel *)downloadLab{
    if (!_downloadLab) {
        _downloadLab = [UILabel leftLabelWithTitle:nil font:12 color:UIColor252730Color];
    }
    return _downloadLab;
}
-(void)clickMessageCell{
    @weakify(self);
    [[ChatViewHandleTool shareManager]chatViewHandleShowFileWithChatModel:self.currentChatModel container:self.fileContainerView downloadProgress:^(ChatModel * _Nonnull model) {
        @strongify(self);
        self.currentChatModel = model;
        [self calculateFileDownloadTipsLabel];
    } success:^(ChatModel * _Nonnull model) {
        @strongify(self);
        self.currentChatModel = model;
        [self calculateFileDownloadTipsLabel];
    } failure:^(NSError * _Nonnull) {
        
    }];
    [super clickMessageCell];
}
-(void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if(self.longpressStatus){
        self.convertRectView = self.fileBtn;
        [super longPress:longPressGes];
    }
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}

- (UIView *)reactionView{
    if (!_reactionView) {
        _reactionView = [[UIView alloc]init];
    }
    return _reactionView;
}

-(ReactionBar *)reactionBar{
    if(!_reactionBar){
        _reactionBar = [[ReactionBar alloc] init];
        _reactionBar.backgroundColor = UIColorMake(243, 243, 243);
    }
    return _reactionBar;
}
@end

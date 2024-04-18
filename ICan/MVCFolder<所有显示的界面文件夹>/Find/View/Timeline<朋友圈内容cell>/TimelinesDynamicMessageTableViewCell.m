//
//  TimelinesDynamicMessageTableViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-09-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "TimelinesDynamicMessageTableViewCell.h"
#import "TimelinesDynamicMessageDataViewCell.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif
@interface TimelinesDynamicMessageTableViewCell ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@end

@implementation TimelinesDynamicMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView layerWithCornerRadius:50/2 borderWidth:0 borderColor:nil];
    [self.headerImg layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.webView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.headerImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView registNibWithNibName:KTimelinesDynamicMessageDataViewCell];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.webView.UIDelegate = self;
    [self.firstLabelAllButton setTitle:@"SeeMore".icanlocalized forState:UIControlStateNormal];
    UITapGestureRecognizer * rightImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAction)];
    [self.rightImageView addGestureRecognizer:rightImageTap];
    UITapGestureRecognizer * headImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.headImageView addGestureRecognizer:headImageTap];
    UITapGestureRecognizer * followTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followAction)];
    [self.followLabel addGestureRecognizer:followTap];
    self.followLabel.text = @"Follow";
}

-(void)setListRespon:(TimeLineDynamicMessage *)listRespon{
    _listRespon = listRespon;
    self.nameLabel.text = listRespon.sender;
    [self.headImageView sd_setImageWithURL:[[NSURL alloc]initWithString:listRespon.senderImgURL] placeholderImage:UIImageMake(@"thumbnail_default_placeholder")];
    self.timeLabel.text = [GetTime timelinesTime:listRespon.showTime];
    self.webViewContainer.hidden = YES;
    if(listRespon.messageType == 1){
        self.webView.hidden = YES;
        if(listRespon.headerImgURL == nil){
            self.headerImgView.hidden = YES;
        }else{
            self.headerImgView.hidden = NO;
            [self.headerImg sd_setImageWithURL:[[NSURL alloc]initWithString:listRespon.headerImgURL] placeholderImage:UIImageMake(@"thumbnail_default_placeholder")];
            self.titleLabel.text = listRespon.title;
        }
        if(listRespon.messageData == nil){
            self.firstLabelBgView.hidden = YES;
            self.firstAllButtonView.hidden = YES;
        }else{
            self.firstLabelBgView.hidden = NO;
            self.firstAllButtonView.hidden = YES;
            self.firstLabel.text = listRespon.messageData;
        }
    }else if(listRespon.messageType == 2){
        self.headerImgView.hidden = YES;
        self.firstLabelBgView.hidden = YES;
        self.firstAllButtonView.hidden = YES;
        if(listRespon.messageData != nil){
            self.webView.hidden = NO;
            self.webViewContainer.hidden = NO;
            self.webView.contentMode = UIViewContentModeScaleAspectFit;
            [self.webView loadHTMLString:listRespon.messageData baseURL:nil];
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self.webView.scrollView.height));
            }];
            self.webView.scrollView.scrollEnabled = NO;
        }
    }
    if(listRespon.dataList.count > 0){
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        self.tableViewHeight.constant = self.tableView.contentSize.height;
    }else{
        self.tableView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listRespon.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TimelinesDynamicMessageDataViewCell *dataListCell = [tableView dequeueReusableCellWithIdentifier:KTimelinesDynamicMessageDataViewCell];
    dataListCell.dataList = self.listRespon.dataList[indexPath.row];
    return dataListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.listRespon.dataList[indexPath.row].onclickFunction isEqualToString:@"NONE"]){
        return;
    }else if([self.listRespon.dataList[indexPath.row].onclickFunction isEqualToString:@"OPEN_URL"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        View.dynamicMessageURL = self.listRespon.dataList[indexPath.row].onclickData;
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if([self.listRespon.dataList[indexPath.row].onclickFunction isEqualToString:@"OPEN_APP"]){
        return;
    }else if([self.listRespon.dataList[indexPath.row].onclickFunction isEqualToString:@"OPEN_HTML"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        View.htmlString = self.listRespon.dataList[indexPath.row].onclickData;
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)followAction{
    //Need to implement follow
}

-(void)moreAction{
    //Need to implement more action
}

-(void)tapAction{
    //Need to implement head image tap
}

@end

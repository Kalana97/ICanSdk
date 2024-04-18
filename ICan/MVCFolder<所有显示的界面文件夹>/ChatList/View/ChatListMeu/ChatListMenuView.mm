//
//  ChatListMenuView.m
//  CaiHongApp
//
//  Created by lidazhi on 2019/5/7.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import "ChatListMenuView.h"
#import "ChatListMenuCell.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
@interface ChatListMenuView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView * bgImageView;

@property(nonatomic, strong) UIControl *coverControl;

@property(nonatomic, strong) UILabel *unredLabel;
@end

@implementation ChatListMenuView

+(instancetype)showMenuViewWithMenuItems:(NSArray<NSDictionary*>*)menuItems didSelectBlock:(void (^)(NSInteger index))didSelectBlock{
    ChatListMenuView*view=[[ChatListMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.didSelectBlock=didSelectBlock;
    view.menuItems=menuItems;
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:view];
    [view showView];
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
    }
    return self;
}
-(void)setMenuItems:(NSArray<NSDictionary *> *)menuItems{
    _menuItems=menuItems;
    [self setUpView];
}
- (void)showView {
    self.alpha = 0.f;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideView {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}
-(void)showChatListMenuView{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
}
-(void)hiddenChatListMenuView{
    [self removeFromSuperview];
}
-(void)setUpView{
    [self setupTable];
    [self addSubview:self.coverControl];
    [self.coverControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    NSMutableArray*widthItems=[NSMutableArray array];
    for (NSDictionary*dict in self.menuItems) {
        NSString*string=dict[@"title"];
        CGFloat width=[NSString widthForString:string withFont:[UIFont systemFontOfSize:15] height:20];
        [widthItems addObject:[NSNumber numberWithFloat:width]];
    }
    CGFloat maxValue = [[widthItems valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat bgWidth=80+maxValue;
    if (bgWidth<110) {
        bgWidth=110;
    }
    CGFloat height=self.menuItems.count*50+5;
    [self.coverControl addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight-10));
        make.width.equalTo(@(bgWidth));
        make.height.equalTo(@(height));
    }];
    [self.bgImageView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@5);
    }];
}
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_chatList_pop_bg"]];
        _bgImageView.userInteractionEnabled=YES;
    }
    return _bgImageView;
}
-(UIControl *)coverControl{
    if (!_coverControl) {
        _coverControl=[[UIControl alloc]init];
        [_coverControl addTarget:self action:@selector(hiddenChatListMenuView) forControlEvents:UIControlEventTouchUpInside];
        _coverControl.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0);
    }
    return _coverControl;
}
- (void)setupTable {
    
    // 添加table
    UITableView *tableView      = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor   = [UIColor clearColor];
    tableView.delegate          = self;
    tableView.dataSource        = self;
    tableView.scrollEnabled=NO;
    tableView.tableHeaderView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [tableView registNibWithNibName:KChatListMenuCell];
    self.tableView              = tableView;
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListMenuCell*cell=[tableView dequeueReusableCellWithIdentifier:KChatListMenuCell];
    NSDictionary *infoDic = self.menuItems[indexPath.row];
    BOOL hidenLine = NO;
    if (indexPath.row == self.menuItems.count - 1) {
        hidenLine = YES;
    }
    [cell setIconName:infoDic[@"icon"] title:infoDic[@"title"] isShow:hidenLine];
    cell.cirecleLabel.hidden=YES;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KHeightChatListMenuCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideView];
    [self hiddenChatListMenuView];
    if(self.didSelectBlock){
        self.didSelectBlock(indexPath.row);
    }
}
@end

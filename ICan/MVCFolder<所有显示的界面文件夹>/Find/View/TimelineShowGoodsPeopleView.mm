//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 28/4/2020
 - File name:  TimelineShowGoodsPeopleView.m
 - Description:
 - Function List:
 */


#import "TimelineShowGoodsPeopleView.h"
#import "ShowHasReadTableViewCell.h"
#import "FriendDetailViewController.h"
@interface TimelineShowGoodsPeopleHeadView:UIView
@property(nonatomic, strong) UILabel *topLabel;
@end

@implementation TimelineShowGoodsPeopleHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.whiteColor;
        [self addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.bottom.equalTo(@0);
            
        }];
    }
    return self;
}
-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel=[UILabel leftLabelWithTitle:@"" font:13 color:UIColor153Color];
    }
    return _topLabel;
}
@end
@interface TimelineShowGoodsPeopleView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) TimelineShowGoodsPeopleHeadView *headView;
@end
@implementation TimelineShowGoodsPeopleView
-(void)showSurePaymentView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        [window addSubview:self];
        
    });
}
-(void)hiddenSurePaymentView{
    [self removeFromSuperview];
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.backgroundColor = UIColorMakeWithRGBA(83, 83, 83, 0.5);
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSurePaymentView)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@100);
            make.bottom.equalTo(@(-HomeIndicatorHeight));
        }];
    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}
-(TimelineShowGoodsPeopleHeadView *)headView{
    if (!_headView) {
        _headView=[[TimelineShowGoodsPeopleHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _headView;
}
-(void)setGoodsPeopleItems:(NSArray *)goodsPeopleItems{
    _goodsPeopleItems=goodsPeopleItems;
    if (goodsPeopleItems.count>5) {
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    CGFloat tableViewHeight=50*goodsPeopleItems.count+50;
    if (tableViewHeight>ScreenHeight/2.0) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(-HomeIndicatorHeight));
            make.height.equalTo(@(ScreenHeight/2.0));
        }];
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@(-HomeIndicatorHeight));
            make.height.equalTo(@(tableViewHeight));
        }];
    }
    self.headView.topLabel.text=[NSString stringWithFormat:@"%@（%ld）",@"Number of Likes".icanlocalized,goodsPeopleItems.count];
    [self.tableView reloadData];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        [_tableView registNibWithNibName:kShowHasReadTableViewCell];
        _tableView.tableHeaderView =self.headView;
        
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsPeopleItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightShowHasReadTableViewCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowHasReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowHasReadTableViewCell];
    cell.userMessageInfo=self.goodsPeopleItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
    TimelineLoveInfo*info=[self.goodsPeopleItems objectAtIndex:indexPath.row];
    vc.userId=info.ID;
    [self hiddenSurePaymentView];
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
@end

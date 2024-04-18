//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 13/8/2020
- File name:  DYTimelineShowContentView.m
- Description:
- Function List:
*/
        

#import "DYTimelineShowContentView.h"
#import "DYTimelineShowContentTableViewCell.h"
@interface DYTimelineShowContentView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView                *topView;
@property (nonatomic, strong) UILabel               *countLabel;
@property (nonatomic, strong) UIButton              *closeBtn;
@property (nonatomic, strong) UITableView           *tableView;
@end

@implementation DYTimelineShowContentView

- (instancetype)init {
    if (self = [super init]) {
        
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.topView];
//
//        [self addSubview:self.countLabel];
//        [self addSubview:self.closeBtn];
        [self addSubview:self.tableView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];
//
//        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.topView);
//        }];
//
//        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.topView);
//            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 8.0f);
//            make.width.height.mas_equalTo(ADAPTATIONRATIO * 18.0f);
//        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(@10);
            make.bottom.equalTo(@(0));
        }];
        
       
//        self.countLabel.text = [NSString stringWithFormat:@"%zd条评论", self.count];
    }
    return self;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.whiteColor;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        //绘制圆角 要设置的圆角 使用“|”来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //设置大小
        maskLayer.frame = frame;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _topView.layer.mask = maskLayer;
    }
    return _topView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel centerLabelWithTitle:nil font:17 color:UIColor153Color];
    }
    return _countLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_pop_close_white"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(void)hiddenView{
//    !self.hiddenBlock?:self.hiddenBlock();
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registNibWithNibName:kDYTimelineShowContentTableViewCell];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}
-(void)setTimelinesListDetailInfo:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    _timelinesListDetailInfo=timelinesListDetailInfo;
    [self.tableView reloadData];
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYTimelineShowContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kDYTimelineShowContentTableViewCell];
    cell.timelinesListDetailInfo=self.timelinesListDetailInfo;
    return cell;
    
    
}
@end

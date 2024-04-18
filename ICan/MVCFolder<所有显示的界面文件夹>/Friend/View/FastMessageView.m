
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- Editor: Edited  by RSJayasekara on 15/12/2022
- File name:  FastMessageView.m
- Description:
- Function List:
*/
        

#import "FastMessageView.h"
#import "FaseMessageTableViewCell.h"
#import "EditFastMessageViewController.h"

@interface FastMessageView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *headerView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *addTipsLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation FastMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorMake(248, 248, 248);
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@4);
            make.centerX.equalTo(@0);
            make.top.equalTo(@6);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@0);
            make.top.equalTo(@56);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setMsgItems:(NSArray<QuickMessageInfo *> *)msgItems {
    _msgItems = msgItems;
    [self.tableView reloadData];
}

- (UIControl *)headerView {
    if (!_headerView) {
        _headerView = [[UIControl alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 44)];
        _headerView.backgroundColor = UIColorMake(248, 248, 248);
        
        [_headerView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.right.equalTo(@-15);
            make.centerY.equalTo(_headerView.mas_centerY);
        }];
        
        [_headerView addSubview:self.addTipsLabel];
        [self.addTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.equalTo(@15);
        }];
        
        [_headerView addSubview:self.bottomLine];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBtnAction)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(addBtnAction)];
        [_addBtn setBackgroundImage:UIImageMake(@"chat_funtion_more_select") forState:UIControlStateNormal];
        _addBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 25.0);
    }
    return _addBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = UIColorMake(31, 31, 31);
        _cancelBtn.layer.cornerRadius = 2;
    }
    return _cancelBtn;
}

- (UILabel *)addTipsLabel {
    if (!_addTipsLabel) {
        _addTipsLabel = [UILabel leftLabelWithTitle:@"AddQuickSendingContent".icanlocalized font:14 color:UIColorMake(91, 91, 91)];
        _addTipsLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _addTipsLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        _bottomLine.backgroundColor = UIColorMake(240, 240, 240);
    }
    return _bottomLine;
}

- (void)addBtnAction {
    EditFastMessageViewController *vc = [[EditFastMessageViewController alloc]init];
    [[AppDelegate shared]pushViewController:vc animated:YES];
}

- (void)cancelBtnAction {
    [self setHidden:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registNibWithNibName:kFaseMessageTableViewCell];
        [self addSubview:self.headerView];
        self.headerView.layer.zPosition = 100;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 44.0;
    NSString *text = self.msgItems[indexPath.row].value;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize constrainedSize = CGSizeMake(ScreenWidth, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect textRect = [text boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    NSInteger numberOfLines = ceil(CGRectGetHeight(textRect) / font.lineHeight);
    if(numberOfLines > 1) {
        cellHeight = ((numberOfLines + 3) * 15);
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FaseMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFaseMessageTableViewCell];
    QuickMessageInfo *msgInfo = self.msgItems[indexPath.row];
    cell.msgInfo = msgInfo;
    cell.tapBlock = ^{
        self.hidden=YES;
        if (self.sendFastMessageBlock) {
            self.sendFastMessageBlock(msgInfo.value);
        }
    };
    return cell;
}
@end

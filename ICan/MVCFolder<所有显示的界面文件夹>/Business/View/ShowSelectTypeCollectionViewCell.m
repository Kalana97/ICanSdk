//
//  ShowSelectTypeCollectionViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "ShowSelectTypeCollectionViewCell.h"
#import "ShowSelectTypeTableViewCell.h"
#import "FriendListFirstHeaderView.h"
#import "UITableView+SCIndexView.h"
@interface ShowSelectTypeCollectionViewCell()<UITableViewDelegate,UITableViewDataSource,SCIndexViewDelegate>
@property(weak, nonatomic) IBOutlet QMUITextField *searchTextField;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *selectIndexPath;
@property(nonatomic, strong) NSMutableArray *searchItems;
@property(nonatomic, assign) BOOL search;
@property(weak, nonatomic)   IBOutlet UIView *bgContentView;
@property(nonatomic,strong)  NSMutableArray *indexArray;
@property(nonatomic, strong)  NSMutableArray<NSArray*> *letterResultArr;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;
@end

@implementation ShowSelectTypeCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    [self.tableView registNibWithNibName:kShowSelectTypeTableViewCell];
    [self.bgContentView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.searchTextField.placeholder = @"ShowSelectAddressView.seatchTitle".icanlocalized;
    self.searchTextField.placeholderColor = UIColor153Color;
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.tableView.sectionFooterHeight = 0.1;
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}

-(NSMutableArray *)searchItems{
    if (!_searchItems) {
        _searchItems = [NSMutableArray array];
    }
    return _searchItems;
}

-(void)textDidChange{
    if (self.searchTextField.text.length > 0 && !self.searchTextField.markedTextRange) {
        self.search = YES;
        [self.searchItems removeAllObjects];
        NSPredicate *cpredicate;
        if (BaseSettingManager.isChinaLanguages) {
            cpredicate = [NSPredicate predicateWithFormat:@"businessType contains [cd] %@ ",self.searchTextField.text];
        }else{
            cpredicate = [NSPredicate predicateWithFormat:@"businessTypeEn contains [cd] %@ ",self.searchTextField.text];
        }
        self.searchItems = [NSMutableArray arrayWithArray:[self.typeItems filteredArrayUsingPredicate:cpredicate]];
        [self sortObjectsAccordingToInitialWith:self.searchItems];
    }else{
        self.search = NO;
        [self.searchItems removeAllObjects];
        [self.tableView reloadData];
        [self sortObjectsAccordingToInitialWith:self.typeItems];
    }
}

-(void)setTypeItems:(NSArray *)typeItems{
    self.search = NO;
    _typeItems = typeItems;
    [self sortObjectsAccordingToInitialWith:typeItems];
    [self.tableView reloadData];
}

-( void)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    for (BusinessTypeInfo *personModel in arr) {
        NSInteger sectionNumber;
        if (BaseSettingManager.isChinaLanguages) {
            personModel.pinyinName = [personModel.businessType transformToPinyin];
            sectionNumber = [collation sectionForObject:personModel collationStringSelector: @selector(businessType)];
        }else{
            personModel.pinyinName = [personModel.businessTypeEn transformToPinyin];
            sectionNumber = [collation sectionForObject:personModel collationStringSelector: @selector(businessTypeEn)];
        }
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:personModel];
    }
    NSMutableArray *finalArr = [NSMutableArray new];
    NSMutableArray *index = [NSMutableArray array];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    for (NSArray *array in finalArr) {
        BusinessTypeInfo *info = array.firstObject;
        if (BaseSettingManager.isChinaLanguages) {
            [index addObject:[NSString firstCharactorWithString:info.businessType]];
        }else{
            [index addObject:[NSString firstCharactorWithString:info.businessTypeEn]];
        }
    }
    self.letterResultArr = [NSMutableArray arrayWithArray:finalArr];
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSArray *array in self.letterResultArr) {
        NSArray* sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BusinessTypeInfo *info1 = obj1;
            BusinessTypeInfo *info2 = obj2;
            return [info1.pinyinName compare:info2.pinyinName];
        }];
        [newArray addObject:sortArray];
    }
    self.letterResultArr = newArray;
    self.indexArray = [NSMutableArray arrayWithArray:index];
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_indexView.delegate = self;
    [self.tableView reloadData];
}

-(void)indexView:(SCIndexView *)indexView didSelectAtSection:(NSUInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (NSUInteger)sectionOfIndexView:(SCIndexView *)indexView tableViewDidScroll:(UITableView *)tableView{
    NSInteger firstVisibleSection = self.tableView.indexPathsForVisibleRows.firstObject.section;
    return firstVisibleSection;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.indexArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.letterResultArr[section] count];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text = self.indexArray[section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowSelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowSelectTypeTableViewCell];
    BusinessTypeInfo *info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    cell.typeInfo = info;
    cell.selectImgView.hidden = !info.select;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.search) {
        BusinessTypeInfo *info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        for (BusinessTypeInfo *dinfo in self.typeItems) {
            dinfo.select = NO;
        }
        info.select = YES;
        [self.tableView reloadData];
        !self.selectBlock?:self.selectBlock(info);
        self.searchTextField.text = @"";
        self.search = NO;
    }else{
        BusinessTypeInfo *info = self.letterResultArr[indexPath.section][indexPath.row];
        for (BusinessTypeInfo *dinfo in self.typeItems) {
            dinfo.select = NO;
        }
        info.select = YES;
        [self.tableView reloadData];
        !self.selectBlock?:self.selectBlock(info);
    }
}
@end

//
//  SelectBusinessTypeView.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-02.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "SelectBusinessTypeView.h"
#import "BusinessUserResponse.h"
#import "SelectTypeCollectionViewCell.h"
#import "ShowSelectTypeCollectionViewCell.h"
@interface SelectBusinessTypeView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *titleCollectionView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@end

@implementation SelectBusinessTypeView
-(void)didShowSelectAddressView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
    }];
    [self.collectionView reloadData];
}

-(void)getItemListWithId:(NSInteger)areaId change:(BOOL)change indexPath:(NSIndexPath *)indexPath{
    GetBusinessTypeId *request = [GetBusinessTypeId request];
    request.pid = [NSNumber numberWithInteger:areaId];
    request.parameters = [request mj_JSONObject];
    [[BusinessNetworkReqManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BusinessTypeInfo class] success:^(NSArray<BusinessTypeInfo *> *response) {
        [self.numberItems addObject:response];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        self.currentSelectIndexPath = [NSIndexPath indexPathForItem:indexPath.item+1 inSection:0];
        [self.titleCollectionView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        //handle failure
    }];
}

-(void)hiddenSelectAddressView{
    [self removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
    }];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
        self.currentSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.bgContentView];
        [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@200);
            make.left.right.bottom.equalTo(@0);
        }];
        [self.bgContentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.equalTo(@20);
        }];
        [self.bgContentView addSubview:self.titleCollectionView];
        [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        [self.bgContentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.top.equalTo(self.titleCollectionView.mas_bottom).offset(0);
        }];
        [self addTarget:self action:@selector(hiddenSelectAddressView) forControlEvents:UIControlEventTouchUpInside];
        [self.bgContentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return self;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registNibWithNibName:kShowSelectTypeCollectionViewCell];
    }
    return _collectionView;
}

-(UICollectionView *)titleCollectionView{
    if (_titleCollectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        _titleCollectionView.showsVerticalScrollIndicator = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.scrollEnabled = YES;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [_titleCollectionView registNibWithNibName:kSelectTypeCollectionViewCell];
    }
    return _titleCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return self.numberItems.count;
    }
    return self.numberItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        ShowSelectTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShowSelectTypeCollectionViewCell forIndexPath:indexPath];
        cell.typeItems = [self.numberItems objectAtIndex:indexPath.item];
        cell.selectBlock = ^(BusinessTypeInfo * _Nonnull typeInfo) {
            if (self.selectBusinessTypes.count >= indexPath.item + 1) {
                NSInteger index = indexPath.item;
                NSInteger length = self.selectBusinessTypes.count - indexPath.item;
                [self.selectBusinessTypes removeObjectsInRange:NSMakeRange(index, length)];
            }
            [self.selectBusinessTypes addObject:typeInfo];
            if (self.numberItems.count > indexPath.item + 1) {
                NSInteger index = indexPath.item + 1;
                NSInteger length = self.numberItems.count-indexPath.item - 1;
                [self.numberItems removeObjectsInRange:NSMakeRange(index, length)];
            }
            if (typeInfo.parentId == 0) {
                [self getItemListWithId:typeInfo.businessTypeId change:YES indexPath:indexPath];
            }else{
                [self.collectionView reloadData];
                [self.titleCollectionView reloadData];
                !self.successBlock?:self.successBlock(self.selectBusinessTypes);
                [self hiddenSelectAddressView];
            }
        };
        return cell;
    }
    SelectTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectTypeCollectionViewCell forIndexPath:indexPath];
    cell.currentTypes = [self.numberItems objectAtIndex:indexPath.item];
    cell.lineView.hidden =! (self.currentSelectIndexPath == indexPath);
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        CGFloat contentOffsetx = scrollView.contentOffset.x;
        NSInteger index = contentOffsetx/ScreenWidth;
        self.currentSelectIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.titleCollectionView reloadData];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.titleCollectionView) {
        self.currentSelectIndexPath = indexPath;
        [self.titleCollectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        return CGSizeMake(ScreenWidth,ScreenHeight - 320);
    }
    BOOL contain = NO;
    BusinessTypeInfo *selectInfo;
    NSArray *items = [self.numberItems objectAtIndex:indexPath.row];
    for (BusinessTypeInfo *info in items) {
        if (info.select) {
            contain = YES;
            selectInfo = info;
            break;
        }
    }
    NSString *title;
    if (contain){
        if (BaseSettingManager.isChinaLanguages) {
            title = selectInfo.businessType;
        }else{
            title = selectInfo.businessTypeEn;
        }
    }else{
        title = @"ShowSelectAddressView.pleasSelect".icanlocalized;
    }
    CGFloat width = [NSString widthForString:title withFontSize:15 height:20] + 30;
    return CGSizeMake(width,40);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return 0;
    }
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return 0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSMutableArray<BusinessTypeInfo *> *)selectBusinessTypes{
    if (!_selectBusinessTypes) {
        _selectBusinessTypes = [NSMutableArray array];
    }
    return _selectBusinessTypes;
}

-(NSMutableArray<NSArray<BusinessTypeInfo *> *> *)numberItems{
    if (!_numberItems) {
        _numberItems = [NSMutableArray array];
    }
    return _numberItems;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel centerLabelWithTitle:@"Please Select Business Type".icanlocalized font:17 color:UIColor252730Color];
    }
    return _titleLabel;
}

-(UIView *)bgContentView{
    if (!_bgContentView) {
        _bgContentView = [[UIView alloc]init];
        _bgContentView.backgroundColor = UIColor.whiteColor;
    }
    return _bgContentView;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton dzButtonWithTitle:@"ShowSelectAddressView.sureBtn".icanlocalized image:nil backgroundColor:UIColor.whiteColor titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(sureBtnAction)];
        _sureBtn.hidden = NO;
    }
    return _sureBtn;
}

-(void)sureBtnAction{
    !self.successBlock?:self.successBlock(self.selectBusinessTypes);
    [self hiddenSelectAddressView];
}
@end

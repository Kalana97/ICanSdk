//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 18/8/2020
 - File name:  TimelineBrowseImageView.m
 - Description:
 - Function List:
 */


#import "TimelineBrowseImageView.h"
#import "TimelineBrowseImageViewCollectionViewCell.h"
@interface TimelineBrowseImageView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property(nonatomic, strong) UILabel *countLabel;
@end
@implementation TimelineBrowseImageView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.clearColor;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.top.equalTo(@(GK_SAFEAREA_TOP + 20.0+13));
            make.width.equalTo(@45);
            make.height.equalTo(@22);
        }];
    }
    return self;
}
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel=[UILabel centerLabelWithTitle:nil font:14 color:UIColor.whiteColor];
        _countLabel.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.3);
        [_countLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    }
    return _countLabel;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = YES;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.pagingEnabled=YES;
        _collectionView.backgroundColor                 = [UIColor clearColor];
        [_collectionView registNibWithNibName:kTimelineBrowseImageViewCollectionViewCell];
        
    }
    return _collectionView;
}

-(void)setTimeLineInfo:(TimelinesListDetailInfo *)timeLineInfo{
    _timeLineInfo=timeLineInfo;
    self.selectIndex=0;
    if (timeLineInfo.imageUrls.count>1) {
        self.countLabel.text=[NSString stringWithFormat:@"1/%zd",timeLineInfo.imageUrls.count];
        self.countLabel.hidden=NO;
    }else{
        self.countLabel.hidden=YES;
    }
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.timeLineInfo.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TimelineBrowseImageViewCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kTimelineBrowseImageViewCollectionViewCell forIndexPath:indexPath];
    cell.imageUrl=self.timeLineInfo.imageUrls[indexPath.item];
    //    [cell.browseImageView sd_setImageWithURL:[NSURL URLWithString:self.timeLineInfo.imageUrls[indexPath.item]]];
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth,ScreenHeight);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}

#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPaths.firstObject;
    self.countLabel.text=[NSString stringWithFormat:@"%zd/%zd",indexPath.row+1,self.timeLineInfo.imageUrls.count];
    self.selectIndex=indexPath.item;
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    //    CGPoint pInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    //    // 获取这一点的indexPath
    //    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pInView];
    
    
}
@end

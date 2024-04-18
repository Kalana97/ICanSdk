//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  EmojyCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "EmojyCollectionViewCell.h"
#import "EmojyFaceCollectionViewCell.h"
@interface EmojyCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
@implementation EmojyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.emojiCollectionView.delegate=self;
    self.emojiCollectionView.dataSource=self;
    self.emojiCollectionView.backgroundColor = [UIColor clearColor];
    [self.emojiCollectionView registNibWithNibName:@"EmojyFaceCollectionViewCell"];
    self.emojiCollectionView.clipsToBounds=YES;
    
    
}

-(void)setEmojyItmes:(NSArray *)emojyItmes{
    _emojyItmes=emojyItmes;
    [self.emojiCollectionView reloadData];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emojyItmes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojyFaceCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"EmojyFaceCollectionViewCell" forIndexPath:indexPath];
    cell.faceLabel.text=[self.emojyItmes objectAtIndex:indexPath.row];
    cell.selectEmojyBlock = ^(NSString * _Nonnull text) {
        if (self.selectEmojyBlock) {
            self.selectEmojyBlock(self.emojyItmes[indexPath.row]);
        }
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectEmojyBlock) {
        self.selectEmojyBlock(self.emojyItmes[indexPath.row]);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(45,45);
    
    
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
    if (isIPhoneX) {
        return UIEdgeInsetsMake(0, 10, 50, 10);
    }
    return UIEdgeInsetsMake(0, 10, 50, 10);
}
@end

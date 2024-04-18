//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/12/2019
- File name:  UICollectionView+DZExtension.m
- Description:
- Function List:
*/
        

#import "UICollectionView+DZExtension.h"

@implementation UICollectionView (DZExtension)
#pragma mark -- 注册 Nibcell --
- (void)registNibWithNibName:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:nibName];
    
}

#pragma mark -- 注册 classcell --
- (void)registClassWithClassName:(NSString *)className {
    [self registerClass:NSClassFromString(className) forCellWithReuseIdentifier:className];
}
@end

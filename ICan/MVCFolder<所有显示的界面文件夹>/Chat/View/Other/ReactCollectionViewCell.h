//
//  ReactCollectionViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReactCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) ReactItem *reactItem;
@end

NS_ASSUME_NONNULL_END

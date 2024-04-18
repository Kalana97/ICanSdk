//
//  ShowAppleMapLocationViewController.h
//  ICan
//
//  Created by MAC on 2022-11-03.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowAppleMapLocationViewController: UIViewController

@property(nonatomic, strong) LocationMessageInfo *locationMessageInfo;
@property(nonatomic, strong) TimelinesListDetailInfo *listRespon;
@property(nonatomic, strong) CollectionListDetailResponse *collectionResponse;

@end

NS_ASSUME_NONNULL_END

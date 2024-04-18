//
//  SelectNetworkTypeSecond.h
//  ICan
//
//  Created by Sathsara on 2022-10-11.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectNetworkTypeSecond : UIView
@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, strong) NSIndexPath *indexId;
@property(nonatomic, strong) NSString *typeDirected;
@property(nonatomic, copy) void (^selectBlock)(ICanWalletMainNetworkInfo*info);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END

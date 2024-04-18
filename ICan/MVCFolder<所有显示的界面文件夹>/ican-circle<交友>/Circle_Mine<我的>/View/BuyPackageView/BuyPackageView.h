//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 13/7/2021
- File name:  BuyPackageView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
#import "PayManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface BuyPackageView : UIView
@property(nonatomic, copy) void (^buySuccessBlock)(NSString*transactionId);
@property(nonatomic, strong) PayManager *packagePayManager;
@property(nonatomic, strong) NSArray<PackagesInfo*> *packagesItems;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@end

NS_ASSUME_NONNULL_END

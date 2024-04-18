//
//  SelectCurrencyDropDownView.h
//  ICan
//  Created by Kalana Rathnayaka on 12/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCurrencyDropDownView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *selectedC;
@property(nonatomic, copy) void (^hiddenBlock)(void);
@property(nonatomic, copy) void (^selectBlock)(NSInteger tradingTitle, NSString *currencyTitle);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END

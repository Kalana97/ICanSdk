//
//  PinMenueBar.h
//  ICan
//
//  Created by MAC on 2023-03-13.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PinMenueBarDelegate <NSObject>
- (void)tapOnPinMenueButton;
@end

@interface PinMenueBar : UIView
@property(nonatomic, weak) id <PinMenueBarDelegate>delegate;
@property(nonatomic, strong) NSMutableArray<ChatModel*>* messagesArray;
@property(nonatomic, strong) UILabel *messageLabel;
- (void)hiddenView;
- (void)showView;
@end

NS_ASSUME_NONNULL_END

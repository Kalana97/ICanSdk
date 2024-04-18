//
//  ChatListMenuView.h
//  CaiHongApp
//
//  Created by lidazhi on 2019/5/7.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListMenuView : UIView
@property (nonatomic,strong ) NSArray <NSDictionary*>*menuItems;
@property (nonatomic,strong)  UITableView * tableView;
@property (nonatomic,copy)    void (^didSelectBlock)(NSInteger index);
+(instancetype)showMenuViewWithMenuItems:(NSArray<NSDictionary*>*)menuItems didSelectBlock:(void (^)(NSInteger index))didSelectBlock;
-(void)showChatListMenuView;
-(void)hiddenChatListMenuView;
- (void)showView;
- (void)hideView;
@end

NS_ASSUME_NONNULL_END

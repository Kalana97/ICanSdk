//
//  DynamicTableViewCell.h
//  ICan
//
//  Created by Kalana Rathnayaka on 04/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
//#import "DynamicMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kDynamicChatHelperListTableViewCell = @"DynamicTableViewCell";
@interface DynamicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UIView *headerImgContainer;
@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (nonatomic, weak) DynamicMessageInfo *infoTTTTT;
@property (nonatomic, copy) DynamicMessageInfo *infor;
@property(nonatomic,copy)NSString *htmlString ;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end

NS_ASSUME_NONNULL_END

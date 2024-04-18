//
//  WebPageVC.h
//  ICan
//
//  Created by Sathsara on 2022-10-10.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebPageVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString * pageTitle;
@property (nonatomic,assign) BOOL isChat;
@property (nonatomic,assign) BOOL isCommon;
@property (nonatomic,assign) BOOL isProperty;
@property (nonatomic,assign) BOOL isCnt;
@property (nonatomic,assign) BOOL isPay;
@property (nonatomic,assign) BOOL isDynamicMessage;
@property (nonatomic,assign) NSString *chatUrlString;
@property (nonatomic,assign) NSString *walletUrlString;
@property (nonatomic,assign) NSString *payUrlString;
@property (nonatomic,assign) NSString *dynamicMessageURL;
@property (nonatomic,assign) NSString *htmlString;
- (void)setCloseButtonHandler:(void (^ _Nullable)(void))handler;
//-(void)closeButtonHandler;
@end

NS_ASSUME_NONNULL_END

//
//  WebPageVC.m
//  ICan
//
//  Created by Sathsara on 2022-10-10.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "WebPageVC.h"

@interface WebPageVC ()

@property (nonatomic,copy) NSString *stringUrl;
@end

@implementation WebPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem= [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_back_black") target:self action:@selector(backButtonPressed:)];
    if(self.isProperty == YES){
        self.stringUrl = @"https://properties.icanlk.com/home";
        self.title = @"iCan Property";
    }else if(self.isCnt == YES){
        NSString *token = UserInfoManager.sharedManager.token;
        NSString *c2cToken = C2CUserManager.shared.token;
        NSString *baseUrl = @"https://icanpay.app/home?";
        NSString *strToken = @"token=";
        NSString *strC2cToken = @"&c2cToken=";
        NSString *formattedString = [NSString stringWithFormat:@"%@%@%@%@%@", baseUrl, strToken, token, strC2cToken, c2cToken];
        self.stringUrl = formattedString;
        self.title = @"CNT";
    }else if(self.isCommon == YES){
        self.stringUrl = self.walletUrlString;
        self.title = @"";
    }else if(self.isDynamicMessage == YES){
        self.title = @"";
        if(self.dynamicMessageURL != nil){
            self.stringUrl = self.dynamicMessageURL;
        }else{
            [self.webView loadHTMLString:self.htmlString baseURL:nil];
            return;
        }
    }
    else{
        if(self.isChat == NO){
            NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *countryCodeStr = [UserInfoManager sharedManager].countriesCode;
            self.stringUrl = [NSString stringWithFormat:@"%@%@%@%@", @"https://mall.icanlk.com/?country=", countryCodeStr, @"&&language=", languageCode];
        }else{
            self.title = @"";
            self.stringUrl = self.chatUrlString;
        }
    }
    NSURL *urlNs = [NSURL URLWithString:self.stringUrl];
    NSURLRequest *requUrl = [NSURLRequest requestWithURL:urlNs];
    [self.webView loadRequest:requUrl];
}
// Override the back button functionality
- (IBAction)backButtonPressed:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else if(self.isChat || self.isDynamicMessage || self.isCommon){
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        // Perform any other actions or handle back button press as needed
        [[AppDelegate shared].curNav popToRootViewControllerAnimated:NO];
    }
}
@end

//
//  WatchWalletCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "WatchWalletCell.h"
#import "ChatViewHandleTool.h"

@implementation WatchWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imhViewCard.layer.cornerRadius = 10.0;
    self.imhViewCard.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    [self.currencyType1 addGestureRecognizer:tapGestureRecognizer];
    [self.currencyType2 addGestureRecognizer:tapGestureRecognizer];
    [self.mainStack addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)labelTapped:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.viewPageBlock) {
        self.viewPageBlock(self.walletModel);
    }
}

-(void)setWatchWalletData:(WatchWalletListInfo*)WatchWalletModel{
    self.imhViewCard.image = [UIImage imageNamed:[ChatViewHandleTool getImageByChannelCodeWatchWallet:WatchWalletModel.channelCode]];
    self.walletModel = WatchWalletModel;
    if([WatchWalletModel.channelCode isEqualToString:@"ican"]){
        if(WatchWalletModel.extendAddress1 != nil && ![WatchWalletModel.extendAddress1  isEqual: @""]){
            if ([WatchWalletModel.extendAddress1 hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([WatchWalletModel.extendAddress1 hasPrefix:@"0x"]) {
                self.currencyType2.text = @"ERC20";
            }
            self.mainStack1.hidden = NO;
            self.walletAddressLbl.text = WatchWalletModel.extendAddress1;
        }else{
            self.mainStack1.hidden = YES;
        }
        if(WatchWalletModel.extendAddress2 != nil && ![WatchWalletModel.extendAddress2  isEqual: @""]){
            if ([WatchWalletModel.extendAddress2 hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([WatchWalletModel.extendAddress2 hasPrefix:@"0x"]) {
                self.currencyType2.text = @"ERC20";
            }
            self.mainStack2.hidden = NO;
            self.walletAddressLbl1.text = WatchWalletModel.extendAddress2;
        }else{
            self.mainStack2.hidden = YES;
        }
    }else{
        if ([WatchWalletModel.walletAddress hasPrefix:@"T"]) {
            self.currencyType1.text = @"TRC20";
        } else if ([WatchWalletModel.walletAddress hasPrefix:@"0x"]) {
            self.currencyType2.text = @"ERC20";
        }
        self.walletAddressLbl.text = WatchWalletModel.walletAddress;
        self.mainStack2.hidden = YES;
    }
    self.walletNameLbl.text = WatchWalletModel.name;
}

- (IBAction)copyAddress1Action:(id)sender {
    __block NSString *textToCopy;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if([self.walletModel.channelCode  isEqual: @"ican"]){
        textToCopy = self.walletModel.extendAddress1;
    }else{
        textToCopy = self.walletModel.walletAddress;
    }
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (IBAction)copyAddress2Action:(id)sender {
    __block NSString *textToCopy;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if([self.walletModel.channelCode  isEqual: @"ican"]){
        textToCopy = self.walletModel.extendAddress2;
    }else{
        textToCopy = self.walletModel.walletAddress;
    }
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (IBAction)viewWalletDetails:(id)sender {
    if (self.viewPageBlock) {
        self.viewPageBlock(self.walletModel);
    }
}

@end

//
//  UMShareManager.h
//  CaiHongApp
//
//  Created by lidazhi on 2019/5/27.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
NS_ASSUME_NONNULL_BEGIN
@interface ShareView:UIView
@property (nonatomic,strong)  NSArray * typeArray;
@property (nonatomic,copy) void (^ didselectItem)(NSInteger index);
-(void)hiddenShareView;
-(void)showShareView;

@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface IcanShareManager : NSObject
+(instancetype )sharedManager;
@property (nonatomic,strong) ShareView *shareView;
@property(nonatomic, copy) void (^tapIndexBlock)(NSInteger index);
-(void)ftShareWebpageUrl:(NSString*)webpageUrl title:(NSString* )title des:(NSString* _Nullable )des thumImage:(NSString*_Nullable)thumImage thumbData:(NSData*_Nullable)thumbData image:(UIImage*_Nullable)image;

-(void)ftShareThumImage:(UIImage*)thumImage sharingChannels:(NSArray*)sharingChannels;
@end

NS_ASSUME_NONNULL_END

//
//  ChatViewController.h
//
//  Created by 猪海🐷 on 2019/10/5.
// JSONObjectWithData

#import "QDCommonTableViewController.h"
@class  ChatModel;

@interface ChatViewController : QDCommonTableViewController
//必传
@property (nonatomic, strong) ChatModel *config;

@property(nonatomic, copy) NSString *authorityType;
@property (nonatomic,copy) void (^deleteMessageBlock)(void);


@property (nonatomic,copy) NSString * userId;
/**
 是否来自搜索聊天记录页面,并且需要搜索出对应的聊天记录
 */
@property(nonatomic, assign) BOOL shouldStartLoad;

@property(nonatomic, copy) NSString *searchText;

+(void)callIcon;
-(void)setThumbnailDetails:(ChatModel *)textModel ofUrl:(NSURL *)url;

@end

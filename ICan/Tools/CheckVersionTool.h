//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/4/2020
- File name:  CheckVersionTool.h
- Description:检测版本
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckVersionTool : NSObject
@property (nonatomic,assign) BOOL isHasShow;
@property(nonatomic, strong) NSMutableArray *announcementItems;
+ (instancetype)sharedManager;
+(void)checkVersioForceUpdate;
-(void)getAnnouncementRequest;
@end

NS_ASSUME_NONNULL_END

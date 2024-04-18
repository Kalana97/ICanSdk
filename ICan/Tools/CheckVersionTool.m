//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 14/4/2020
 - File name:  CheckVersionTool.m
 - Description:
 - Function List:
 */


#import "CheckVersionTool.h"
#import "VersionAlertView.h"
#import "AnnouncementToastView.h"
@implementation CheckVersionTool
+ (instancetype)sharedManager {
    static CheckVersionTool *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[CheckVersionTool alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:api selector:@selector(showAnnouncementsView) name:@"showAnnouncementsViewNotication" object:nil];
        
        
    });
    return api;
}
-(void)showAnnouncementsView{
    if (self.announcementItems.count>0) {
//        AnnouncementToastView*view= [[NSBundle mainBundle]loadNibNamed:@"AnnouncementToastView" owner:self options:nil].firstObject;
//        view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        view.announcementsInfo=self.announcementItems.firstObject;
//        [self.announcementItems removeObjectAtIndex:0];
//        [view showView];
    }
}

+(void)checkVersioForceUpdate{
    VersionsRequest*request=[VersionsRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[VersionsInfo class] contentClass:[VersionsInfo class] success:^(VersionsInfo* response) {
        if(response.version != nil){
            if (response.forced) {
                VersionAlertView*view=[[VersionAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.versionsInfo=response;
                [view showVersionAlertView];
            }else{
                VersionAlertView*view=[[VersionAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.versionsInfo=response;
                [view showVersionAlertView];
            }
        }
       
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

-(void)getAnnouncementRequest{
    AnnouncementsRequest*request=[AnnouncementsRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AnnouncementsInfo class] success:^(NSArray<AnnouncementsInfo*>* response) {
        if (response.count>0) {
//            self.announcementItems=[NSMutableArray arrayWithArray:response];
//            AnnouncementToastView*view= [[NSBundle mainBundle]loadNibNamed:@"AnnouncementToastView" owner:self options:nil].firstObject;
//            view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//            view.announcementsInfo=self.announcementItems.firstObject;
//            [self.announcementItems removeObjectAtIndex:0];
//            [view showView];
            
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}
@end

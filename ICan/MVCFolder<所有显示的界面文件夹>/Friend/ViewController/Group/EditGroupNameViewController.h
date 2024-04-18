//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 30/9/2019
- File name:  EidtGroupNameViewController.h
- Description: 用来修改群名称或者用来修改自己在本群的昵称
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,EditNameType){
    EditNameType_GroupName=1,
    EditNameType_GroupNickname,//修改群昵称
    EditNameType_UserRemark,//修改用户备注
    
    
} ;
@interface EditGroupNameViewController : BaseViewController
@property(nonatomic, strong) GroupListInfo *groupDetailInfo;
@property (nonatomic,strong) UserMessageInfo * userMessageInfo;

@property(nonatomic, assign) EditNameType editNameType;
/** 修改用户备注回调  */
@property (nonatomic,copy) void (^editSuccessBlock)(NSString*name);
@end

NS_ASSUME_NONNULL_END

//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/4/2020
- File name:  SystemRequest.h
- Description: 一些系统性质的操作
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemRequest : BaseRequest

@end
/** 控制展示 */
@interface PrivateParameterRequest : BaseRequest

@end

/** 版本控制 */
@interface VersionsRequest : BaseRequest

@end

/** /announcements 列表 */
@interface AnnouncementsRequest : BaseRequest

@end
/**
 /public/hello
 */
@interface TestDomainRequest:BaseRequest
@end

/**
 /public/startPages
 
 */

@interface GetPublicStartPagesRequest:BaseRequest

@end

NS_ASSUME_NONNULL_END

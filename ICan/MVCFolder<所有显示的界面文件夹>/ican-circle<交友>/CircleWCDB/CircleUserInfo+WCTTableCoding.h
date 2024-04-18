//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 9/6/2021
- File name:  CircleCacheUserInfo+WCTTableCoding.h
- Description:
- Function List:
*/
        

#import "CircleUserInfo.h"
#import <WCDB/WCDB.h>

@interface CircleUserInfo (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(nickname)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(avatar)
WCDB_PROPERTY(userId)
WCDB_PROPERTY(icanId)
WCDB_PROPERTY(enable)
WCDB_PROPERTY(yue)
@end

//
//  InvitedByInfo+WCTColumnCoding.mm
//  ICan
//
//  Created by MAC on 2022-10-06.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitedByInfo.h"
#import <WCDB/WCDB.h>

@interface InvitedByInfo (WCTColumnCoding) <WCTColumnCoding>
@end

@implementation InvitedByInfo (WCTColumnCoding)


+ (instancetype)unarchiveWithWCTValue:(NSObject *)value
{
    if (value) {
        InvitedByInfo *InvitedBy = [value mj_JSONObject];
        return InvitedBy;
    }
    return nil;
}

- (NSString *)archivedWCTValue
{
    return [self mj_JSONString];
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeString;
}

@end

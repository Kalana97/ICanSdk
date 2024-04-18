//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 24/10/2019
- File name:  DZUIDocument.m
- Description:
- Function List:
*/
        

#import "DZUIDocument.h"

@implementation DZUIDocument
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
     self.data = contents;
    return YES;
}
- (nullable id)contentsForType:(NSString *)typeName error:(NSError **)outError __TVOS_PROHIBITED{
    
    return self.data?:[NSData data];
    
}
@end

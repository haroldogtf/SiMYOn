//
//  Facebook.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/04/15.
//
//

#import <Foundation/Foundation.h>

@interface Facebook : NSObject

typedef void (^LoginBlock)(NSError *error);
typedef void (^UserNameBlock)(NSString *userName, NSError *error);

+ (BOOL) hasActiveSession;
+ (void) closeSession;
+ (void) setNilInSection;
+ (void) login:(LoginBlock)block;
+ (void) getUserName:(UserNameBlock)block;
    
@end
//
//  Facebook.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/04/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Facebook : NSObject

#define FACEBOOK_ACCESS_DENIED 306

typedef void (^LoginBlock)(BOOL logged, NSError *error);
typedef void (^UserNameBlock)(NSString *userName, NSError *error);

+ (BOOL) hasActiveSession;
+ (void) login:(UIViewController *)view withBlock:(LoginBlock)block;
+ (void) logout;
+ (void) getUserName:(UserNameBlock)block;
    
@end
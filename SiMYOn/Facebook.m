//
//  Facebook.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/04/15.
//
//

#import "Facebook.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation Facebook

+ (BOOL) hasActiveSession {
    return FBSession.activeSession.isOpen;
}

+ (void) closeSession {
   [FBSession.activeSession closeAndClearTokenInformation];
}

+ (void) setNilInSection {
    FBSession.activeSession = nil;
}

+ (void) login:(LoginBlock)block {
    [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorForcingWebView
                            completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                if(!error) {
                                    block(error);
                                }
                            }
     ];
}

+ (void) getUserName:(UserNameBlock)block {
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                  block(user.name, error);
                              }
     ];
}

@end
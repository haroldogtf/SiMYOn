//
//  Facebook.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/04/15.
//
//

#import "Facebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation Facebook

+ (BOOL) hasActiveSession {
    
    if([FBSDKAccessToken currentAccessToken]) {
        return YES;
    }
    return NO;
}

+ (void) login:(UIViewController *)view withBlock:(LoginBlock)block {
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login logInWithReadPermissions: @[@"public_profile"]
                 fromViewController:view
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error || result.isCancelled) {
                                    block(NO, error);
                                } else {
                                    block(YES, error);
                                }
     }];
}

+ (void) logout {
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
}

+ (void) getUserName:(UserNameBlock)block {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"name"}]
                       startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
         NSString *name;
         if (!error) {
             name = result[@"name"];
         }
         block(name, error);
     }];
}

@end
//
//  AppDelegate.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MainViewController.h"
#import <MyoKit/MyoKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureMyoSettings];
    [self configureParse];
    [self configureRanking];
    [self configureSound];
    [self configureNavigation];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void) configureMyoSettings {
    [[TLMHub sharedHub] setApplicationIdentifier:APP_IDENTIFIER];
    [[TLMHub sharedHub] setShouldSendUsageData:NO];
    [[TLMHub sharedHub] setShouldNotifyInBackground:NO];
    [[TLMHub sharedHub] setLockingPolicy:TLMLockingPolicyNone];
}

- (void) configureParse {
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
}

- (void) configureRanking {
    for (int i = 1; i <= OFFLINE_RANKING; i++) {
        [[NSUserDefaults standardUserDefaults] setObject:INITAL_NAME forKey:[PLAYER stringByAppendingFormat:@"%d", i]];
        [[NSUserDefaults standardUserDefaults] setObject:INITIAL_SCORE forKey:[SCORE_PLAYER stringByAppendingFormat:@"%d", i]];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) configureSound {
    BOOL configured = [[NSUserDefaults standardUserDefaults] boolForKey:SOUND_CONFIGURED];

    if(!configured) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PLAY_SOUND];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUND_CONFIGURED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) configureNavigation {
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc]init]];
    navigation.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

@end
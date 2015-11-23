//
//  AppDelegate.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Util.h"
#import "Myo.h"
#import "Ranking.h"
#import "MainViewController.h"
//#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Myo configureMyo];
    [Ranking configureParse];
    [Ranking configureInitialRanking];
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
//    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return YES;
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
    MainViewController *mainViewController = [[MainViewController alloc]init];
    UINavigationController *navigation;
    navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    navigation.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

@end
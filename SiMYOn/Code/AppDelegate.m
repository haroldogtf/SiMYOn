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
#import "BestScoresViewController.h"
#import "SyncViewController.h"
#import "GameViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import Firebase;

@interface AppDelegate ()

@property UINavigationController *navigation;

@end

@implementation AppDelegate

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    [Fabric with:@[[Crashlytics class]]];
    [Myo configureMyo];
    [Ranking configureParse:launchOptions];
    [Ranking configureInitialRanking];
    [self configureSound];
    [self configureNavigation];
    [self configure3DTouch:launchOptions];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
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
    self.navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.navigation.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigation;
    [self.window makeKeyAndVisible];
}

- (void)configure3DTouch:(NSDictionary *)launchOptions {

    UIApplicationShortcutItem *withMyo
        = [[UIApplicationShortcutItem alloc]initWithType:PLAY_WITH_MYO
                                          localizedTitle:PLAY_WITH_MYO
                                       localizedSubtitle:nil
                                                    icon:[UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypePlay]
                                                userInfo:nil];
    
    UIApplicationShortcutItem *withoutMyo
        = [[UIApplicationShortcutItem alloc]initWithType:PLAY_WITHOUT_MYO
                                          localizedTitle:PLAY_WITHOUT_MYO
                                       localizedSubtitle:nil
                                                    icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay]
                                                userInfo:nil];
    
    UIApplicationShortcutItem * bestScores
        = [[UIApplicationShortcutItem alloc]initWithType:BEST_SCORES
                                          localizedTitle:BEST_SCORES
                                       localizedSubtitle:nil
                                                    icon:[UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeTaskCompleted]
                                                userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[withMyo, withoutMyo, bestScores];
}

- (void)         application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
           completionHandler:(void (^)(BOOL))completionHandler {
    
                if([shortcutItem.localizedTitle isEqualToString:BEST_SCORES]) {
                    [self.navigation pushViewController:[[BestScoresViewController alloc]init] animated:YES];
                    
                } else if([shortcutItem.localizedTitle isEqualToString:PLAY_WITH_MYO]) {
                    [self.navigation pushViewController:[[SyncViewController alloc]init] animated:YES];
                    
                } else if([shortcutItem.localizedTitle isEqualToString:PLAY_WITHOUT_MYO]) {
                    BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:PLAY_SOUND];
                    [self.navigation pushViewController:[[GameViewController alloc]initIsPlaySound:sound andUseMyo:NO] animated:YES];
                }

                completionHandler(YES);
}

@end

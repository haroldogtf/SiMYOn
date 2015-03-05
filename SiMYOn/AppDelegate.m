//
//  AppDelegate.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureMyoSettings];
    [self configureParse];
    [self configureRanking];
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
    [[TLMHub sharedHub] setApplicationIdentifier:@"br.ufpe.cin.SiMYOn"];
    [[TLMHub sharedHub] setShouldSendUsageData:NO];
    [[TLMHub sharedHub] setShouldNotifyInBackground:NO];
    [[TLMHub sharedHub] setLockingPolicy:TLMLockingPolicyNone];
}

- (void) configureParse {
    [Parse setApplicationId:@"mxVK7rpNAZjBeIzkJ2qojoALb3aPb2Vate5X4I6Q"
                  clientKey:@"IzHTVKmzOUZQFz5rkRi1VReErvmbFyvLgwf2DOjF"];
}

- (void) configureRanking {
    
    for (int i = 1; i <= 8; i++) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:[@"player" stringByAppendingFormat:@"%d", i]];
        [[NSUserDefaults standardUserDefaults] setObject:@"0"  forKey:[@"scorePlayer" stringByAppendingFormat:@"%d", i]];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) configureNavigation {
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc]init]];
    navigation.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

@end
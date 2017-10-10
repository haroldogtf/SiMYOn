
//
//  Util.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/03/15.
//
//

#import "Util.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation Util

# pragma mark - Public methods

+ (int) getRandomMovement {
    return arc4random_uniform(400) % 4;
}

+ (BOOL) hasInternetConnection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    BOOL connected;
    BOOL hasInternet;
    const char *host = "www.google.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    hasInternet = NO;
    hasInternet = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);

    return hasInternet;
}

+ (NSString *) selectNibNameByModel:(NSString *) nibName {
    
    NSString *model;
    
    switch ([self getIphoneModel]) {
        case IPHONE_5_5C_5S_MODEL: model = NIB_IPHONE_5_5C_5S; break;
        case IPHONE_6_MODEL:       model = NIB_IPHONE_6;       break;
        case IPHONE_6_PLUS_MODEL:  model = NIB_IPHONE_6_PLUS;  break;
        default:                   model = NIB_NOT_SUPPORTED;  break;
    }
        
    if([model isEqualToString:NIB_NOT_SUPPORTED]) {
        return model;
    }
    
    return  [nibName stringByAppendingString:model];
}

+ (void) setString:(NSString *) string forKey:(NSString *) key {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
}

# pragma mark - Private methods

+ (IPhoneModel) getIphoneModel
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    IPhoneModel model;
    switch ((int)result.height) {
        case IPHONE_5_5C_5S_HEIGHT: model = IPHONE_5_5C_5S_MODEL;       break;
        case IPHONE_6_HEIGHT:       model = IPHONE_6_MODEL;             break;
        case IPHONE_6_PLUS_HEIGHT:  model = IPHONE_6_PLUS_MODEL;        break;
        default:                    model = IPHONE_NOT_SUPPORTED_MODEL; break;
    }
    
    return model;
}

@end

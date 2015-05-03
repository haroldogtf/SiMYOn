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

@implementation Util

# pragma mark - Public methods

+ (int) getRandomMovement {
    return arc4random_uniform(400) % 4;
}

+ (BOOL) hasInternetConnection {
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TEST_CONNECTION]];
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    BOOL hasInternet = NO;
    if([response statusCode] == 200) {
        hasInternet = YES;
    }
    
    return hasInternet;
}

+ (NSString *) selectNibNameByModel:(NSString *) nibName {
    
    NSString *model;
    switch ([self getIphoneModel]) {
        case IPHONE_5_5C_5S_MODEL: model = NIB_IPHONE_5_5C_5S; break;
        case IPHONE_6_MODEL:       model = NIB_IPHONE_6;       break;
        case IPHONE_6_PLUS_MODEL:  model = NIB_IPHONE_6_PLUS;  break;
        default:                   return NIB_NOT_SUPPORTED;   break;
    }
    
    return [nibName stringByAppendingString:model];;
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
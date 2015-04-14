//
//  Util.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/03/15.
//
//

#import "Util.h"
#import <UIKit/UIKit.h>

@implementation Util

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

+ (void) setString:(NSString *) string forKey:(NSString *) key {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
}

@end
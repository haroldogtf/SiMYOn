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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TEST_CONNECTION]];
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

+ (IPhoneModel) getIphoneModel
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    switch ((int)result.height) {
            
        case IPHONE_5_5C_5S_HEIGHT: return IPHONE_5_5C_5S_MODEL;       break;
        case IPHONE_6_HEIGHT:       return IPHONE_6_MODEL;             break;
        case IPHONE_6_PLUS_HEIGHT:  return IPHONE_6_PLUS_MODEL;        break;
        default:                    return IPHONE_NOT_SUPPORTED_MODEL; break;
    }
}

@end
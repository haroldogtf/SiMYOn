//
//  Util.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/03/15.
//
//

#import "Util.h"

@implementation Util

+ (BOOL) hasInternetConnection {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.parse.com"]];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

@end
//
//  Util.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/03/15.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Util : NSObject

+ (BOOL) hasInternetConnection;
+ (IPhoneModel) getIphoneModel;
+ (void) setString:(NSString *) string forKey:(NSString *) key;

@end
//
//  Util.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 06/03/15.
//
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (int)  getRandomMovement;
+ (BOOL) hasInternetConnection;
+ (void) setString:(NSString *) string
            forKey:(NSString *) key;
+ (NSString *) selectNibNameByModel:(NSString *) nibName;

@end
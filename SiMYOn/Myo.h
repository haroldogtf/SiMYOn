//
//  Myo.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 18/04/15.
//
//

#import <Foundation/Foundation.h>

@interface Myo : NSObject

+ (void) configureMyo;
+ (void)setSynced:(BOOL)synced;
+ (BOOL)isSynced;
+ (void)setConnected:(BOOL)connected;
+ (BOOL)isConnected;

@end
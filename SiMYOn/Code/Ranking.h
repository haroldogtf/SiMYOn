//
//  Ranking.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#import "Player.h"
#import <Foundation/Foundation.h>

@interface Ranking : NSObject

typedef void (^BestScoresBlock)(NSArray *bestScores, NSError *error);

+ (void) configureParse:(NSDictionary *)launchOptions;
+ (void) configureInitialRanking;
+ (void) getScoresFromParse:(BestScoresBlock)block;
+ (void) saveScoresInParseWithName:(NSString *)name
                             score:(NSNumber *)score
                       andUsingMyo:(BOOL)useMyo;
+ (Player *) getPlayer:(id)object;

@end
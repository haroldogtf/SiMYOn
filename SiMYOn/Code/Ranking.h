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

typedef void (^BestScoresBlock)(NSArray *bestScores);

+ (void) configureInitialRanking;
+ (void) getBestScores:(BestScoresBlock)block;
+ (void) saveScoresWithName:(NSString *)name
                      score:(NSString *)score;
+ (Player *) getPlayer:(id)object;

@end

//
//  Ranking.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Ranking : NSObject

typedef void (^BestScoresBlock)(NSArray *bestScores, NSError *error);

+ (void) getScoresFromParse:(BestScoresBlock)block;

+ (void) saveScoresInParseWithName:(NSString *)name
                             score:(int)score
                       andUsingMyo:(BOOL)useMyo;

@end
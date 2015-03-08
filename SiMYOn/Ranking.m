//
//  Ranking.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#import "Ranking.h"

@implementation Ranking

+ (void) getScoresFromParse:(BestScoresBlock)block {
    
    PFQuery *query = [PFQuery queryWithClassName:RANKING];
    [query addDescendingOrder:SCORE];
    [query addAscendingOrder: CREATED_AT];
    query.limit = 12;
    [query findObjectsInBackgroundWithBlock:^(NSArray *scores, NSError *error) {
        block(scores, error);
    }];
}

+ (void) saveScoresInParseWithName:(NSString *)name
                             score:(NSNumber *)score
                       andUsingMyo:(BOOL)useMyo {
    
    PFObject *ranking  = [PFObject objectWithClassName:RANKING];
    ranking[NAME]      = name;
    ranking[SCORE]     = score;
    ranking[USING_MYO] = [NSNumber numberWithBool:useMyo];
    
    [ranking saveInBackground];
}

@end
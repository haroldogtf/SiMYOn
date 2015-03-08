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
    
    PFQuery *query = [PFQuery queryWithClassName:@"ranking"];
    [query addDescendingOrder:@"score"];
    [query addAscendingOrder:@"createdAt"];
    query.limit = 12;
    [query findObjectsInBackgroundWithBlock:^(NSArray *scores, NSError *error) {
        block(scores, error);
    }];
}

+ (void) saveScoresInParseWithName:(NSString *)name
                             score:(int)score
                       andUsingMyo:(BOOL)useMyo {
    
    PFObject *ranking = [PFObject objectWithClassName:@"ranking"];
    ranking[@"name"] = name;
    ranking[@"score"] = [[NSNumber alloc] initWithInteger:score];
    ranking[@"using_myo"] = [NSNumber numberWithBool:useMyo];
    
    [ranking saveInBackground];
}

@end
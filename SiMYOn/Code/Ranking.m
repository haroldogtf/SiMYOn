//
//  Ranking.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/03/15.
//
//

#import "Ranking.h"
#import "Constants.h"
#import "Util.h"
#import <Parse/Parse.h>

@implementation Ranking

+ (void) configureInitialRanking {
    for (int i = 1; i <= OFFLINE_RANKING; i++) {
        
        NSString *player = [PLAYER stringByAppendingFormat:@"%d", i];
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:player]) {
            [Util setString:INITAL_NAME   forKey:player];
            [Util setString:INITIAL_SCORE forKey:[SCORE_PLAYER stringByAppendingFormat:@"%d", i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) getScoresFromParse:(BestScoresBlock)block {
    
    PFQuery *query = [PFQuery queryWithClassName:RANKING];
    [query addDescendingOrder:SCORE];
    [query addAscendingOrder: CREATED_AT];
    query.limit = TOP_RANKING;
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

+ (Player *) getPlayer:(id)object {
    PFObject * parsePlayer = (PFObject *)object;
    
    Player *player = [[Player alloc]init];
    player.name = parsePlayer[NAME];
    player.score = [NSString stringWithFormat:@"%@", parsePlayer[SCORE]];
    
    return player;
}

@end

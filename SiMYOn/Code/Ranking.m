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
#import "SiMYOn-Swift.h"

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

+ (void) getBestScores:(BestScoresBlock)block {
    [[RankingFirebase getInstance] getBestScoresWithCompletion:^(NSArray<Player *> * players) {
        block(players);
    }];
}

+ (void) saveScoresWithName:(NSString *)name
                      score:(NSString *)score {
    
    Player *player = [Player new];
    player.name = name;
    player.score = score;
    [[RankingFirebase getInstance] saveScoreWithPlayer:player];
}

+ (Player *) getPlayer:(id)object {
    PFObject * parsePlayer = (PFObject *)object;
    
    Player *player = [[Player alloc]init];
    player.name = parsePlayer[NAME];
    player.score = [NSString stringWithFormat:@"%@", parsePlayer[SCORE]];
    
    return player;
}

@end

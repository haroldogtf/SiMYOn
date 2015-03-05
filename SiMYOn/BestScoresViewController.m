//
//  BestScoresViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 08/02/15.
//
//

#import "BestScoresViewController.h"

@interface BestScoresViewController ()

@end

@implementation BestScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.bestScores) {
        [self updateScoresInInterface];
    } else {
        [self updateInterfaceWithNoRankingUpdate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateInterfaceWithNoRankingUpdate {
    self.imgBackground.image = [UIImage imageNamed:@"best_scores_no_connection"];
    
    self.lblPlayer9.hidden      = YES;
    self.lblScorePlayer9.hidden = YES;
    
    self.lblPlayer10.hidden      = YES;
    self.lblScorePlayer10.hidden = YES;
    
    self.lblPlayer11.hidden      = YES;
    self.lblScorePlayer11.hidden = YES;
    
    self.lblPlayer12.hidden      = YES;
    self.lblScorePlayer12.hidden = YES;
}

- (void) updateScoresInInterface {

    [self updateRanking:[self getScore:0]
               withName:self.lblPlayer1
               andScore:self.lblScorePlayer1];
    
    [self updateRanking:[self getScore:1]
               withName:self.lblPlayer2
               andScore:self.lblScorePlayer2];
    
    [self updateRanking:[self getScore:2]
               withName:self.lblPlayer3
               andScore:self.lblScorePlayer3];
    
    [self updateRanking:[self getScore:3]
               withName:self.lblPlayer4
               andScore:self.lblScorePlayer4];
    
    [self updateRanking:[self getScore:4]
               withName:self.lblPlayer5
               andScore:self.lblScorePlayer5];
    
    [self updateRanking:[self getScore:5]
               withName:self.lblPlayer6
               andScore:self.lblScorePlayer6];
    
    [self updateRanking:[self getScore:6]
               withName:self.lblPlayer7
               andScore:self.lblScorePlayer7];
    
    [self updateRanking:[self getScore:7]
               withName:self.lblPlayer8
               andScore:self.lblScorePlayer8];
    
    [self updateRanking:[self getScore:8]
               withName:self.lblPlayer9
               andScore:self.lblScorePlayer9];
    
    [self updateRanking:[self getScore:9]
               withName:self.lblPlayer10
               andScore:self.lblScorePlayer10];
    
    [self updateRanking:[self getScore:10]
               withName:self.lblPlayer11
               andScore:self.lblScorePlayer11];
    
    [self updateRanking:[self getScore:11]
               withName:self.lblPlayer12
               andScore:self.lblScorePlayer12];
}

- (PFObject *) getScore:(int) index {
    @try {
        return [self.bestScores objectAtIndex:index];
    }
    @catch (NSException * e) {
        return nil;

    }
}

- (void) updateRanking:(PFObject *)player
              withName:(UILabel *)name
              andScore:(UILabel *)score {

    if(player) {
        name.text  = player[@"name"];
        score.text = [NSString stringWithFormat:@"%@", player[@"score"]];
    }
}

@end
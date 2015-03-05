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
        [self updateScores];
    } else {
        [self updateScoresWithConnectionProblems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateScoresWithConnectionProblems {
    self.imgBackground.image = [UIImage imageNamed:@"best_scores_no_connection"];
    
    self.lblPlayer1.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player1"];
    self.lblScorePlayer1.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer1"];
    
    self.lblPlayer2.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player2"];
    self.lblScorePlayer2.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer2"];
    
    self.lblPlayer3.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player3"];
    self.lblScorePlayer3.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer3"];
    
    self.lblPlayer4.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player4"];
    self.lblScorePlayer4.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer4"];
    
    self.lblPlayer5.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player5"];
    self.lblScorePlayer5.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer5"];
    
    self.lblPlayer6.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player6"];
    self.lblScorePlayer6.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer6"];
    
    self.lblPlayer7.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player7"];
    self.lblScorePlayer7.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer7"];
    
    self.lblPlayer8.text      = [[NSUserDefaults standardUserDefaults] objectForKey:@"player8"];
    self.lblScorePlayer8.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"scorePlayer8"];
    
    self.lblPlayer9.hidden      = YES;
    self.lblScorePlayer9.hidden = YES;
    
    self.lblPlayer10.hidden      = YES;
    self.lblScorePlayer10.hidden = YES;
    
    self.lblPlayer11.hidden      = YES;
    self.lblScorePlayer11.hidden = YES;
    
    self.lblPlayer12.hidden      = YES;
    self.lblScorePlayer12.hidden = YES;
}

- (void) updateScores {
    [self updateRanking:0  withName:self.lblPlayer1  andScore:self.lblScorePlayer1];
    [self updateRanking:1  withName:self.lblPlayer2  andScore:self.lblScorePlayer2];
    [self updateRanking:2  withName:self.lblPlayer3  andScore:self.lblScorePlayer3];
    [self updateRanking:3  withName:self.lblPlayer4  andScore:self.lblScorePlayer4];
    [self updateRanking:4  withName:self.lblPlayer5  andScore:self.lblScorePlayer5];
    [self updateRanking:5  withName:self.lblPlayer6  andScore:self.lblScorePlayer6];
    [self updateRanking:6  withName:self.lblPlayer7  andScore:self.lblScorePlayer7];
    [self updateRanking:7  withName:self.lblPlayer8  andScore:self.lblScorePlayer8];
    [self updateRanking:8  withName:self.lblPlayer9  andScore:self.lblScorePlayer9];
    [self updateRanking:9  withName:self.lblPlayer10 andScore:self.lblScorePlayer10];
    [self updateRanking:10 withName:self.lblPlayer11 andScore:self.lblScorePlayer11];
    [self updateRanking:11 withName:self.lblPlayer12 andScore:self.lblScorePlayer12];
}

- (PFObject *) getScore:(int) index {
    @try {
        return [self.bestScores objectAtIndex:index];
    }
    @catch (NSException * e) {
        return nil;
    }
}

- (void) updateRanking:(int)index
              withName:(UILabel *)name
              andScore:(UILabel *)score {

    PFObject *player = [self getScore:index];
    
    if(player) {
        name.text  = player[@"name"];
        score.text = [NSString stringWithFormat:@"%@", player[@"score"]];
        
        if(score >=0 && index <= 7) {
            [[NSUserDefaults standardUserDefaults] setObject:name.text  forKey:[@"player" stringByAppendingFormat:@"%d", index+1]];
            [[NSUserDefaults standardUserDefaults] setObject:score.text forKey:[@"scorePlayer" stringByAppendingFormat:@"%d", index+1]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
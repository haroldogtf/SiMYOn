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

@implementation BestScoresViewController {
    NSArray *bestScores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateScoresWithLocalScores];
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSelectorInBackground:@selector(updateBestScores) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateBestScores {
    if([Util hasInternetConnection]) {
        [self updateScoresFromParse];
    } else {
        self.imgBackground.image = [UIImage imageNamed:@"best_scores_no_connection"];
        self.indicatorLoading.hidden = YES;
    }
}

- (void) updateScoresFromParse {
    
    [Ranking getScoresFromParse:^(NSArray *scores, NSError *error) {
        self.indicatorLoading.hidden = YES;
        
        if(error) {
            self.imgBackground.image = [UIImage imageNamed:@"best_scores_no_connection"];
        } else {
            bestScores = scores;
            self.imgBackground.image = [UIImage imageNamed:@"best_scores"];
            [self updateScoresInView];
        }
    }];
}

- (void) updateScoresWithLocalScores {
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
}

- (void) updateScoresInView {
    [self updateScoreInViewWithIndex:0  labelName:self.lblPlayer1  andLabelScore:self.lblScorePlayer1];
    [self updateScoreInViewWithIndex:1  labelName:self.lblPlayer2  andLabelScore:self.lblScorePlayer2];
    [self updateScoreInViewWithIndex:2  labelName:self.lblPlayer3  andLabelScore:self.lblScorePlayer3];
    [self updateScoreInViewWithIndex:3  labelName:self.lblPlayer4  andLabelScore:self.lblScorePlayer4];
    [self updateScoreInViewWithIndex:4  labelName:self.lblPlayer5  andLabelScore:self.lblScorePlayer5];
    [self updateScoreInViewWithIndex:5  labelName:self.lblPlayer6  andLabelScore:self.lblScorePlayer6];
    [self updateScoreInViewWithIndex:6  labelName:self.lblPlayer7  andLabelScore:self.lblScorePlayer7];
    [self updateScoreInViewWithIndex:7  labelName:self.lblPlayer8  andLabelScore:self.lblScorePlayer8];
    [self updateScoreInViewWithIndex:8  labelName:self.lblPlayer9  andLabelScore:self.lblScorePlayer9];
    [self updateScoreInViewWithIndex:9  labelName:self.lblPlayer10 andLabelScore:self.lblScorePlayer10];
    [self updateScoreInViewWithIndex:10 labelName:self.lblPlayer11 andLabelScore:self.lblScorePlayer11];
    [self updateScoreInViewWithIndex:11 labelName:self.lblPlayer12 andLabelScore:self.lblScorePlayer12];
}

- (PFObject *) getScore:(int) index {
    @try {
        return [bestScores objectAtIndex:index];
    }
    @catch (NSException * e) {
        return nil;
    }
}

- (void) updateScoreInViewWithIndex:(int)index
              labelName:(UILabel *)name
              andLabelScore:(UILabel *)score {

    PFObject *player = [self getScore:index];
    
    if(player) {
        name.text  = player[@"name"];
        score.text = [NSString stringWithFormat:@"%@", player[@"score"]];
        
        if(score >=0 && index <= 7) {
            [[NSUserDefaults standardUserDefaults] setObject:name.text  forKey:[@"player" stringByAppendingFormat:@"%d", index+1]];
            [[NSUserDefaults standardUserDefaults] setObject:score.text forKey:[@"scorePlayer" stringByAppendingFormat:@"%d", index+1]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        self.lblPlayer9.hidden      = NO;
        self.lblScorePlayer9.hidden = NO;
        
        self.lblPlayer10.hidden      = NO;
        self.lblScorePlayer10.hidden = NO;
        
        self.lblPlayer11.hidden      = NO;
        self.lblScorePlayer11.hidden = NO;
        
        self.lblPlayer12.hidden      = NO;
        self.lblScorePlayer12.hidden = NO;
    } else {
        name.text  = @"Player";
        score.text = @"0";
    }
}

@end
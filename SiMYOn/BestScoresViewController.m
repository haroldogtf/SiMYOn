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
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
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
    
    [self getBestScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getBestScores {
    
    PFQuery *query = [PFQuery queryWithClassName:@"ranking"];
    [query addDescendingOrder:@"score"];
    [query addAscendingOrder:@"createdAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {

        [self updateRanking:[results objectAtIndex:0]
                   withName:self.lblPlayer1
                   andScore:self.lblScorePlayer1];
        
        [self updateRanking:[results objectAtIndex:1]
                   withName:self.lblPlayer2
                   andScore:self.lblScorePlayer2];
        
        [self updateRanking:[results objectAtIndex:2]
                   withName:self.lblPlayer3
                   andScore:self.lblScorePlayer3];
        
        [self updateRanking:[results objectAtIndex:3]
                   withName:self.lblPlayer4
                   andScore:self.lblScorePlayer4];
        
        [self updateRanking:[results objectAtIndex:4]
                   withName:self.lblPlayer5
                   andScore:self.lblScorePlayer5];
        
        [self updateRanking:[results objectAtIndex:5]
                   withName:self.lblPlayer6
                   andScore:self.lblScorePlayer6];

    }];
}

- (void) updateRanking:(PFObject *)player
              withName:(UILabel *)name
              andScore:(UILabel *)score {
    
    name.text  = player[@"name"];
    score.text = [NSString stringWithFormat:@"%@", player[@"score"]];
    
}

@end
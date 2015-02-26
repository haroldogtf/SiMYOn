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

        for (PFObject *object in results) {
            NSLog(@"Score: %@ - Nome: %@", object[@"score"], object[@"name"]);
        }
    }];
}

@end
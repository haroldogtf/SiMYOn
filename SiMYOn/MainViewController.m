//
//  MainViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [self getBestScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) openViewController:(UIViewController *) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) getBestScores {
    PFQuery *query = [PFQuery queryWithClassName:@"ranking"];
    [query addDescendingOrder:@"score"];
    [query addAscendingOrder:@"createdAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.bestScores = results;
    }];
}

- (IBAction)gameStarterAction:(id)sender {
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self openViewController:[[SyncViewController alloc]init]];
    } else {
        [self openViewController:[[GameViewController alloc]init]];
    }
}

- (IBAction)intructionsAction:(id)sender {
    [self openViewController:[[InstructionsViewController alloc]init]];
}

- (IBAction)bestScoresAction:(id)sender {
    BestScoresViewController *bestScoresViewController = [[BestScoresViewController alloc]init];
    bestScoresViewController.bestScores = self.bestScores;
    [self openViewController:bestScoresViewController];
}

- (IBAction)creditsAction:(id)sender {
    [self openViewController:[[CreditsViewController alloc]init]];
}

- (IBAction)exitAction:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"SiMYOn"
                                                      message:@"Are you sure to exit the game?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex
{
    if(buttonIndex) {
        exit(0);
    }
}

@end
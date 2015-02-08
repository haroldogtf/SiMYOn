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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)gameStarterAction:(id)sender {
    self.gameViewController = [[GameViewController alloc]init];
    [self presentModalViewController:self.gameViewController animated:YES];
}

- (IBAction)intructionsAction:(id)sender {
}

- (IBAction)bestScoresAction:(id)sender {
}

- (IBAction)creditsAction:(id)sender {
}

- (IBAction)exitAction:(id)sender {
}

@end
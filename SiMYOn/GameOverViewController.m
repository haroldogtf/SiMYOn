//
//  GameOverViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 21/02/15.
//
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblFinalScore.text = [NSString stringWithFormat:@"%d", (int)self.score];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
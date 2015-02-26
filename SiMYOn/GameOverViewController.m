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

- (IBAction)saveScore:(id)sender {
    
//    PFObject *ranking = [PFObject objectWithClassName:@"ranking"];
//    ranking[@"name"] = @"name";
//    ranking[@"score"] = [[NSNumber alloc] initWithInteger:[self.lblFinalScore.text integerValue]];
//    [ranking saveInBackground];
    
  
}

- (IBAction)logoutAction:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)returnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSLog(@"nome: %@", user.name);
}

@end
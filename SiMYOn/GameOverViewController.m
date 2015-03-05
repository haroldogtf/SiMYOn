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

@implementation GameOverViewController {
    BOOL isSavedRanking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateScore];
    [self showLoginLogoutButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginAction:(id)sender {
    
    if([self hasInternetConnection]) {
        [self facebookLogin];
    } else {
        // TODO
        NSLog(@"No Internet Connection");
    }
}

- (IBAction)logoutAction:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    self.lblPlayerName.hidden = YES;
    self.lblPlayerName.text = @"";
    self.imgPlayerName.hidden = YES;
    self.lblConnectToFacebook.hidden = NO;
    [self showLoginLogoutButtons];
}

- (IBAction)returnAction:(id)sender {
     if (FBSession.activeSession.isOpen) {
         [self saveScoreInParse];
     }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) updateScore {
    self.lblFinalScore.text = [NSString stringWithFormat:@"%d", (int)self.score];
}

- (void) showLoginLogoutButtons {
    self.btnLogin.hidden  = FBSession.activeSession.isOpen;
    self.btnLogout.hidden = !FBSession.activeSession.isOpen;
}

- (void) facebookLogin {
    if (FBSession.activeSession.isOpen) {
        [self getNameInFacebook];
    } else {
        FBSession.activeSession=nil;
        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorForcingWebView
                                completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                    if(!error) {
                                        [self getNameInFacebook];
                                    }
                                }
         ];
    }
}

- (void) getNameInFacebook {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [self showLoginLogoutButtons];
                 self.lblPlayerName.text = user.name;
                 self.lblPlayerName.hidden = NO;
                 self.imgPlayerName.hidden = NO;
                 self.lblConnectToFacebook.hidden = YES;
             }
         }];
    }
}

- (void) saveScoreInParse {
    PFObject *ranking = [PFObject objectWithClassName:@"ranking"];
    ranking[@"name"] = self.lblPlayerName.text;
    ranking[@"score"] = [[NSNumber alloc] initWithInteger:[self.lblFinalScore.text integerValue]];
    ranking[@"using_myo"] = [NSNumber numberWithBool:self.usingMyo];
    
    [ranking saveInBackground];
}

- (BOOL) hasInternetConnection {
    NSURL *url = [NSURL URLWithString:@"http://www.parse.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

@end
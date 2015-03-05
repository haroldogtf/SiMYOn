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
    [self showLogoutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginAction:(id)sender {
    
    if (FBSession.activeSession.isOpen) {
        [self getNameInFacebook];
    } else {
        FBSession.activeSession=nil;
        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorForcingWebView
                                completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                    if(!error) {
                                        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                                            NSLog(@"OK");
                                        }
                                    } else {
                                        [self getNameInFacebook];
                                    }
                                }
         ];
    }
}

- (IBAction)logoutAction:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [self showLogoutButton];
}

- (IBAction)returnAction:(id)sender {
     if (!FBSession.activeSession.isOpen) {
         [self saveScoreInParse];
     }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) updateScore {
    self.lblFinalScore.text = [NSString stringWithFormat:@"%d", (int)self.score];
}

- (void) showLogoutButton {
    self.btnLogout.hidden = !FBSession.activeSession.isOpen;
}

- (void) getNameInFacebook {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [self showLogoutButton];
                 self.lblPlayerName.text = user.name;
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

@end
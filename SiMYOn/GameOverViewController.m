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
    
    if (!FBSession.activeSession.isOpen) {
        FBSession.activeSession=nil;
        
        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorForcingWebView
                                completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                    if(!error) {
                                        [self getNameInFacebookAndStoreRankingInParse];
                                    }
                                }
         ];
    } else {
        [self getNameInFacebookAndStoreRankingInParse];
    }
}

- (IBAction)logoutAction:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)returnAction:(id)sender {
    [self goBackToMenu];
}

- (void) goBackToMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) getNameInFacebookAndStoreRankingInParse {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [self storeScoreInParse:user.name];
                 [self goBackToMenu];
             }
         }];
    }
}

- (void) storeScoreInParse:(NSString *) name {
        PFObject *ranking = [PFObject objectWithClassName:@"ranking"];
        ranking[@"name"] = name;
        ranking[@"score"] = [[NSNumber alloc] initWithInteger:[self.lblFinalScore.text integerValue]];
        [ranking saveInBackground];
}

@end
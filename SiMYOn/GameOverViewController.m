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
    [self configurePlayerName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) configurePlayerName {
    if (FBSession.activeSession.isOpen) {
        self.lblPlayerName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"playerName"];
        self.imgPlayerName.hidden = NO;
        self.lblConnectToFacebook.hidden = YES;
    }
}

- (IBAction)loginAction:(id)sender {
    
    if([Util hasInternetConnection]) {
        [self facebookLogin];
    } else {
        self.imgNoConnectionPopup.hidden = NO;
        self.btnLogin.enabled = NO;
        
        CATransition* inAnimation = [CATransition animation];
        [inAnimation setType:kCATransitionPush];
        [inAnimation setSubtype:kCATransitionFromBottom];
        [inAnimation setDuration:.35];
        [inAnimation setDelegate:self];
        [inAnimation setValue:@"inAnimation" forKey:@"inAnimation"];
        [[self.imgNoConnectionPopup layer] addAnimation:inAnimation forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    NSString* value = [theAnimation valueForKey:@"inAnimation"];
    if ([value isEqualToString:@"inAnimation"])
    {
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(removeNoInternetConnectionPopup)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        self.btnLogin.enabled = YES;
    }
}

- (void) removeNoInternetConnectionPopup {
    self.imgNoConnectionPopup.hidden = YES;

    CATransition* outAnimation = [CATransition animation];
    [outAnimation setType:kCATransitionReveal];
    [outAnimation setSubtype:kCATransitionFromTop];
    [outAnimation setDuration:.35];
    [outAnimation setDelegate:self];
    [[self.imgNoConnectionPopup layer] addAnimation:outAnimation forKey:nil];
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
                 
                 [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"playerName"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
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
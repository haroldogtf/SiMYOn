//
//  GameOverViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 21/02/15.
//
//

#import "GameOverViewController.h"
#import "Constants.h"
#import "Util.h"
#import "Ranking.h"
#import "GameOverViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface GameOverViewController ()

    @property (weak, nonatomic) IBOutlet UIButton    *btnLogin;
    @property (weak, nonatomic) IBOutlet UIButton    *btnLogout;

    @property (weak, nonatomic) IBOutlet UILabel     *lblConnectToFacebook;
    @property (weak, nonatomic) IBOutlet UILabel     *lblFinalScore;
    @property (weak, nonatomic) IBOutlet UILabel     *lblPlayerName;

    @property (weak, nonatomic) IBOutlet UIImageView *imgPlayerName;
    @property (weak, nonatomic) IBOutlet UIImageView *imgNoConnectionPopup;

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
        self.lblPlayerName.text = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_NAME];
        self.imgPlayerName.hidden = NO;
        self.lblConnectToFacebook.hidden = YES;
    }
}

- (IBAction)loginAction:(id)sender {
    [Util hasInternetConnection] ? [self facebookLogin]
                                 : [self noConnetionPopupAnimation];
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
         [self saveScores];
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
                 
                 [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:PLAYER_NAME];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }];
    }
}

- (void) saveScores {
    [Ranking saveScoresInParseWithName:self.lblPlayerName.text
                                 score:[[NSNumber alloc] initWithInteger:[self.lblFinalScore.text integerValue]]
                           andUsingMyo:self.usingMyo
     ];
}

- (void)noConnetionPopupAnimation {
    self.imgNoConnectionPopup.hidden = NO;
    self.btnLogin.enabled = NO;
    
    CATransition* inAnimation = [CATransition animation];
    [inAnimation setType:kCATransitionPush];
    [inAnimation setSubtype:kCATransitionFromBottom];
    [inAnimation setDuration:ANIMATION_TIME];
    [inAnimation setDelegate:self];
    [inAnimation setValue:IN_ANIMATION forKey:IN_ANIMATION];
    [[self.imgNoConnectionPopup layer] addAnimation:inAnimation forKey:nil];
}

- (void) removeNoInternetConnectionPopupAnimation {
    self.imgNoConnectionPopup.hidden = YES;
    
    CATransition* outAnimation = [CATransition animation];
    [outAnimation setType:kCATransitionReveal];
    [outAnimation setSubtype:kCATransitionFromTop];
    [outAnimation setDuration:ANIMATION_TIME];
    [outAnimation setDelegate:self];
    [[self.imgNoConnectionPopup layer] addAnimation:outAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    NSString* value = [theAnimation valueForKey:IN_ANIMATION];
    if ([value isEqualToString:IN_ANIMATION])
    {
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(removeNoInternetConnectionPopupAnimation)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        self.btnLogin.enabled = YES;
    }
}

@end
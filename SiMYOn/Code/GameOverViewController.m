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
#import "Facebook.h"
#import "MBProgressHUD.h"

@interface GameOverViewController ()

    @property (weak, nonatomic) IBOutlet UIButton    *btnLogin;
    @property (weak, nonatomic) IBOutlet UIButton    *btnLogout;

    @property (weak, nonatomic) IBOutlet UILabel     *lblConnectToFacebook;
    @property (weak, nonatomic) IBOutlet UILabel     *lblFinalScore;
    @property (weak, nonatomic) IBOutlet UILabel     *lblPlayerName;

    @property (weak, nonatomic) IBOutlet UIImageView *imgPlayerName;
    @property (weak, nonatomic) IBOutlet UIImageView *imgNoConnectionPopup;

    @property (strong, nonatomic)        UIAlertView *alert;

@end

@implementation GameOverViewController

- (id)init {    
    return [super initWithNibName:[Util selectNibNameByModel:NIB_GAMEOVER]
                           bundle:nil];
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
    if ([Facebook hasActiveSession]) {
        self.lblPlayerName.text = [[NSUserDefaults standardUserDefaults] objectForKey:PLAYER_NAME];
        self.imgPlayerName.hidden = NO;
        self.lblConnectToFacebook.hidden = YES;
    }
}

- (IBAction)loginAction:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = LOADING;
    
    __weak typeof(self) this = self;
    __block BOOL hasInternet;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        hasInternet = [Util hasInternetConnection];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            hasInternet ? [this facebookLogin]
                        : [this noConnetionPopupAnimation];
            [MBProgressHUD hideHUDForView:this.view animated:YES];
        });
    });
}

- (IBAction)logoutAction:(id)sender {
    [Facebook logout];
    
    self.lblPlayerName.hidden = YES;
    self.lblPlayerName.text = @"";
    self.imgPlayerName.hidden = YES;
    self.lblConnectToFacebook.hidden = NO;
    [self showLoginLogoutButtons];
}

- (IBAction)returnAction:(id)sender {
     if ([Facebook hasActiveSession]) {
         [self saveScores];
     }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) updateScore {
    self.lblFinalScore.text = [NSString stringWithFormat:@"%d", (int)self.score];
}

- (void) showLoginLogoutButtons {
    self.btnLogin.hidden  = [Facebook hasActiveSession];
    self.btnLogout.hidden = ![Facebook hasActiveSession];
}

- (void) facebookLogin {
    
    if ([Facebook hasActiveSession]) {
        [self getNameInFacebook];
    } else {
        
        __weak typeof(self) this = self;
        [Facebook login:self withBlock:^(BOOL logged, NSError *error) {
            if(error.code == FACEBOOK_ACCESS_DENIED) {
                self.alert = [[UIAlertView alloc] initWithTitle:SIMYON
                                                        message:PERMISSION_ALERT
                                                       delegate:self
                                              cancelButtonTitle:STR_OK
                                              otherButtonTitles:nil];
                [self.alert show];
                                
            } else if(!error && logged) {
                [this getNameInFacebook];
            }
        }];
    }
}

- (void) getNameInFacebook {
    
    if ([Facebook hasActiveSession]) {
        
        __weak typeof(self) this = self;
        [Facebook getUserName:^(NSString *userName, NSError *error) {
            if (!error) {
                [this showLoginLogoutButtons];
                this.lblPlayerName.text = userName;
                this.lblPlayerName.hidden = NO;
                this.imgPlayerName.hidden = NO;
                this.lblConnectToFacebook.hidden = YES;

                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:PLAYER_NAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}

- (void) saveScores {
    
    NSNumber *score = [[NSNumber alloc] initWithInteger:[self.lblFinalScore.text integerValue]];
    
    [Ranking saveScoresInParseWithName:self.lblPlayerName.text
                                 score:score
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
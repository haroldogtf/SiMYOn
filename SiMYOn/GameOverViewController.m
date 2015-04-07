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

- (id)init {
    NSString *nibName = [self selectNibNameByModel:[Util getIphoneModel]];
    
    return [super initWithNibName:nibName bundle:nil];
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

- (NSString *) selectNibNameByModel:(IPhoneModel) iPhoneModel {
    
    switch (iPhoneModel) {
        case IPHONE_5_5C_5S_MODEL:       return NIB_GAMEOVER_IPHONE_5_5C_5S;       break;
        case IPHONE_6_MODEL:             return NIB_GAMEOVER_IPHONE_6;             break;
        case IPHONE_6_PLUS_MODEL:        return NIB_GAMEOVER_IPHONE_6_PLUS;        break;
        case IPHONE_NOT_SUPPORTED_MODEL:
        default:                         return NIB_NOT_SUPPORTED; break;
    }
}

- (IBAction)loginAction:(id)sender {
    [Util hasInternetConnection] ? [self facebookLogin]
                                 : [self noConnetionPopupAnimation];
}

- (IBAction)logoutAction:(id)sender {
    [Facebook closeSession];
    
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
        [Facebook setNilInSection];
        [Facebook login:^(NSError *error) {
            if(!error) {
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
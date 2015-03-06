//
//  GameOverViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 21/02/15.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "GameOverViewController.h"

@interface GameOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton    *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton    *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel     *lblConnectToFacebook;
@property (weak, nonatomic) IBOutlet UILabel     *lblFinalScore;
@property (weak, nonatomic) IBOutlet UILabel     *lblPlayerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlayerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoConnectionPopup;
@property (nonatomic)                NSInteger    score;
@property (nonatomic)                BOOL         usingMyo;

- (IBAction)loginAction: (id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)returnAction:(id)sender;

@end
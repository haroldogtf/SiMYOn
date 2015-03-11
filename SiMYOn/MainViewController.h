//
//  MainViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>
#import "Constants.h"
#import "SyncViewController.h"
#import "InstructionsViewController.h"
#import "BestScoresViewController.h"
#import "CreditsViewController.h"

@interface MainViewController : UIViewController

@property (nonatomic)                NSArray  *bestScores;
@property (weak, nonatomic) IBOutlet UIButton *btnSound;

- (IBAction)gameStarterAction:(id)sender;
- (IBAction)intructionsAction:(id)sender;
- (IBAction)bestScoresAction: (id)sender;
- (IBAction)creditsAction:    (id)sender;
- (IBAction)soundAction:      (id)sender;

@end
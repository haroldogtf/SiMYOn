//
//  MainViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>
#import <Parse/Parse.h>
#import "SyncViewController.h"
#import "InstructionsViewController.h"
#import "BestScoresViewController.h"
#import "CreditsViewController.h"

@interface MainViewController : UIViewController

@property (nonatomic) NSArray *bestScores;

- (IBAction)gameStarterAction:(id)sender;
- (IBAction)intructionsAction:(id)sender;
- (IBAction)bestScoresAction: (id)sender;
- (IBAction)creditsAction:    (id)sender;
- (IBAction)exitAction:       (id)sender;

@end
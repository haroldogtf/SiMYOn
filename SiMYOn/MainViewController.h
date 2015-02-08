//
//  MainViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>
#import "GameViewController.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) GameViewController *gameViewController;

- (IBAction)gameStarterAction:(id)sender;
- (IBAction)intructionsAction:(id)sender;
- (IBAction)bestScoresAction: (id)sender;
- (IBAction)creditsAction:    (id)sender;
- (IBAction)exitAction:       (id)sender;

@end
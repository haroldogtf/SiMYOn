//
//  MainViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) GameViewController *gameViewController;

- (IBAction)gameStarterClick:(id)sender;

@end
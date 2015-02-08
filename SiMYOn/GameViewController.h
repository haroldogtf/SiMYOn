//
//  GameViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <MyoKit/MyoKit.h>

@interface GameViewController : UIViewController

- (IBAction)btnTopAction:   (id)sender;
- (IBAction)btnBottomAction:(id)sender;
- (IBAction)btnLeftAction:  (id)sender;
- (IBAction)btnRightAction: (id)sender;

- (IBAction)pauseContinueAction:(id)sender;
- (IBAction)returnAction:(id)sender;

@end
//
//  GameViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <stdlib.h>
#import <MyoKit/MyoKit.h>
#import "GameOverViewController.h"

@interface GameViewController : UIViewController

typedef enum {
    TopMovement    = 0,
    LeftMovement   = 1,
    RightMovement  = 2,
    BottomMovement = 3
} Movement;

@property (strong, nonatomic) IBOutlet UIView      *view;
@property (weak, nonatomic)   IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic)   IBOutlet UILabel     *lblCount;
@property (weak, nonatomic)   IBOutlet UIButton    *btnPauseContinue;
@property (weak, nonatomic)   IBOutlet UIButton    *btnTop;
@property (weak, nonatomic)   IBOutlet UIButton    *btnLeft;
@property (weak, nonatomic)   IBOutlet UIButton    *btnRight;
@property (weak, nonatomic)   IBOutlet UIButton    *btnBottom;

- (IBAction)btnTopAction:       (id)sender;
- (IBAction)btnLeftAction:      (id)sender;
- (IBAction)btnRightAction:     (id)sender;
- (IBAction)btnBottomAction:    (id)sender;
- (IBAction)pauseContinueAction:(id)sender;
- (IBAction)returnAction:       (id)sender;

@end
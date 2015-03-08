//
//  GameViewController.h
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <stdlib.h>
#import <MyoKit/MyoKit.h>
#import "Constants.h"
#import "GameOverViewController.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView      *view;
@property (weak, nonatomic)   IBOutlet UIImageView *imgPopupLostSync;
@property (weak, nonatomic)   IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic)   IBOutlet UIImageView *imgReady;
@property (weak, nonatomic)   IBOutlet UIImageView *imgGo;
@property (weak, nonatomic)   IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic)   IBOutlet UIImageView *imgGood;
@property (weak, nonatomic)   IBOutlet UIImageView *imgMiss;
@property (weak, nonatomic)   IBOutlet UILabel     *lblCount;
@property (weak, nonatomic)   IBOutlet UIButton    *btnPauseContinue;
@property (weak, nonatomic)   IBOutlet UIButton    *btnTop;
@property (weak, nonatomic)   IBOutlet UIButton    *btnLeft;
@property (weak, nonatomic)   IBOutlet UIButton    *btnRight;
@property (weak, nonatomic)   IBOutlet UIButton    *btnBottom;
@property (nonatomic)                  BOOL        isLeftArm;
@property (nonatomic)                  BOOL        useMyo;
@property (nonatomic)                  BOOL        playSound;

- (id)initIsPlaySound:(BOOL)isPlaySound andUseMyo:(BOOL)useMyo;

- (IBAction)btnTopAction:       (id)sender;
- (IBAction)btnLeftAction:      (id)sender;
- (IBAction)btnRightAction:     (id)sender;
- (IBAction)btnBottomAction:    (id)sender;
- (IBAction)returnAction:       (id)sender;

@end
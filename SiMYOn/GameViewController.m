//
//  GameViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController {
    AVAudioPlayer* audio;
    NSMutableArray* movementsList;
    BOOL lock;
    NSInteger turn;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    movementsList = [[NSMutableArray alloc]init];
    turn = 0;
    [self blockAllComponents:YES];
    [self prepareMyoForNotifications];
}

- (void) viewDidAppear:(BOOL)animated
{
    //[self ConfigureMyoIfDisconneted];
    
    [self playGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Myo
- (void) configureMyo {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) ConfigureMyoIfDisconneted {
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self configureMyo];
    }
}

- (void) prepareMyoForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];
}

- (void)didReceivePoseChange:(NSNotification*)notification {
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    
    if(!lock) {
        switch (pose.type) {
            case TLMPoseTypeFingersSpread:
                [self topAction];
                break;
            case TLMPoseTypeFist:
                [self bottomAction];
                break;
            case TLMPoseTypeWaveIn:
                [self leftAction];
                break;
            case TLMPoseTypeWaveOut:
                [self rightAction];
                break;
            default:
                break;
        }
    }
    
    [pose.myo unlockWithType:TLMUnlockTypeHold];
}

- (void)didDisconnectDevice:(NSNotification*)notification {
    [self configureMyo];
}

- (void)didUnsyncArm:(NSNotification*)notification {
    NSLog(@"unsync");
}

#pragma mark - Actions
- (void) changeImage:(NSString *)imageName
           andPlaySound:(NSString *)music {
    
    lock = YES;
    self.imgBackground.image = [UIImage imageNamed:imageName];
    [self.imgBackground setNeedsDisplay];
    [self playSound:music];
    [self cleanAction];
}

- (void) cleanAction {
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(unlockTheGame:) userInfo:nil repeats:NO];
}

- (IBAction)btnTopAction:(id)sender {
    [self topAction];
}

- (IBAction)btnLeftAction:(id)sender {
    [self leftAction];
}

- (IBAction)btnRightAction:(id)sender {
    [self rightAction];
}

- (IBAction)btnBottomAction:(id)sender {
    [self bottomAction];
}

- (IBAction)pauseContinueAction:(id)sender {
}

- (IBAction)returnAction:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"SiMYOn"
                                                      message:@"Are you sure to go back to menu?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex
{
    if(buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) playSound:(NSString*) music {
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], music];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [audio play];
}

#pragma mark - Game
- (void) topAction {
    [self generalAction:TopMovement];
    [self changeImage:@"game_top.png"
                 andPlaySound:@"blip1.mp3"];
    NSLog(@"spread");
}

- (void) leftAction {
    [self generalAction:LeftMovement];
    [self changeImage:@"game_left.png"
                 andPlaySound:@"blip2.mp3"];
    NSLog(@"left");
}

- (void) rightAction {
    [self generalAction:RightMovement];
    [self changeImage:@"game_right.png"
                 andPlaySound:@"blip3.mp3"];
    NSLog(@"right");
}

- (void) bottomAction {
    [self generalAction:BottomMovement];
    [self changeImage:@"game_bottom.png"
                 andPlaySound:@"blip4.mp3"];
    NSLog(@"first");
}

- (void) generalAction:(Movement) movement {
    if(!lock) {
        
        if([self getMovement:(int)[movementsList objectAtIndex:turn]] == (int)movement) {
            NSLog(@"ok");
            turn++;
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
            turn = 0;
        }
        
        if(turn >= [movementsList count]) {
            [self blockAllComponents:YES];
            [self playGame];
            turn = 0;
        }
    }
}

- (void)unlockTheGame:(id)sender {
    self.imgBackground.image = [UIImage imageNamed:@"game.png"];
    [self blockAllComponents:NO];
}

- (void) blockAllComponents:(BOOL) enable {
    lock = enable;
    self.btnTop.enabled    = !enable;
    self.btnLeft.enabled   = !enable;
    self.btnRight.enabled  = !enable;
    self.btnBottom.enabled = !enable;
}

- (void) playGame {
    [self moreOneMovement];
    [self playMovements];
}

- (Movement) getRandomMovement {
    return [self getMovement:arc4random_uniform(4)];
}

- (Movement) getMovement:(NSInteger) movement {
    switch (movement) {
        case 0:
            return TopMovement;
            break;
        case 1:
            return LeftMovement;
            break;
        case 2:
            return RightMovement;
            break;
        case 3:
        default:
            return BottomMovement;
            break;
    }
}

- (void) doMovement:(Movement) movement {
    switch (movement) {
        case TopMovement:
            [self topAction];
            break;
        case LeftMovement:
            [self leftAction];
            break;
        case RightMovement:
            [self rightAction];
            break;
        case BottomMovement:
        default:
            [self bottomAction];
            break;
    }
}

- (void) moreOneMovement {
    [movementsList addObject:[NSNumber numberWithInt:[self getRandomMovement]]];
}

- (void) playMovements {
    for(NSObject* movement in movementsList) {
        //[NSThread sleepForTimeInterval:1];
        [self doMovement:[self getMovement:(int)movement]];
    }
}

@end
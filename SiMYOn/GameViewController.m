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
   // [self ConfigureMyoIfDisconneted];
    
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
                [self topAction:NO];
                break;
            case TLMPoseTypeFist:
                [self bottomAction:NO];
                break;
            case TLMPoseTypeWaveIn:
                [self leftAction:NO];
                break;
            case TLMPoseTypeWaveOut:
                [self rightAction:NO];
                break;
            default:
                break;
        }
    }
    
    [pose.myo unlockWithType:TLMUnlockTypeHold];
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    [self configureMyo];
}

- (void)didUnsyncArm:(NSNotification *)notification {
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
    [NSTimer scheduledTimerWithTimeInterval:.5
                                     target:self
                                   selector:@selector(unlockTheGame:)
                                   userInfo:nil
                                    repeats:NO];
}

- (IBAction)btnTopAction:(id)sender {
    [self topAction:NO];
}

- (IBAction)btnLeftAction:(id)sender {
    [self leftAction:NO];
}

- (IBAction)btnRightAction:(id)sender {
    [self rightAction:NO];
}

- (IBAction)btnBottomAction:(id)sender {
    [self bottomAction:NO];
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
- (void) topAction:(BOOL)automatic {
    [self changeImage:@"game_top.png"
                 andPlaySound:@"blip1.mp3"];
    
    if(!automatic) {
        [self generalAction:TopMovement];
        [self blockAllComponents:NO];
    }
}

- (void) leftAction:(BOOL)automatic {
    [self changeImage:@"game_left.png"
                 andPlaySound:@"blip2.mp3"];

    if(!automatic) {
        [self generalAction:LeftMovement];
        [self blockAllComponents:NO];
    }
}

- (void) rightAction:(BOOL)automatic {
    [self changeImage:@"game_right.png"
                 andPlaySound:@"blip3.mp3"];

    if(!automatic) {
        [self generalAction:RightMovement];
        [self blockAllComponents:NO];
    }
}

- (void) bottomAction:(BOOL)automatic {
    [self changeImage:@"game_bottom.png"
                 andPlaySound:@"blip4.mp3"];

    if(!automatic) {
        [self generalAction:BottomMovement];
        [self blockAllComponents:NO];
    }
}

- (void) generalAction:(Movement) movement {
    NSInteger number = [[movementsList objectAtIndex:turn] integerValue];
    Movement turnMoviment = [self getMovement:(int)number];
    
    turn++;
    
    if(turnMoviment == movement) {
        NSLog(@"turnMoviment==movement %d", (int)turn);
        
        if(turn >= [movementsList count]) {
            [self blockAllComponents:YES];
            
            [NSTimer scheduledTimerWithTimeInterval:.25
                                             target:self
                                           selector:@selector(playGame)
                                           userInfo:nil
                                            repeats:NO];
            turn = 0;
        }
        
    } else {
        [self loseGame];
    }
}

- (void)unlockTheGame:(id)sender {
    self.imgBackground.image = [UIImage imageNamed:@"game.png"];
}

- (void) blockAllComponents:(BOOL)enable {
    lock = enable;
    self.btnTop.enabled    = !enable;
    self.btnLeft.enabled   = !enable;
    self.btnRight.enabled  = !enable;
    self.btnBottom.enabled = !enable;
}

- (int) getRandomMovement {
    int random = arc4random_uniform(400) % 4;
    NSLog(@"Random: %d", random);
    return random;
}

- (Movement) getMovement:(int)movement {
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
            [self topAction:YES];
            break;
        case LeftMovement:
            [self leftAction:YES];
            break;
        case RightMovement:
            [self rightAction:YES];
            break;
        case BottomMovement:
        default:
            [self bottomAction:YES];
            break;
    }
}

- (void) moreOneMovement {
    [movementsList addObject:[NSNumber numberWithInt:[self getRandomMovement]]];
}

- (void) playMovements {
    [self blockAllComponents:YES];
    [self playMovements:0];
}

- (void) playMovements:(int)turnMovement {
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(executeMovement:)
                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:turnMovement], @"turn",nil]
                                    repeats:NO];
}


- (void) executeMovement:(id)dictionary {
    NSInteger turnMovement = [(NSNumber *)[[dictionary userInfo] objectForKey:@"turn"] integerValue];
    NSInteger number = [[movementsList objectAtIndex:turnMovement] integerValue];
    Movement movement = [self getMovement:(int)number];
    
    [self doMovement:[self getMovement:(int)movement]];
    
    turnMovement++;
    
    if (turnMovement < [movementsList count]) {
        [self playMovements:(int)turnMovement];
    } else {
        [self blockAllComponents:NO];
    }
}

- (void) playGame {
    [self moreOneMovement];
    [self playMovements];
}

- (void) loseGame {
    movementsList = [[NSMutableArray alloc]init];
    turn = 0;
    [self presentViewController:[[GameOverViewController alloc]init] animated:YES completion:nil];
}

@end
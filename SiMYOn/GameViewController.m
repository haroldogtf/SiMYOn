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
    AVAudioPlayer  *audio;
    NSMutableArray *movementsList;
    BOOL            lock;
    NSInteger       turn;
}

- (id) initIsPlaySound:(BOOL)isPlaySound
             andUseMyo:(BOOL)useMyo {

    self = [super init];
    
    if(self) {
        self.playSound = isPlaySound;
        self.useMyo = useMyo;
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self didLoadGame];
}

- (void) viewDidAppear:(BOOL)animated
{    
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

- (void) configureMyoIfDisconneted {
    if([[TLMHub sharedHub] myoDevices].count == 0) {
        [self configureMyo];
    }
}

- (void)configureMyoObserver {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceivePoseChange:)
     name:TLMMyoDidReceivePoseChangedNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didDisconnectDevice:)
     name:TLMHubDidDisconnectDeviceNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didSyncArm:)
     name:TLMMyoDidReceiveArmSyncEventNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didUnsyncArm:)
     name:TLMMyoDidReceiveArmUnsyncEventNotification
     object:nil];
}

- (void) prepareMyoForNotifications {
    if(self.useMyo) {
        [self configureMyoObserver];
        self.isLeftArm = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LEFT_ARM];
    }
}

- (void)didReceivePoseChange:(NSNotification*)notification {
    if(self.useMyo) {

        TLMPose *pose = notification.userInfo[kTLMKeyPose];

        if(!lock) {
            switch (pose.type) {
                case TLMPoseTypeFingersSpread: [self topAction:NO];    break;
                case TLMPoseTypeFist:          [self bottomAction:NO]; break;
                case TLMPoseTypeWaveIn:        self.isLeftArm ? [self rightAction:NO]
                                                              :[self leftAction:NO];
                                               break;
                case TLMPoseTypeWaveOut:       self.isLeftArm ? [self leftAction:NO]
                                                              : [self rightAction:NO];
                                               break;
                default: break;
            }
        }
        
        [pose.myo unlockWithType:TLMUnlockTypeHold];
    }
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    if(self.useMyo) {
        [self configureMyo];
    }
}

- (void)didSyncArm:(NSNotification *)notification {
    TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
    self.isLeftArm = (armEvent.arm == TLMArmLeft);
    [[NSUserDefaults standardUserDefaults] setBool:self.isLeftArm forKey:IS_LEFT_ARM];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self syncAnimation];
}

- (void)didUnsyncArm:(NSNotification *)notification {
    if(self.useMyo) {
        [self unsyncAnimation];
    }
}

#pragma mark - Actions
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

- (IBAction)returnAction:(id)sender {
    if([self.lblCount.text integerValue] > 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:SIMYON
                                                          message:BACK_MENU_ALERT
                                                         delegate:self
                                                cancelButtonTitle:STR_NO
                                                otherButtonTitles:STR_YES, nil];
        [message show];
    } else {
        [self returnToMainMenu];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex
{
    if(buttonIndex) {
        [self returnToMainMenu];
    }
}

- (void) action:(BOOL)automatic andMovemet:(Movement) movement {
    if(!automatic) {
        [self makeMovementAction:movement];
        [self blockAllComponents:NO];
    }
}

- (void) topAction:(BOOL)automatic {
    [self changeImage:IMG_GAME_TOP andPlaySound:SOUND_TOP];
    [self action:automatic andMovemet:TopMovement];
}

- (void) leftAction:(BOOL)automatic {
    [self changeImage:IMG_GAME_LEFT andPlaySound:SOUND_LEFT];
    [self action:automatic andMovemet:LeftMovement];
}

- (void) rightAction:(BOOL)automatic {
    [self changeImage:IMG_GAME_RIGHT andPlaySound:SOUND_RIGHT];
    [self action:automatic andMovemet:RightMovement];
}

- (void) bottomAction:(BOOL)automatic {
    [self changeImage:IMG_GAME_BOTTOM andPlaySound:SOUND_BOTTOM];
    [self action:automatic andMovemet:BottomMovement];
}

- (void) makeMovementAction:(Movement) movement {
    NSInteger number;
    @try {
        number = [[movementsList objectAtIndex:turn] integerValue];
        Movement turnMoviment = [self getMovement:(int)number];
        turn++;
        
        (turnMoviment == movement) ? [self winTurn]
        :[self loseGame];
    }
    @catch (NSException *exception) {}
}

- (void) cleanAction {
    [NSTimer scheduledTimerWithTimeInterval:CLEAN_TIME
                                     target:self
                                   selector:@selector(unlockTheGame)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - Game
- (void)didLoadGame {
    movementsList = [[NSMutableArray alloc]init];
    turn = 0;
    [self blockAllComponents:YES];
    [self prepareMyoForNotifications];
}

- (void) changeImage:(NSString *)imageName
        andPlaySound:(NSString *)sound {
    
    lock = YES;
    self.imgBackground.image = [UIImage imageNamed:imageName];
    [self.imgBackground setNeedsDisplay];
    [self playSoundWithPath:sound];
    [self cleanAction];
}

-(void) returnToMainMenu {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) playSoundWithPath:(NSString*) sound {
    if(self.playSound) {
        NSURL *soundUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], sound]];
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audio play];
    }
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
    return random;
}

- (Movement) getMovement:(int)movement {
    switch (movement) {
        case 0:  return TopMovement;    break;
        case 1:  return LeftMovement;   break;
        case 2:  return RightMovement;  break;
        case 3:
        default: return BottomMovement; break;
    }
}

- (void) doMovement:(Movement) movement {
    switch (movement) {
        case TopMovement:    [self topAction:YES];    break;
        case LeftMovement:   [self leftAction:YES];   break;
        case RightMovement:  [self rightAction:YES];  break;
        case BottomMovement:
        default:             [self bottomAction:YES]; break;
    }
}

- (void) moreOneMovement {
    [movementsList addObject:[NSNumber numberWithInt:[self getRandomMovement]]];
}

- (void) playMovements {
    [self blockAllComponents:YES];
    [self playMovementsWithTurn:0];
}

- (void) playMovementsWithTurn:(int)turnMovement {
    [NSTimer scheduledTimerWithTimeInterval:MOVEMENT_TIME
                                     target:self
                                   selector:@selector(executeMovement:)
                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:turnMovement],
                                                                                        TURN,
                                                                                        nil]
                                    repeats:NO];
}


- (void) executeMovement:(id)dictionary {
    self.imgGood.hidden = YES;
    self.imgReady.hidden = NO;
    
    NSInteger turnMovement = [(NSNumber *)[[dictionary userInfo] objectForKey:TURN] integerValue];
    NSInteger number = [[movementsList objectAtIndex:turnMovement] integerValue];
    Movement movement = [self getMovement:(int)number];
    [self doMovement:[self getMovement:(int)movement]];
    turnMovement++;
    
    if (turnMovement < [movementsList count]) {
        [self playMovementsWithTurn:(int)turnMovement];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:MOVEMENT_TIME
                                         target:self
                                       selector:@selector(go)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void) go {
    self.imgReady.hidden = YES;
    self.imgGood.hidden = YES;
    self.imgGo.hidden = NO;
    [self blockAllComponents:NO];
    
    [self playSoundWithPath:SOUND_GO];
    [NSTimer scheduledTimerWithTimeInterval:GO_TIME
                                     target:self
                                   selector:@selector(cleanGo)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) cleanGo {
    self.imgGo.hidden = YES;
}

- (void)unlockTheGame {
    self.imgBackground.image = [UIImage imageNamed:IMG_GAME];
}

- (void) playGame {
    [self moreOneMovement];
    [self playMovements];
}

- (void)winTurn {
    if(turn >= [movementsList count]) {
        
        [self blockAllComponents:YES];
        self.lblCount.text = [NSString stringWithFormat:@"%d", (int)turn];
        self.imgGo.hidden = YES;
        self.imgGood.hidden = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:NEW_TURN_TIME
                                         target:self
                                       selector:@selector(playGame)
                                       userInfo:nil
                                        repeats:NO];
        turn = 0;
    }
}

- (void) loseGame {
    [self blockAllComponents:YES];
    self.imgGood.hidden = YES;
    self.imgGo.hidden = YES;
    self.imgMiss.hidden = NO;
    
    [self playSoundWithPath:SOUND_MISS];
    [NSTimer scheduledTimerWithTimeInterval:GO_TIME
                                     target:self
                                   selector:@selector(goToGameOver)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) goToGameOver {
    movementsList = [[NSMutableArray alloc]init];
    turn = 0;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    GameOverViewController *gameOverViewController = [[GameOverViewController alloc]init];
    gameOverViewController.score = [self.lblCount.text integerValue];
    gameOverViewController.usingMyo = self.useMyo;
    [self.navigationController pushViewController:gameOverViewController animated:YES];
}

#pragma mark - Animations
- (void)syncAnimation {
    lock = NO;
    self.imgPopupLostSync.hidden = YES;
    
    CATransition* outAnimation = [CATransition animation];
    [outAnimation setType:   kCATransitionReveal];
    [outAnimation setSubtype:kCATransitionFromTop];
    [outAnimation setDuration:ANIMATION_TIME];
    [outAnimation setDelegate:self];
    [[self.imgPopupLostSync layer] addAnimation:outAnimation forKey:nil];
}

- (void)unsyncAnimation {
    lock = YES;
    self.imgPopupLostSync.hidden = NO;
    
    CATransition* inAnimation = [CATransition animation];
    [inAnimation setType:   kCATransitionPush];
    [inAnimation setSubtype:kCATransitionFromBottom];
    [inAnimation setDuration:ANIMATION_TIME];
    [[self.imgPopupLostSync layer] addAnimation:inAnimation forKey:nil];
}

@end
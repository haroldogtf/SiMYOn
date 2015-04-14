//
//  GameViewController.m
//  SiMYOn
//
//  Created by Haroldo Gondim on 07/02/15.
//
//

#import "GameViewController.h"
#import "Constants.h"
#import "Util.h"
#import "GameOverViewController.h"
#import <MyoKit/MyoKit.h>
#import <AVFoundation/AVFoundation.h>
#import <stdlib.h>

@interface GameViewController ()

    @property (weak, nonatomic) IBOutlet UIImageView *imgPopupLostSync;
    @property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
    @property (weak, nonatomic) IBOutlet UIImageView *imgReady;
    @property (weak, nonatomic) IBOutlet UIImageView *imgGo;
    @property (weak, nonatomic) IBOutlet UIImageView *imgGood;
    @property (weak, nonatomic) IBOutlet UIImageView *imgMiss;

    @property (weak, nonatomic) IBOutlet UILabel *lblCount;

    @property (weak, nonatomic) IBOutlet UIButton *btnTop;
    @property (weak, nonatomic) IBOutlet UIButton *btnLeft;
    @property (weak, nonatomic) IBOutlet UIButton *btnRight;
    @property (weak, nonatomic) IBOutlet UIButton *btnBottom;
    @property (weak, nonatomic) IBOutlet UIButton *btnReturn;

    @property (strong, nonatomic) AVAudioPlayer *audio;

    @property (strong, nonatomic) NSMutableArray *movementsList;

    @property (nonatomic) NSInteger turn;

    @property (nonatomic) BOOL lock;
    @property (nonatomic) BOOL isLeftArm;
    @property (nonatomic) BOOL hasLoseGame;
    @property (nonatomic) BOOL isReturnToMainMenu;

@end

@implementation GameViewController

- (id)init {
    NSString *nibName = [self selectNibNameByModel:[Util getIphoneModel]];
    
    return [super initWithNibName:nibName bundle:nil];
}

- (id) initIsPlaySound:(BOOL)isPlaySound
             andUseMyo:(BOOL)useMyo {

    self = [self init];
    
    if(self) {
        self.playSound = isPlaySound;
        self.usingMyo = useMyo;
    }
    
    return self;
}

- (NSString *) selectNibNameByModel:(IPhoneModel) iPhoneModel {
    
    NSString *model;
    switch (iPhoneModel) {
        case IPHONE_5_5C_5S_MODEL: model = NIB_GAME_IPHONE_5_5C_5S; break;
        case IPHONE_6_MODEL:       model = NIB_GAME_IPHONE_6;       break;
        case IPHONE_6_PLUS_MODEL:  model = NIB_GAME_IPHONE_6_PLUS;  break;
        default:                   model = NIB_NOT_SUPPORTED;       break;
    }
    return model;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movementsList = [[NSMutableArray alloc]init];
    self.turn = 0;
    self.hasLoseGame = NO;
    self.isReturnToMainMenu = NO;
    [self blockAllComponents:YES];
    [self prepareMyoForNotifications];
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
           selector:@selector(didDisconnectDevice)
               name:TLMHubDidDisconnectDeviceNotification
             object:nil];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(didSyncArm:)
               name:TLMMyoDidReceiveArmSyncEventNotification
             object:nil];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(didUnsyncArm)
               name:TLMMyoDidReceiveArmUnsyncEventNotification
             object:nil];
}

- (void) prepareMyoForNotifications {
    if(self.usingMyo) {
        [self configureMyoObserver];
        self.isLeftArm = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LEFT_ARM];
    }
}

- (void)didReceivePoseChange:(NSNotification*)notification {
    if(self.usingMyo) {

        TLMPose *pose = notification.userInfo[kTLMKeyPose];

        if(!self.lock) {
            switch (pose.type) {
                case TLMPoseTypeFingersSpread: [self topAction:NO];    break;
                case TLMPoseTypeFist:          [self bottomAction:NO]; break;
                case TLMPoseTypeWaveIn:        self.isLeftArm ? [self rightAction:NO]
                                                              : [self leftAction:NO];
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

- (void)didDisconnectDevice {
    if(self.usingMyo) {
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

- (void)didUnsyncArm {
    if(self.usingMyo) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger *)buttonIndex {
    if(buttonIndex) {
        [self returnToMainMenu];
    }
}

- (void) action:(BOOL)automatic andMovemet:(Movement) movement {
    if(self.hasLoseGame) {
        [self blockAllComponents:YES];
    } else {
        if(!automatic) {
            [self makeMovementAction:movement];
            [self blockAllComponents:NO];
        }
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
    @try {
        NSInteger number = [[self.movementsList objectAtIndex:self.turn] integerValue];
        Movement turnMoviment = [self getMovement:(int)number];
        self.turn++;
        
        (turnMoviment == movement) ? [self winTurn]
                                   : [self loseGame];
    }
    @catch (NSException *exception) { return; }
}

- (void) cleanAction {
    [NSTimer scheduledTimerWithTimeInterval:CLEAN_TIME
                                     target:self
                                   selector:@selector(unlockTheGame)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - Game
- (void) changeImage:(NSString *)imageName
        andPlaySound:(NSString *)sound {
   
    if(!self.hasLoseGame) {
        self.lock = YES;
        self.imgBackground.image = [UIImage imageNamed:imageName];
        [self.imgBackground setNeedsDisplay];
        [self playSoundWithPath:sound];
        [self cleanAction];
    }
}

-(void) returnToMainMenu {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.isReturnToMainMenu = YES;
    [self.audio stop];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) playSoundWithPath:(NSString*) sound {
    if(self.playSound && !self.isReturnToMainMenu) {
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *path = [NSString stringWithFormat:@"%@/%@", resourcePath, sound];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [self.audio play];
    }
}

- (void) blockAllComponents:(BOOL)enable {
    self.lock = enable;
    self.btnTop.enabled    = !enable;
    self.btnLeft.enabled   = !enable;
    self.btnRight.enabled  = !enable;
    self.btnBottom.enabled = !enable;
}

- (Movement) getMovement:(int)movement {
    
    Movement type;
    switch (movement) {
        case 0:  type = TopMovement;    break;
        case 1:  type = LeftMovement;   break;
        case 2:  type = RightMovement;  break;
        default: type = BottomMovement; break;
    }
    return type;
}

- (void) doMovement:(Movement) movement {
    switch (movement) {
        case TopMovement:    [self topAction:YES];    break;
        case LeftMovement:   [self leftAction:YES];   break;
        case RightMovement:  [self rightAction:YES];  break;
        case BottomMovement: [self bottomAction:YES]; break;
    }
}

- (void) playMovementsWithTurn:(int)turnMovement {
    
    NSNumber *turnNumber = [NSNumber numberWithInt:turnMovement];
    id dictionary = [NSDictionary dictionaryWithObjectsAndKeys:turnNumber, TURN, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:MOVEMENT_TIME
                                     target:self
                                   selector:@selector(executeMovement:)
                                   userInfo:dictionary
                                    repeats:NO];
}


- (void) executeMovement:(id)dictionary {
    self.imgGood.hidden = YES;
    self.imgReady.hidden = NO;
    
    NSInteger turnMovement = [(NSNumber *)[[dictionary userInfo] objectForKey:TURN] integerValue];
    NSInteger number = [[self.movementsList objectAtIndex:turnMovement] integerValue];
    Movement movement = [self getMovement:(int)number];
    [self doMovement:[self getMovement:(int)movement]];
    turnMovement++;
    
    if (turnMovement < [self.movementsList count]) {
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
    [self.movementsList addObject:[NSNumber numberWithInt:[Util getRandomMovement]]];
    [self blockAllComponents:YES];
    [self playMovementsWithTurn:0];
}

- (void)winTurn {
    if(self.turn >= [self.movementsList count]) {
        
        [self blockAllComponents:YES];
        self.lblCount.text = [NSString stringWithFormat:@"%d", (int)self.turn];
        self.imgGo.hidden = YES;
        self.imgGood.hidden = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:NEW_TURN_TIME
                                         target:self
                                       selector:@selector(playGame)
                                       userInfo:nil
                                        repeats:NO];
        self.turn = 0;
    }
}

- (void) loseGame {
    self.hasLoseGame = YES;
    
    self.btnReturn.enabled = NO;

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
    self.movementsList = [[NSMutableArray alloc]init];
    self.turn = 0;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    GameOverViewController *gameViewController = [[GameOverViewController alloc]init];
    gameViewController.score = [self.lblCount.text integerValue];
    gameViewController.usingMyo = self.usingMyo;
    [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark - Animations
- (void)syncAnimation {
    self.lock = NO;
    self.imgPopupLostSync.hidden = YES;
    
    CATransition* outAnimation = [CATransition animation];
    [outAnimation setType:   kCATransitionReveal];
    [outAnimation setSubtype:kCATransitionFromTop];
    [outAnimation setDuration:ANIMATION_TIME];
    [outAnimation setDelegate:self];
    [[self.imgPopupLostSync layer] addAnimation:outAnimation forKey:nil];
}

- (void)unsyncAnimation {
    self.lock = YES;
    self.imgPopupLostSync.hidden = NO;
    
    CATransition* inAnimation = [CATransition animation];
    [inAnimation setType:   kCATransitionPush];
    [inAnimation setSubtype:kCATransitionFromBottom];
    [inAnimation setDuration:ANIMATION_TIME];
    [[self.imgPopupLostSync layer] addAnimation:inAnimation forKey:nil];
}

@end
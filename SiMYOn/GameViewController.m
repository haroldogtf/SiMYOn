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
    bool lock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lock = NO;
    
    [self prepareMyoForNotifications];
}

- (void) viewDidAppear:(BOOL)animated
{
    //[self ifMyoDisconneted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) action:(NSString *)imageName {
    lock = YES;
    self.imgBackground.image = [UIImage imageNamed:imageName];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(unlockTheGame:) userInfo:nil repeats:NO];
}

- (void)unlockTheGame:(id)sender {
    self.imgBackground.image = [UIImage imageNamed:@"game.png"];
    lock = NO;
}

- (void) topAction {
    [self action:@"game_top.png"];
    NSLog(@"spread");
}

- (void) leftAction {
    [self action:@"game_left.png"];
    NSLog(@"left");
}

- (void) rightAction {
    [self action:@"game_right.png"];
    NSLog(@"right");
}

- (void) bottomAction {
    [self action:@"game_bottom.png"];
    NSLog(@"first");
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
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) configureMyo {
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) ifMyoDisconneted {
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

@end
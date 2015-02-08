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

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareMyoForNotifications];
}

- (void) viewDidAppear:(BOOL)animated
{
    //[self ifMyoDisconneted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) topAction {
    self.imgBackground.image = [UIImage imageNamed:@"game_top.png"];
    NSLog(@"spread");
}

- (void) leftAction {
    self.imgBackground.image = [UIImage imageNamed:@"game_left.png"];
    NSLog(@"left");
}

- (void) rightAction {
    self.imgBackground.image = [UIImage imageNamed:@"game_right.png"];
    NSLog(@"right");
}

- (void) bottomAction {
    self.imgBackground.image = [UIImage imageNamed:@"game_bottom.png"];
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

        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest:
        case TLMPoseTypeDoubleTap:
        default:
            [pose.myo unlockWithType:TLMUnlockTypeHold];
            break;
    }
    
}

- (void)didDisconnectDevice:(NSNotification*)notification {
    [self configureMyo];
}

- (void)didUnsyncArm:(NSNotification*)notification {
    NSLog(@"unsync");
}

@end
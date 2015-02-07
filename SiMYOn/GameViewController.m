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
    [self ifMyoDisconneted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) topAction {
    NSLog(@"spread");
}

- (void) bottomAction {
    NSLog(@"first");
}

- (void) leftAction {
    NSLog(@"left");
}

- (void) rightAction {
    NSLog(@"right");
}

- (IBAction)btnTopAction:(id)sender {
    [self topAction];
}

- (IBAction)btnBottomAction:(id)sender {
    [self bottomAction];
}

- (IBAction)btnLeftAction:(id)sender {
    [self leftAction];
}

- (IBAction)btnRightAction:(id)sender {
    [self rightAction];
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
            NSLog(@"pose");
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